// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Caster {
    function getOrigin() public pure returns(address) {
        return 0x99923C8Ab4C3f80ee00aF36E9725595B15FD27F3;
    }

    function originToU160ToU16() public pure returns(uint16) {
        return uint16(uint160(getOrigin()));
    }

    function originToU160ToU16ToB8() public pure returns(bytes8) {
        return bytes8(uint64(uint160(getOrigin())));
    }

    function toB8(uint from) public pure returns(bytes8) {
        return bytes8(uint64(from));
    } 

    function toU64(bytes8 _data) public pure returns(uint64) {
        return uint64(_data);
    }

    function toU64ToU32(bytes8 _data) public pure returns(uint32) {
        return uint32(uint64(_data));
    }

    function toU64ToU16(bytes8 _data) public pure returns(uint16) {
        return uint16(uint64(_data));
    }

    function test(bytes8 _gateKey) public pure returns(bool) {
        return (
            (uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)))
            && (uint32(uint64(_gateKey)) != uint64(_gateKey))
            && (uint32(uint64(_gateKey)) == uint16(uint160(getOrigin())))
        );
    }
}