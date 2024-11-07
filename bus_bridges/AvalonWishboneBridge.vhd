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

entity AvalonWishboneBridge is
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
        M_WB_CYC_O : out std_logic;
        M_WB_STB_O : out std_logic;
        M_WB_ADR_O : out std_logic_vector(31 downto 0);
        M_WB_WE_O : out std_logic;
        M_WB_SEL_O : out std_logic_vector(3 downto 0);
        M_WB_DAT_O : out std_logic_vector(31 downto 0);
        M_WB_DAT_I : in std_logic_vector(31 downto 0);
        M_WB_ACK_I : in std_logic
    );
end;

architecture Behavioural of AvalonWishboneBridge is

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

    signal wb_cyc_o : std_logic;
    signal wb_stb_o : std_logic;
    signal wb_adr_o : std_logic_vector(31 downto 0);
    signal wb_we_o : std_logic;
    signal wb_sel_o : std_logic_vector(3 downto 0);
    signal wb_dat_o : std_logic_vector(31 downto 0);
    signal wb_dat_i : std_logic_vector(31 downto 0);
    signal wb_ack_i : std_logic;

begin

    av_address <= S_AVALON_address;
    av_byteenable <= S_AVALON_byteenable;
    av_write <= S_AVALON_write;
    av_writedata <= S_AVALON_writedata;        
    av_read <= S_AVALON_read;
    S_AVALON_readdata <= av_readdata;
    S_AVALON_readdatavalid <= av_readdatavalid; 
    S_AVALON_waitrequest <= av_waitrequest;

    M_WB_CYC_O <= wb_cyc_o;
    M_WB_STB_O <= wb_stb_o;
    M_WB_ADR_O <= wb_adr_o;
    M_WB_WE_O <= wb_we_o;
    M_WB_SEL_O <= wb_sel_o;
    M_WB_DAT_O <= wb_dat_o;

    wb_dat_i <= M_WB_DAT_I;
    wb_ack_i <= M_WB_ACK_I;
    
    wb_adr_o <= av_address;
    wb_sel_o <= av_byteenable;
   
    wb_cyc_o <= av_write or av_read;
    wb_stb_o <= av_write or av_read;
    wb_we_o  <= av_write;
    wb_dat_o <= av_writedata;
    
    av_waitrequest <= not wb_ack_i;
    av_readdata <= wb_dat_i;

    av_readdatavalid <= '0'; -- burst transfers via the bridge are not supported yet
    av_response <= "00"; -- response transfers via the bridge are not supported yet
    av_writeresponsevalid <= '0'; -- response transfers via the bridge are not supported yet
    
end;
