#![crate_type = "dylib"]
#![no_std]
#![allow(ctypes)]
#![feature(link_args)]

extern crate libc;
use libc::c_float;

#[no_mangle]
pub extern fn normalize(p_in: *c_float, p_out: *c_float) -> int {0}

