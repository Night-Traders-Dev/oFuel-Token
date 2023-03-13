pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract WrappedOFUEL is ERC20, ERC20Capped {
    address public oFuelTokenAddress;

        constructor(string memory name_, string memory symbol_, uint256 cap_, address oFuelAddress_) ERC20(name_, symbol_) ERC20Capped(cap_) {
                require(oFuelAddress_ != address(0), "oFuel address cannot be zero");
                        oFuelTokenAddress = oFuelAddress_;
                            }

                                function deposit() public {
                                        uint256 amount = ERC20(oFuelTokenAddress).balanceOf(address(this)) - totalSupply();
                                                require(amount > 0, "Amount must be greater than zero");

                                                        _mint(msg.sender, amount);
                                                            }

                                                                function withdraw(uint256 amount) public {
                                                                        require(amount > 0, "Amount must be greater than zero");
                                                                                require(balanceOf(msg.sender) >= amount, "Insufficient balance");

                                                                                        _burn(msg.sender, amount);

                                                                                                require(ERC20(oFuelTokenAddress).transfer(msg.sender, amount), "Transfer failed");
                                                                                                    }

                                                                                                        function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) {
                                                                                                                require(totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
                                                                                                                        super._mint(account, amount);
                                                                                                                            }
                                                                                                                            }
                                                                                                                            
