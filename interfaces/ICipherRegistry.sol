// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;
interface ICipherRegistry {
    function appendCipherRecord(bytes32 recordHash, string calldata ipfsCid) external returns (uint256);
    function verifyRecordIntegrity(uint256 recordId) external view returns (bool);
}
