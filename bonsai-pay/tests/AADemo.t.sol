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
        console.logBytes32(aaDemo.owner());
        assertEq(aaDemo.owner() , claimId);
    }

    function test_Execute() public {
        // deposit as alice
        bytes32 claimId = sha256(abi.encodePacked("johnkenny6799@gmail.com"));
        vm.prank(alice);

        // claim as bob
       
        string memory jwt ="eyJhbGciOiJSUzI1NiIsImtpZCI6ImFjM2UzZTU1ODExMWM3YzdhNzVjNWI2NTEzNGQyMmY2M2VlMDA2ZDAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc3MzYzNTE4MjIzNTY1NTc3NDkiLCJlbWFpbCI6ImpvaG5rZW5ueTY3OTlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5vbmNlIjoiMHhjNTA3NzcxNjI5RjREZDYxQjZjZjhkRjc4YjIyODc0ZjAyMzkzNzI2IiwibmJmIjoxNzE1MDU5NTgxLCJuYW1lIjoiSm9obiBLZW5ueSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKdHczTGFqNXdUNUN4QjV2ZzJySjJkSnlHWWpTX29MaXliMEkzTDIwTmJFeHBBdXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSm9obiIsImZhbWlseV9uYW1lIjoiS2VubnkiLCJpYXQiOjE3MTUwNTk4ODEsImV4cCI6MTcxNTA2MzQ4MSwianRpIjoiZDRiYTg2NjBkNGMxOWI2NGM5NGViMjQzODM1NWUxOWFkN2I5ZDBjMSJ9.LL6J31FCk7Omir2vCdHgZH-373Ex-0pq7-b1uljw_enfenivcSBY8y0UMcVDFoZsaYUlEZwUEN_kDw77vtKbcUpE1artzibo-w44ofV9wqDeLITOKdZnSzWlt9sDDE2Qxj-Mz43FEQufbUqLd2sXP_i6lqap_8iIaGQ5ZtdFL7dr0FZGPff3KBbWX3ctJcDW8TvLCnp3pJwMiwCS2HFkLyOuKyeeHhpaVDqG-fXDxiq7tFd8S79eXvVdtDQpeLWPO2BbQiLkDA6UjqsPA3KY8IuJPXlp4dUsprzJxMrZpH9cnwwlB7j32Eo3C90d8j6a7g-4gDZ3K1g-Al2IXEalng";
        uint256 id_provider = 1;

        Input memory input = Input({id_provider: id_provider, jwt: jwt});

        (bytes memory journal, bytes32 post_state_digest, bytes memory seal) = prove(Elf.JWT_VALIDATOR_PATH, abi.encode(input));
        
        bytes memory fake_seal = hex"02e44998e744ff5881d4e24a36f77694dc0247b9b9ad1956faa2ca64a5f28360177806f5d61809c34262b57167077a129257569f7fd9aee0d1dc36990d09c6ff27f8c5c06e5dc5cbdf982e22f27773ca75c8ddbc2c806f5fec50bb55c0a566791655366dc77a94396d9acb2c69a298a34fc8392f15202cfc5f716bee340b896212984698a125345df1abee9e4ce525ac11fad14f78f2318287b68039163a13b12edf9209a56ff6b90d153617e5cfa091ee694e1c610dd4e45ce8a3008bda1ce000c2d22ad3916dd9397e17039e6f32d49d1fc2d4b18569a4051dce0e5f1dbd6015b6558d9cfd06df2f8fbf52a6bef69b61d81655f91ac28ffcca6ea6e2e9753e";
        vm.prank(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8);
        aaDemo.setOwner(claimId);        
        vm.prank(alice);
        aaDemo.execute(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8), 1 ether , "", claimId, 0x732429d3b5ff8b06cac04b71be44bee6115a6ac0c4971652b6ab352fe0564bc2,fake_seal);
        assertEq(payable(address(aaDemo)).balance, 4 ether);
        assertEq(alice.balance, 6 ether);        
    }
    




}
