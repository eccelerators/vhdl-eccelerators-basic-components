-- ******************************************************************************
-- 
--                   /------o
--             eccelerators
--          o------/
-- 
--  This file is an Eccelerators GmbH sample project.
-- 
--  MIT License:
--  Copyright (c) 2023 Eccelerators GmbH
-- 
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- 
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
-- 
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.
-- ******************************************************************************

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity Axi4LiteAvalonBridge is
    port (
        S_AXI_ACLK : in std_logic;
        S_AXI_ARESETN : in std_logic;
        S_AXI_AWADDR : in std_logic_vector(31 downto 0);
        S_AXI_AWPROT : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID : in std_logic;
        S_AXI_AWREADY : out std_logic;
        S_AXI_WDATA : in std_logic_vector(31 downto 0);
        S_AXI_WSTRB : in std_logic_vector(3 downto 0);
        S_AXI_WVALID : in std_logic;
        S_AXI_WREADY : out std_logic;
        S_AXI_BRESP : out std_logic_vector(1 downto 0);
        S_AXI_BVALID : out std_logic;
        S_AXI_BREADY : in std_logic;
        S_AXI_ARADDR : in std_logic_vector(31 downto 0);
        S_AXI_ARPROT : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID : in std_logic;
        S_AXI_ARREADY : out std_logic;
        S_AXI_RDATA : out std_logic_vector(31 downto 0);
        S_AXI_RRESP : out std_logic_vector(1 downto 0);
        S_AXI_RVALID : out std_logic;
        S_AXI_RREADY : in std_logic;
        M_AVALON_address : out std_logic_vector(31 downto 0);
        M_AVALON_byteenable : out std_logic_vector(3 downto 0);
        M_AVALON_write : out std_logic;
        M_AVALON_writedata: out std_logic_vector(31 downto 0);
        M_AVALON_read : out std_logic;
        M_AVALON_readdata : in std_logic_vector(31 downto 0);
        M_AVALON_readdatavalid : in std_logic;
        M_AVALON_waitrequest : in std_logic;
        M_AVALON_response : in std_logic_vector(1 downto 0);
        M_AVALON_writeresponsevalid : in std_logic
       
    );
end;

architecture Behavioural of Axi4LiteAvalonBridge is

    signal axi_awaddr : std_logic_vector(31 downto 0);
    signal axi_awprot : std_logic_vector(2 downto 0);
    signal axi_awvalid : std_logic;
    signal axi_awready : std_logic;
    signal axi_wdata : std_logic_vector(31 downto 0);
    signal axi_wstrb : std_logic_vector(3 downto 0);
    signal axi_wvalid : std_logic;
    signal axi_wready : std_logic;
    signal axi_bresp : std_logic_vector(1 downto 0);
    signal axi_bvalid : std_logic;
    signal axi_bready : std_logic;
    signal axi_araddr : std_logic_vector(31 downto 0);
    signal axi_arprot : std_logic_vector(2 downto 0);
    signal axi_arvalid : std_logic;
    signal axi_arready : std_logic;
    signal axi_rdata : std_logic_vector(31 downto 0);
    signal axi_rresp : std_logic_vector(1 downto 0);
    signal axi_rvalid : std_logic;
    signal axi_rready : std_logic;
    signal av_address : std_logic_vector(31 downto 0);
    signal av_byteenable : std_logic_vector(3 downto 0);
    signal av_write : std_logic;
    signal av_writedata : std_logic_vector(31 downto 0);        
    signal av_read : std_logic;
    signal av_readdata : std_logic_vector(31 downto 0);
    signal av_readdatavalid : std_logic; 
    signal av_waitrequest : std_logic;
    signal av_response : std_logic_vector(1 downto 0);
    signal av_writeresponsevalid : std_logic;

    signal AxiSlaveState : unsigned(7 downto 0);

    constant AxiSlaveStateIdle0 : natural := 0;
    constant AxiSlaveStateReadCyc0 : natural := 1;
    constant AxiSlaveStateReadAck0 : natural := 2;
    constant AxiSlaveStateWriteCyc0 : natural := 3;
    constant AxiSlaveStateWriteCyc1 : natural := 4;
    constant AxiSlaveStateWriteAck0 : natural := 5;

    constant AXI_RESPONSE_OKAY : std_logic_vector(1 downto 0) := "00";

begin

    S_AXI_AWREADY <= axi_awready;
    S_AXI_WREADY <= axi_wready;
    S_AXI_BRESP    <= axi_bresp;
    S_AXI_BVALID <= axi_bvalid;
    S_AXI_ARREADY <= axi_arready;
    S_AXI_RDATA    <= axi_rdata;
    S_AXI_RRESP    <= axi_rresp;
    S_AXI_RVALID <= axi_rvalid;

    axi_awaddr <= S_AXI_AWADDR;
    axi_awprot <= S_AXI_AWPROT;
    axi_awvalid <= S_AXI_AWVALID;
    axi_wdata <= S_AXI_WDATA;
    axi_wstrb <= S_AXI_WSTRB;
    axi_wvalid <= S_AXI_WVALID;
    axi_bready <= S_AXI_BREADY;
    axi_araddr <= S_AXI_ARADDR;
    axi_arprot <= S_AXI_ARPROT;
    axi_arvalid <= S_AXI_ARVALID;
    axi_rready <= S_AXI_RREADY;

    axi_bresp <= AXI_RESPONSE_OKAY;
    axi_rresp <= AXI_RESPONSE_OKAY;

    M_AVALON_address <= av_address;
    M_AVALON_byteenable <= av_byteenable;
    M_AVALON_write <= av_write;
    M_AVALON_writedata <= av_writedata;        
    M_AVALON_read <= av_read;
    av_readdata <= M_AVALON_readdata;
    av_readdatavalid <= M_AVALON_readdatavalid; 
    av_waitrequest <= M_AVALON_waitrequest;
    
    av_response <= M_AVALON_response; -- response transfers via the bridge are not supported yet
    av_writeresponsevalid <= M_AVALON_writeresponsevalid;
    
    av_readdatavalid <= '0'; -- burst transfers via the bridge are not supported yet

    AxiLiteSlave : process(S_AXI_ARESETN, S_AXI_ACLK)
    begin
        if S_AXI_ARESETN = '0' then
            axi_arready <= '0';
            axi_rvalid <= '0';
            axi_rdata <= (others => '0');
            axi_awready <= '0';
            axi_wready <= '0';
            axi_bvalid <= '0';               
            av_address <= (others => '0');
            av_byteenable <= (others => '0');
            av_write <= '0';
            av_writedata <= (others => '0');
            av_read <= '0';          
            AxiSlaveState <= to_unsigned(AxiSlaveStateIdle0, AxiSlaveState'LENGTH);
        elsif rising_edge(S_AXI_ACLK) then
            if AxiSlaveState = AxiSlaveStateIdle0 then
                axi_arready <= '0';
                axi_rvalid <= '0';
                axi_rdata <= (others => '0');
                axi_awready <= '0';
                axi_wready <= '0';
                axi_bvalid <= '0';
                av_address <= (others => '0');
                av_byteenable <= (others => '0');
                av_write <= '0';
                av_writedata <= (others => '0');
                av_read <= '0';
                if axi_arvalid = '1' then
                    av_address <= axi_araddr;
                    av_byteenable <= axi_wstrb;
                    av_read <= '1';
                    AxiSlaveState <= to_unsigned(AxiSlaveStateReadCyc0, AxiSlaveState'LENGTH);
                elsif axi_awvalid = '1' then
                    av_address <= axi_awaddr;
                    AxiSlaveState <= to_unsigned(AxiSlaveStateWriteCyc0, AxiSlaveState'LENGTH);
                end if;
            elsif AxiSlaveState = AxiSlaveStateReadCyc0 then
                 if ( av_waitrequest = '0' ) then
                    axi_rdata <= av_readdata;
                    axi_arready <= '1';
                    axi_rvalid <= '1';
                    AxiSlaveState <= to_unsigned(AxiSlaveStateReadAck0, AxiSlaveState'LENGTH);
                end if;
            elsif AxiSlaveState = AxiSlaveStateReadAck0 then
                axi_arready <= '0';
                av_read <= '0';
                if axi_rready = '1' then
                    axi_rvalid <= '0';
                    AxiSlaveState <= to_unsigned(AxiSlaveStateIdle0, AxiSlaveState'LENGTH);
                else
                    axi_rvalid <= '1';
                end if;
            elsif AxiSlaveState = AxiSlaveStateWriteCyc0 then
                if axi_wvalid = '1' then               
                    av_byteenable <= axi_wstrb;
                    av_write <= '1';
                    av_writedata <= axi_wdata;                                    
                    AxiSlaveState <= to_unsigned(AxiSlaveStateWriteCyc1, AxiSlaveState'LENGTH);
                end if;
            elsif AxiSlaveState = AxiSlaveStateWriteCyc1 then
                 if av_waitrequest = '0' then
                    axi_awready <= '1';
                    axi_wready <= '1';
                    axi_bvalid <= '1';
                    AxiSlaveState <= to_unsigned(AxiSlaveStateWriteAck0, AxiSlaveState'LENGTH);
                 end if;
            elsif AxiSlaveState = AxiSlaveStateWriteAck0 then
                axi_awready <= '0';
                axi_wready <= '0';              
                av_address <= (others => '0');
                av_byteenable <= (others => '0');
                av_write <= '0';
                av_writedata <= (others => '0');
                av_read <= '0';               
                
                if axi_bready = '1' then
                    axi_bvalid <= '0';
                    AxiSlaveState <= to_unsigned(AxiSlaveStateIdle0, AxiSlaveState'LENGTH);
                end if;
            else
                AxiSlaveState <= to_unsigned(AxiSlaveStateIdle0, AxiSlaveState'LENGTH);
            end if;
      end if;
    end process;

end;
