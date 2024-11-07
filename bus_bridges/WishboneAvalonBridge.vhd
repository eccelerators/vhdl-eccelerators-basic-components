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

entity WishboneAvalonBridge is
    port (
        S_WB_CYC_I : in std_logic;
        S_WB_STB_I : in std_logic;
        S_WB_ADR_I : in std_logic_vector(31 downto 0);
        S_WB_WE_I : in std_logic;
        S_WB_SEL_I : in std_logic_vector(3 downto 0);
        S_WB_DAT_I : in std_logic_vector(31 downto 0);       
        S_WB_DAT_O : out std_logic_vector(31 downto 0);
        S_WB_ACK_O : out std_logic;
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

architecture Behavioural of WishboneAvalonBridge is

    signal wb_cyc_i : std_logic;
    signal wb_stb_i : std_logic;
    signal wb_adr_i : std_logic_vector(31 downto 0);
    signal wb_we_i : std_logic;
    signal wb_sel_i : std_logic_vector(3 downto 0);
    signal wb_dat_i : std_logic_vector(31 downto 0);
    signal wb_dat_o : std_logic_vector(31 downto 0);
    signal wb_ack_o : std_logic;

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

begin

    wb_cyc_i <= S_WB_CYC_I;
    wb_stb_i <= S_WB_STB_I;
    wb_adr_i <= S_WB_ADR_I;
    wb_we_i <= S_WB_WE_I;
    wb_sel_i <= S_WB_SEL_I;
    wb_dat_i <= S_WB_DAT_I;

    S_WB_DAT_O <= wb_dat_o;
    S_WB_ACK_O <= wb_ack_o;

    M_AVALON_address <= av_address;
    M_AVALON_byteenable <= av_byteenable;
    M_AVALON_write <= av_write;
    M_AVALON_writedata <= av_writedata;        
    M_AVALON_read <= av_read;
    av_readdata <= M_AVALON_readdata;
    av_readdatavalid <= M_AVALON_readdatavalid; 
    av_waitrequest <= M_AVALON_waitrequest;

    av_address <= wb_adr_i;
    av_byteenable <= wb_sel_i;
    av_write <= wb_cyc_i and wb_stb_i and wb_we_i;
    av_read <= wb_cyc_i and wb_stb_i and not wb_we_i;
    av_writedata <= wb_dat_i;
     
    wb_ack_o <= not av_waitrequest;
    wb_dat_o <= av_readdata;

    -- av_readdatavalid unused, burst transfers via the bridge are not supported yet
    -- av_response unused, response transfers via the bridge are not supported yet
    -- av_writeresponsevalid unused, response transfers via the bridge are not supported yet
    
end;
