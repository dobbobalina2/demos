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
import {BonsaiPay} from "../contracts/BonsaiPay.sol";
import "forge-std/console.sol";
import {Elf} from "./Elf.sol"; // auto-generated contract after running `cargo build`.

contract BonsaiPayTest is RiscZeroCheats, Test {
    BonsaiPay public bonsaiPay;
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public charlie = makeAddr("charlie");

    struct Input {
        uint256 id_provider;
        string jwt;
    }

    function setUp() public {
        IRiscZeroVerifier verifier = deployRiscZeroVerifier();
        bonsaiPay = new BonsaiPay(verifier);

        // fund alice and bob and charlie
        vm.deal(alice, 5 ether);
        vm.deal(bob, 5 ether);
        vm.deal(charlie, 5 ether);
    }

    function test_Deposit() public payable {
        bytes32 claimId = sha256(abi.encodePacked("bob@email.com"));
        vm.prank(alice);
        bonsaiPay.deposit{value: 1 ether}(claimId);

        assertEq(address(bonsaiPay).balance, 1 ether);
    }

    function test_ExecuteCall() public {
        // deposit as alice
        bytes32 claimId = sha256(abi.encodePacked("johnkenny6799@gmail.com"));
        vm.prank(alice);

        // claim as bob
       
        string memory jwt ="eyJhbGciOiJSUzI1NiIsImtpZCI6ImFjM2UzZTU1ODExMWM3YzdhNzVjNWI2NTEzNGQyMmY2M2VlMDA2ZDAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc3MzYzNTE4MjIzNTY1NTc3NDkiLCJlbWFpbCI6ImpvaG5rZW5ueTY3OTlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5vbmNlIjoiMHhjNTA3NzcxNjI5RjREZDYxQjZjZjhkRjc4YjIyODc0ZjAyMzkzNzI2IiwibmJmIjoxNzE1MDU5NTgxLCJuYW1lIjoiSm9obiBLZW5ueSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKdHczTGFqNXdUNUN4QjV2ZzJySjJkSnlHWWpTX29MaXliMEkzTDIwTmJFeHBBdXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSm9obiIsImZhbWlseV9uYW1lIjoiS2VubnkiLCJpYXQiOjE3MTUwNTk4ODEsImV4cCI6MTcxNTA2MzQ4MSwianRpIjoiZDRiYTg2NjBkNGMxOWI2NGM5NGViMjQzODM1NWUxOWFkN2I5ZDBjMSJ9.LL6J31FCk7Omir2vCdHgZH-373Ex-0pq7-b1uljw_enfenivcSBY8y0UMcVDFoZsaYUlEZwUEN_kDw77vtKbcUpE1artzibo-w44ofV9wqDeLITOKdZnSzWlt9sDDE2Qxj-Mz43FEQufbUqLd2sXP_i6lqap_8iIaGQ5ZtdFL7dr0FZGPff3KBbWX3ctJcDW8TvLCnp3pJwMiwCS2HFkLyOuKyeeHhpaVDqG-fXDxiq7tFd8S79eXvVdtDQpeLWPO2BbQiLkDA6UjqsPA3KY8IuJPXlp4dUsprzJxMrZpH9cnwwlB7j32Eo3C90d8j6a7g-4gDZ3K1g-Al2IXEalng";
        uint256 id_provider = 1;

        Input memory input = Input({id_provider: id_provider, jwt: jwt});
        
        (bytes memory journal, bytes32 post_state_digest, bytes memory seal) =
            prove(Elf.JWT_VALIDATOR_PATH, abi.encode(input));
        bytes memory fake_seal = hex"02e44998e744ff5881d4e24a36f77694dc0247b9b9ad1956faa2ca64a5f28360177806f5d61809c34262b57167077a129257569f7fd9aee0d1dc36990d09c6ff27f8c5c06e5dc5cbdf982e22f27773ca75c8ddbc2c806f5fec50bb55c0a566791655366dc77a94396d9acb2c69a298a34fc8392f15202cfc5f716bee340b896212984698a125345df1abee9e4ce525ac11fad14f78f2318287b68039163a13b12edf9209a56ff6b90d153617e5cfa091ee694e1c610dd4e45ce8a3008bda1ce000c2d22ad3916dd9397e17039e6f32d49d1fc2d4b18569a4051dce0e5f1dbd6015b6558d9cfd06df2f8fbf52a6bef69b61d81655f91ac28ffcca6ea6e2e9753e";


        vm.prank(alice);
        bonsaiPay.executeCall{value: 1 ether}(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8), claimId, 0x732429d3b5ff8b06cac04b71be44bee6115a6ac0c4971652b6ab352fe0564bc2,fake_seal);
        assertEq(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8).balance, 6 ether);
        assertEq(alice.balance, 4 ether);        
    }
    

    function test_Claim() public {
        // deposit as alice
        bytes32 claimId = sha256(abi.encodePacked("johnkenny6799@gmail.com"));
        vm.prank(alice);
        bonsaiPay.deposit{value: 1 ether}(claimId);
        assertEq(address(bonsaiPay).balance, 1 ether);
        assertEq(alice.balance, 4 ether);

        // claim as bob
        string memory jwt ="eyJhbGciOiJSUzI1NiIsImtpZCI6ImFjM2UzZTU1ODExMWM3YzdhNzVjNWI2NTEzNGQyMmY2M2VlMDA2ZDAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyODAzNzI3MzkzNjgtcXY0YnJ2YTBlaXEwdjFvbzFqdHNxZGFwaDZtdjdvbW8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc3MzYzNTE4MjIzNTY1NTc3NDkiLCJlbWFpbCI6ImpvaG5rZW5ueTY3OTlAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5vbmNlIjoiMHhjNTA3NzcxNjI5RjREZDYxQjZjZjhkRjc4YjIyODc0ZjAyMzkzNzI2IiwibmJmIjoxNzE1MDU5NTgxLCJuYW1lIjoiSm9obiBLZW5ueSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NKdHczTGFqNXdUNUN4QjV2ZzJySjJkSnlHWWpTX29MaXliMEkzTDIwTmJFeHBBdXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiSm9obiIsImZhbWlseV9uYW1lIjoiS2VubnkiLCJpYXQiOjE3MTUwNTk4ODEsImV4cCI6MTcxNTA2MzQ4MSwianRpIjoiZDRiYTg2NjBkNGMxOWI2NGM5NGViMjQzODM1NWUxOWFkN2I5ZDBjMSJ9.LL6J31FCk7Omir2vCdHgZH-373Ex-0pq7-b1uljw_enfenivcSBY8y0UMcVDFoZsaYUlEZwUEN_kDw77vtKbcUpE1artzibo-w44ofV9wqDeLITOKdZnSzWlt9sDDE2Qxj-Mz43FEQufbUqLd2sXP_i6lqap_8iIaGQ5ZtdFL7dr0FZGPff3KBbWX3ctJcDW8TvLCnp3pJwMiwCS2HFkLyOuKyeeHhpaVDqG-fXDxiq7tFd8S79eXvVdtDQpeLWPO2BbQiLkDA6UjqsPA3KY8IuJPXlp4dUsprzJxMrZpH9cnwwlB7j32Eo3C90d8j6a7g-4gDZ3K1g-Al2IXEalng";
        uint256 id_provider = 1;

        Input memory input = Input({id_provider: id_provider, jwt: jwt});

        (bytes memory journal, bytes32 post_state_digest, bytes memory seal) =
            prove(Elf.JWT_VALIDATOR_PATH, abi.encode(input));

        vm.prank(bob);
        console.logBytes32(claimId);
        console.logBytes32(post_state_digest);
        console.logBytes(seal);
        assertEq(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8).balance, 0 ether);

        bytes memory fake_seal = hex"02e44998e744ff5881d4e24a36f77694dc0247b9b9ad1956faa2ca64a5f28360177806f5d61809c34262b57167077a129257569f7fd9aee0d1dc36990d09c6ff27f8c5c06e5dc5cbdf982e22f27773ca75c8ddbc2c806f5fec50bb55c0a566791655366dc77a94396d9acb2c69a298a34fc8392f15202cfc5f716bee340b896212984698a125345df1abee9e4ce525ac11fad14f78f2318287b68039163a13b12edf9209a56ff6b90d153617e5cfa091ee694e1c610dd4e45ce8a3008bda1ce000c2d22ad3916dd9397e17039e6f32d49d1fc2d4b18569a4051dce0e5f1dbd6015b6558d9cfd06df2f8fbf52a6bef69b61d81655f91ac28ffcca6ea6e2e9753e";
        bytes memory fake_calldata = hex"f7a0582a00000000000000000000000023d4a8d26b777c1fdcbb74afa79cada1caf772f845387fddf42a08a8d896cebf60ee8dba2bdf80e60215285343fe03c0c853357e7f012488ce9e7ae523512c3ff1d3b367c6404a28f15afb89ad2a393e4497048f000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001001caa8912933ff58c68edde662fabb0510f3926659d548c201d3a0ce0141341602ff317c2ac12a36af7ede4be55834be45f55086b88a66b1880a57916ef4d5829040ce3a25f89b18cb2b119a552808f686ffa1ad3e8d8ac0d17ee51b1a4dabeb42eec111eb519708ec4fccdf505068b80013513532bf5b294dc0fe48f21f62e2f09ed88da01ff1c2238d88297e3508e62f91645d725a7d095508ba8a9c8c177f01e7e0b07e035d770f3840440d20dae03dd39476dbbf364662ba5eced2d3d499129251165e524c8740f9c545ba031e16d04b1a65f1dbc271b74e0571dc577de382ef4f1c642827f418c303fe201d1b4ad3087b61dfe120d7479d6de499b24900d";

        bonsaiPay.claim(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8), claimId, 0x732429d3b5ff8b06cac04b71be44bee6115a6ac0c4971652b6ab352fe0564bc2,fake_seal );
        assertEq(address(bonsaiPay).balance, 0);
        assertEq(payable(0x23D4a8d26B777c1FDcBB74afa79CAdA1caF772F8).balance, 1 ether);
    }

    function test_balanceOf() public {
        bytes32 claimId = sha256(abi.encodePacked("bob@email.com"));
        vm.prank(alice);
        bonsaiPay.deposit{value: 1 ether}(claimId);
        assertEq(bonsaiPay.balanceOf(claimId), 1 ether);
    }

    // function test_multipleDepositsAndClaims() public {
    //     bytes32 bobClaimId = sha256(abi.encodePacked("bob@email.com"));
    //     bytes32 charlieClaimId = sha256(abi.encodePacked("charlie@email.com"));

    //     vm.prank(alice);
    //     bonsaiPay.deposit{value: 1 ether}(bobClaimId);
    //     bonsaiPay.deposit{value: 2 ether}(charlieClaimId);
    //     vm.prank(charlie);
    //     bonsaiPay.deposit{value: 3 ether}(bobClaimId);

    //     assertEq(bonsaiPay.balanceOf(bobClaimId), 4 ether);
    //     assertEq(bonsaiPay.balanceOf(charlieClaimId), 2 ether);

    //     // claim as bob
    //     string memory bobJwt =
    //         "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ijg3OTJlN2MyYTJiN2MxYWI5MjRlMTU4YTRlYzRjZjUxIn0.eyJlbWFpbCI6ImJvYkBlbWFpbC5jb20iLCJub25jZSI6IjB4MUQ5NkYyZjZCZUYxMjAyRTRDZTFGZjZEYWQwYzJDQjAwMjg2MWQzZSJ9.Ad3Hr5SOo0uDQ-uOldnXVhlkJIClfWJE6UsnWWDTgFNGEYqAYpbqIqPSrUIMPMy9ZHZhnQGJJcED0krQTlys5UfN6K9THo-CnIa72EhHWtALJC3XcuaFZ-iNCbFYQtaL6M7Bu4NtdlllcsUYU9V3Q2h6xOGlMjGmwOr0xQjwnI-qpny5ctzlAjGsa4E9Y2_Hu_iBQ483Yv01g31H34efGamPf8rqBDXtHobsX2W7FGYnOWLLP4nZD8obn3g-6ny5joIlx3IklAE0t7M5E98kNVKc5P7_J7e3LdEQ-0AzYcBvPvx3F29kyYa4mevPTulU2kxtCKue8EMFu7nFE0VZHQ";
    //     uint256 id_provider = 1;

    //     Input memory bobInput = Input({id_provider: id_provider, jwt: bobJwt});

    //     (bytes memory journal, bytes32 post_state_digest, bytes memory seal) =
    //         prove(Elf.JWT_VALIDATOR_PATH, abi.encode(bobInput));

    //     vm.prank(bob);
    //     bonsaiPay.claim(payable(bob), bobClaimId, post_state_digest, seal);
    //     assertEq(address(bonsaiPay).balance, 2 ether);
    //     assertEq(bob.balance, 9 ether);

    //     assertEq(bonsaiPay.balanceOf(bobClaimId), 0);
    //     assertEq(bonsaiPay.balanceOf(charlieClaimId), 2 ether);

    //     // claim as charlie
    //     string memory charlieJwt =
    //         "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ijg3OTJlN2MyYTJiN2MxYWI5MjRlMTU4YTRlYzRjZjUxIn0.eyJlbWFpbCI6ImNoYXJsaWVAZW1haWwuY29tIiwibm9uY2UiOiIweGVhNDc1ZDYwYzExOGQ3MDU4YmVGNGJEZDljMzJiQTUxMTM5YTc0ZTAifQ.NE-QtMDGh7nBx-g_dgFI_E-2v0ssXsEBxKR77LdIsFJTNKaruzojKgg6X5Pr5nuWeewcDfCrHkCbCqGYny_vXAsAoBaYc4z-DpjTe6SHM4-rzTQwi5KKmPjBL85wHpAtxYS6mhviEPoyGH76Ki0qLDejCsHem8dn6rSdvkDPF-xTbLyRQSndpbbrffDB07NTcRNfpjohvGLtxfCwVzLx1Mnk3IRDnsrbechbBf4dCqx_fkuOzKqNiDKfn_Mv-j0Rl0VF_LJKIs5GDzon4zkl9ID221j9mNp6v2vb8XspS7qV5skmVVW-UThYuS_AzECztwvYcdvBePLpdx-IGaqtng";

    //     Input memory charlieInput = Input({id_provider: id_provider, jwt: charlieJwt});

    //     (bytes memory charlieJournal, bytes32 charliePostStateDigest, bytes memory charlieSeal) =
    //         prove(Elf.JWT_VALIDATOR_PATH, abi.encode(charlieInput));

    //     vm.prank(charlie);
    //     bonsaiPay.claim(payable(charlie), charlieClaimId, charliePostStateDigest, charlieSeal);
    //     assertEq(address(bonsaiPay).balance, 0);
    //     assertEq(charlie.balance, 4 ether);

    //     assertEq(bonsaiPay.balanceOf(bobClaimId), 0);
    //     assertEq(bonsaiPay.balanceOf(charlieClaimId), 0);
    // }
}
