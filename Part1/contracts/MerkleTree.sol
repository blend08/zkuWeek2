//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        for (uint32 i = 1; i < 16; i++){
            hashes.push(0);
        }
        
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        
        uint256 _nextIndex = index;
        require(_nextIndex != uint32(2)**3, "Merkle tree is full. No more leaves can be added");
        uint256 currentIndex = _nextIndex;
        uint256 currentLevelHash = hashedLeaf;
        uint256 left;
        uint256 right;

        for (uint32 i = 1; i < 3; i++) {
        if (currentIndex % 2 == 0) {
            left = currentLevelHash;
            right = 0;
            hashes[i] = currentLevelHash;
        } else {
            left = hashes[i];
            right = currentLevelHash;
        }
        currentLevelHash = PoseidonT3.poseidon([left, right]);
        currentIndex /= 2;
        }

        
        root = currentLevelHash;
        index += 1;
        return _nextIndex;

    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root

        return verifyProof(a, b, c, input);
    }
}
