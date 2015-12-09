-- **********************************************************************
-- 
-- Copyright 2015 by Sean Conner.  All Rights Reserved.
-- 
-- This program is free software: you can redistribute it and/or modify    
-- it under the terms of the GNU General Public License as published by 
-- the Free Software Foundation, either version 3 of the License, or 
-- any later version.                  
-- 
-- This program is distributed in the hope that it will be useful, 
-- but WITHOUT ANY WARRANTY; without even the implied warranty of 
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
-- GNU General Public License for more details. 
-- 
-- You should have received a copy of the GNU General Public License 
-- along with this program.  If not, see <http://www.gnu.org/licenses/>. 
--
-- Comments, questions and criticisms can be sent to: sean@conman.org
--
-- **********************************************************************

local lpeg = require "lpeg"
local P = lpeg.P
local S = lpeg.S
local R = lpeg.R
local V = lpeg.V

-- Ah RFC-822 email addresses!  They must have *really* loved
-- parser theory back in the 70s.

local CRLF          = P"\r"^-1 * P"\n"
local WSP           = S" \t"
local FWS           = (WSP^0 * CRLF)^-1 * WSP^1
local VCHAR         = R"!~"
local qtext         = R("!!" , "#[" , "]~")
local quoted_pair   = P"\\" * (VCHAR + WSP)
local qcontent      = qtext + quoted_pair
local ctext         = R("!'" , "*[" , "]~")

-- Yes, Virginia, you can do recursive grammars
-- with LPeg, with lpeg.P() and lpeg.V().  We
-- need this to support *comments*

local CFWS = P {
  "CFWS",
  ccontent = ctext + quoted_pair + V"comment",
  comment  = P"(" * (FWS^-1 * V"ccontent")^0 * FWS^-1 * P")",
  CFWS     = (FWS^-1 * V"comment")^-1 * FWS^-1
}

local atext          = S("ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                     .. "abcdefghijklmnopqrstuvwxyz"
                     .. "0123456789!#$%&'*+-/=?~_`{|}~")
local dot_atom_text  = atext^1 * ( P"." * atext^0)^0
local dot_atom       = (CFWS^-1 * dot_atom_text * CFWS^-1)^1
local quoted_string  = CFWS^-1 * P'"' * (FWS^-1 * qcontent)^0 * FWS^-1 * P'"' * CFWS^-1
local dtext          = R("!Z" , "^~")
local domain_literal = CFWS^-1 * P"[" * (FWS^-1 * dtext)^0 * FWS^-1 * P"]" * CFWS^-1
local domain         = dot_atom + domain_literal
local local_part     = dot_atom + quoted_string
local addr_spec      = local_part * P"@" * domain

okay = addr_spec:match "Muhammed.(I am  the greatest) Ali @(the)Vegas.WBA"

