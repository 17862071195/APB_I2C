//=======================================================================
// COPYRIGHT (C) 2018-2020 RockerIC, Ltd.
// This software and the associated documentation are confidential and
// proprietary to RockerIC, Ltd. Your use or disclosure of this software
// is subject to the terms and conditions of a consulting agreement
// between you, or your company, and RockerIC, Ltd. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
// VisitUs  : www.rockeric.com
// Support  : support@rockeric.com
// WeChat   : eva_bill 
//-----------------------------------------------------------------------
//`timescale 1ns/1ps
`ifndef LVC_APB_PKG_SV
`define LVC_APB_PKG_SV

package lvc_apb_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

parameter bit[31:0] DEFAULT_READ_VALUE = 32'hFFFF_FFFF;
`include "lvc_apb.svh"

endpackage : lvc_apb_pkg

   
`endif //  `ifndef LVC_APB_PKG_SV
