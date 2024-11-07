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

entity AvalonAxi4LiteBridge is
    port (
        S_AVALON_address : in std_logic_vector(31 downto 0);
        S_AVALON_byteenable : in std_logic_vector(3 downto 0);
        S_AVALON_write : in std_logic;
        S_AVALON_writedata: in std_logic_vector(31 downto 0);
        S_AVALON_read : in std_logic;
        S_AVALON_readdata : out std_logic_vector(31 downto 0);
        S_AVALON_readdatavalid : out std_logic;
        S_AVALON_waitrequest : out std_logic;
        S_AVALON_response : out std_logic_vector(1 downto 0);
        S_AVALON_writeresponsevalid : out std_logic;
        M_AXI_ACLK : out std_logic;
        M_AXI_ARESETN : out std_logic;
        M_AXI_AWADDR : out std_logic_vector(31 downto 0);
        M_AXI_AWPROT : out std_logic_vector(2 downto 0);
        M_AXI_AWVALID : out std_logic;
        M_AXI_AWREADY : in std_logic;
        M_AXI_WDATA : out std_logic_vector(31 downto 0);
        M_AXI_WSTRB : out std_logic_vector(3 downto 0);
        M_AXI_WVALID : out std_logic;
        M_AXI_WREADY : in std_logic;
        M_AXI_BRESP : in std_logic_vector(1 downto 0);
        M_AXI_BVALID : in std_logic;
        M_AXI_BREADY : out std_logic;
        M_AXI_ARADDR : out std_logic_vector(31 downto 0);
        M_AXI_ARPROT : out std_logic_vector(2 downto 0);
        M_AXI_ARVALID : out std_logic;
        M_AXI_ARREADY : in std_logic;
        M_AXI_RDATA : in std_logic_vector(31 downto 0);
        M_AXI_RRESP : in std_logic_vector(1 downto 0);
        M_AXI_RVALID : in std_logic;
        M_AXI_RREADY : out std_logic
    );
end;

architecture Behavioural of AvalonAxi4LiteBridge is

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

    signal axi_awaddr : std_logic_vector(31 downto 0); 
    signal axi_awprot : std_logic_vector(2 downto 0);
    signal axi_awvalid : std_logic; 
    signal axi_awready : std_logic; 
    -- 
    signal axi_wdata : std_logic_vector(31 downto 0); 
    signal axi_wstrb : std_logic_vector(3 downto 0); 
    signal axi_wvalid : std_logic; 
    -- 
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

begin

    av_address <= S_AVALON_address;
    av_byteenable <= S_AVALON_byteenable;
    av_write <= S_AVALON_write;
    av_writedata <= S_AVALON_writedata;        
    av_read <= S_AVALON_read;
    S_AVALON_readdata <= av_readdata;
    S_AVALON_readdatavalid <= av_readdatavalid; 
    S_AVALON_waitrequest <= av_waitrequest;
    
    -- Read Address Channel
    M_AXI_ARADDR <= axi_araddr; -- Read address, usually 32-bit wide.
    -- M_AXI_ARCACHE -- Memory type. Xilinx IP usually ignores this value if a slave. IP as a master generates transactions with Normal Non-cacheable Modifiable and Bufferable (0011).
    M_AXI_ARPROT <= axi_arprot; -- Protection type. Xilinx IP usually ignores as a slave. As a master IP generates transactions with Normal, Secure, and Data attributes (000).
    M_AXI_ARVALID <= axi_arvalid; -- Read address valid. Master generates this signal when Read Address and the control signals are valid.
    axi_arready <= M_AXI_ARREADY; -- Ready for Read address. Slave generates this signal when it can accept the read address and control signals.
     
    -- Read Data Channel
    axi_rdata <= M_AXI_RDATA; -- Read Data (32-bit only).
    axi_rresp <= M_AXI_RRESP; -- Read response. This signal indicates the status of data transfer.
    axi_rvalid <= M_AXI_RVALID; -- Read valid. Slave generates this signal when Read Data is valid.
    M_AXI_RREADY <= axi_rready; -- Read ready. Master generates this signal when it can accept the Read Data and response.
       
    -- Write Address Channel
    M_AXI_AWADDR <= axi_awaddr; -- Write address, usually 32-bits wide.
    -- M_AXI_AWCACHE -- Memory type. Slave IP usually ignores and Master IP generates transactions as Normal Non-cacheable Modifiable and Bufferable (0011).
    M_AXI_AWPROT <= axi_awprot; -- Protection type. Slave IP usually ignores and Master IP generates transactions with Normal, Secure and Data attributes (000).
    M_AXI_AWVALID <= axi_awvalid; -- Write address valid. Master generates this signal when Write Address and control signals are valid.
    axi_awready <= M_AXI_AWREADY; -- Ready for Write address. Slave generates this signal when it can accept Write Address and control signals.
    
    -- Write Data Channel
    M_AXI_WDATA <= axi_wdata; -- Write data (32-bit only).
    M_AXI_WSTRB <= axi_wstrb; -- Write strobes. 4-bit signal indicating which of the 4-bytes of Write Data. Slaves can choose assume all bytes are valid.
    M_AXI_WVALID <= axi_wvalid; -- Write data valid. Master generates this signal when Write data and strobes signals are valid.
    axi_wready <= M_AXI_WREADY; -- Ready for Write data. Slave generates this signal when it can accept Write data and strobes signals.
    
    -- Write Response Channel
    axi_bresp <= M_AXI_BRESP; -- Write response. This signal indicates the status of the write transaction.
    axi_bvalid <= M_AXI_BVALID; -- Write response valid. Slave generates this signal when the write response on the bus is valid.
    M_AXI_BREADY <= axi_bready; -- Ready for response. Slave generates this signal when it can accept response signals.
    
    -- rresp and bresp status codes
    -- '00' = OKAY - Normal access has been successful.
    -- '01' = EXOKAY - Not supported.1
    -- '10' = SLVERR - Error.
    -- '11' = DECERR - Not supported. 

    axi_araddr <= av_address;
    axi_arprot <= "000";
    axi_arvalid <= av_read;
    
    axi_awaddr <= av_address;
    axi_awprot <= "000";
    axi_awready <= av_write;
    
    av_readdata <= axi_rdata;
    axi_rready <= av_read;
    
    
    axi_wdata <= av_writedata;
    axi_wstrb <= av_byteenable;
    axi_wvalid <= av_write;
      
    av_waitrequest <= '0' when av_write and axi_wready else
                      '0' when av_read and axi_rvalid else
                      '1';
                      
    av_readdatavalid <= '0'; -- burst transfers via the bridge are not supported yet
    
    -- axi_rresp, not utilized
    -- axi_bresp, not utilized
    -- axi_bvalid, not utilized
    axi_bready <= av_write;
    av_response <= "00"; -- response transfers via the bridge are not supported yet
    av_writeresponsevalid <= '0'; -- response transfers via the bridge are not supported yet

    
end;
