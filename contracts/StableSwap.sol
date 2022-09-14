// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library Math {
    function abs(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x - y : y - x;
    }
}

contract StableSwap {
    // Formula : An^n sum(x_i) + D = ADn^n + D^(n + 1) / (n^n prod(x_i))

    // Number of tokens
    uint256 private constant N = 3;
    // Calculate A
    uint256 private constant A = 1000 * (N**(N - 1));
    // fees
    uint256 private constant SWAP_FEE = 300;
    uint256 private constant LIQUIDITY_FEE = (SWAP_FEE * N) / (4 * (N - 1));
    // token addresses
    address[N] public constant tokens;
    // normalizing the token decimals :
    //Example - DAI (18 decimals), USDC (6 decimals), USDT (6 decimals)
    uint256[N] private constant multipliers = [1, 1e12, 1e12];
    uint256[N] public balances;

    uint256 private constant DECIMALS = 18;

    // LIQUIDITY SHARES
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(
        address token0,
        address token1,
        address token2
    ) {
        tokens[0] = token0;
        tokens[1] = token1;
        tokens[2] = token2;
    }

    function swap(
        uint256 i,
        uint256 j,
        uint256 dx,
        uint256 miny
    ) external returns (uint256 dy) {
        require(i < N && j < N, "Error : Invalid token");
        require(i != j, "Error: i==j");

        // Pull the dx amount
        IERC20(tokens[i]).transferFrom(msg.sender, address(this), dx);

        // Calculate dy
        uint256[N] memory xp = _xp();
        // x = previous x balance + the amount user deposited
        uint256 x = xp[i] + dx * multipliers[i];

        uint256 y0 = xp[j]; //current balance of j
        uint256 y1 = _getY(i, j, x, xp); //use the algorithm to calculate the y amount user gets
    }

    function _getY(
        uint256 i,
        uint256 j,
        uint256 x,
        uint256[N] memory xp
    ) private pure returns (uint256) {}

    function _xp() private view returns (uint256[N] memory xp) {
        for (uint256 i = 0; i < xp.length; i++) {
            xp[i] = balances[i] * multipliers[i];
        }
    }

    // Mint shares
    function _mint(address _to, uint256 _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    // Burn shares
    function _burn(address _from, uint256 _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }
}
