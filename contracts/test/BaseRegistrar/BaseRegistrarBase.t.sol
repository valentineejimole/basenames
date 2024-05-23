//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {BaseRegistrar} from "src/L2/BaseRegistrar.sol";
import {MockPublicResolver} from "test/mocks/MockPublicResolver.sol";
import {Registry} from "src/L2/Registry.sol";
import {ETH_NODE} from "src/util/Constants.sol";

contract BaseRegistrarBase is Test {
    Registry public registry;
    BaseRegistrar public baseRegistrar;
    address public owner = makeAddr("0x1");
    address public user = makeAddr("0x2");
    address public controller = makeAddr("0x3");
    bytes32 public label = keccak256("test");
    uint256 public id = uint256(label);
    uint256 public duration = 30 days;
    uint256 public blockTimestamp = 1716496498; // May 23, 2024

    function setUp() public {
        vm.prank(owner);
        registry = new Registry(owner);
        baseRegistrar = new BaseRegistrar(registry, owner);
        _ensSetup();
    }

    function _ensSetup() public virtual {
        // establish the base.eth namespace and set the baseRegistrar as the owner of "base.eth"
        bytes32 ethLabel = keccak256("eth");
        bytes32 baseLabel = keccak256("base");
        vm.prank(owner);
        registry.setSubnodeOwner(0x0, ethLabel, owner);
        vm.prank(owner);
        registry.setSubnodeOwner(ETH_NODE, baseLabel, address(baseRegistrar));
    }

    function _registrationSetup() internal virtual {
        vm.prank(owner);
        baseRegistrar.addController(controller);
    }

    function _registerName(bytes32 label_, address nameOwner, uint256 duration_) internal virtual returns (uint256) {
        vm.warp(blockTimestamp);
        vm.prank(controller);
        return baseRegistrar.register(uint256(label_), nameOwner, duration_);
    }
}
