// Copyright 2024 RISC Zero, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.20;

import {RiscZeroCheats} from "risc0/RiscZeroCheats.sol";
import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";
import {IRiscZeroVerifier} from "risc0/IRiscZeroVerifier.sol";
import {AADemo} from "../contracts/AADemo.sol";
import "forge-std/console.sol";
import {Elf} from "./Elf.sol"; // auto-generated contract after running `cargo build`.

contract AADemoTest is RiscZeroCheats, Test {
    AADemo public aaDemo;
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public charlie = makeAddr("charlie");

    struct Input {
        uint256 id_provider;
        string jwt;
    }

    function setUp() public {
        IRiscZeroVerifier verifier = deployRiscZeroVerifier();
        aaDemo = new AADemo(verifier);

        // fund alice and bob and charlie
        vm.deal(alice, 5 ether);
        vm.deal(bob, 5 ether);
        vm.deal(charlie, 5 ether);
        vm.deal(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8, 5 ether);
        vm.deal(payable(address(aaDemo)),5 ether);
    }

    function test_SetOwner() public payable {
        bytes32 claimId = sha256(abi.encodePacked("bob@email.com"));
        vm.prank(alice);
        aaDemo.setOwner(claimId);
        assertEq(aaDemo.owner() , claimId);
    }

    function test_Execute() public {
        // deposit as alice
        bytes32 claimId = sha256(abi.encodePacked("johnkenny6799@gmail.com"));
        vm.prank(alice);

        // claim as bob

        string memory jwt ="eyJhbGciOiJSUzI1NiIsImtpZCI6IjNkNTgwZjBhZjdhY2U2OThhMGNlZTdmMjMwYmNhNTk0ZGM2ZGJiNTUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc3MzYzNTE4MjIzNTY1NTc3NDkiLCJlbWFpbCI6ImpvaG5rZW5ueTY3OTlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5vbmNlIjoiMHgyM0Q0YThkMjZCNzc3YzFGRGNCQjc0YWZhNzlDQWRBMWNhRjc3MkY4IiwibmJmIjoxNzE4NjMyMTIwLCJuYW1lIjoiSm9obiBLZW5ueSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKdHczTGFqNXdUNUN4QjV2ZzJySjJkSnlHWWpTX29MaXliMEkzTDIwTmJFeHBBdXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSm9obiIsImZhbWlseV9uYW1lIjoiS2VubnkiLCJpYXQiOjE3MTg2MzI0MjAsImV4cCI6MTcxODYzNjAyMCwianRpIjoiZDg5MmRlZjdmMjZlYWMxZGJiZDU4YzI2ZTc1MDI0NTU2YzI1NGVlZSJ9.Rj0phisb3nb-fkXABQaksABIMsyvAAyfHCeyNekAHFlY4HTDNwpiud5qdGR5u3dEZ5Y_-CdU6eFXWVQ-ry8EiDhK8267j8jcIcb60unWQnDR7e2MYJBwgdZh0f8teru4FYIVXW88-PRDdT3WuurQOXyUxrS1gsq0EZH580HAl98b0RdmrXcRolKGv5f9gzk9cZApvZomUydr2SRqAvhU5Sxbg18uHjYU2q1LO8uJSlKyC8xx-J6gZEf3c-izYmeSsSp92XrPMIOeTfWtr-QcVimPnOl3g5U7Jld7UU7FIl-WBvkCH4jzJpFytwTJZh36hV6hXL78sADkKQMjCp7IQA";
        uint256 id_provider = 1;

        Input memory input = Input({id_provider: id_provider, jwt: jwt});

        (bytes memory journal, bytes32 post_state_digest, bytes memory seal) = prove(Elf.JWT_VALIDATOR_PATH, abi.encode(input));

        bytes memory fake_seal = hex"2e454bf4b1f037fabbc88665af1b10a413d03859bff26141e299ff24a94b2d50180c0824f309091336fb5d24a753edd094f9bada83185060a4a70e26afd63a0e0be098c6abad5e725423fc7256e53b51a891a619039a070eb09c4679dcb0d68713d8b92cf6fdc7035458cdd5dbceded84028751210a85f11b86d56209505b31f099d8b4843131a5f467c0140092717540c85564c907c0a1168c7a8091b60fe8a2568dcc69b5435a9d9f99ac6c62762df2f470926139de04618ca1bc04398088e07ba2c6861b0a8c3ccee2306d4e8dc02745a95591e10af36fc05b5faac0774fb01e7d34b5a5bb18531e57e088e49d0b7d98cbc8b6e5ad123b946d3f5920421a7";
        vm.prank(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8);
        aaDemo.setOwner(claimId);        
        console.logBytes32(aaDemo.owner());

        vm.prank(alice);
        aaDemo.execute(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8), 1 ether , "", claimId, 0xa3acc27117418996340b84e5a90f3ef4c49d22c79e44aad822ec9c313e1eb8e2,fake_seal);
        assertEq(payable(address(aaDemo)).balance, 4 ether);
        assertEq(address(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8).balance, 6 ether);        
    }
    




}
