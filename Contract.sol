//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Hasher {

    // No of rounds
    uint8 rounds = 10;

    // C values from circuits
    uint256[10] c = [
        0,
        9011054680180261746819573945573752587822294995734475489070453031,
        7004105217577387931471855342609109144283682400694989952338026378,
        8012666625487618038264151352611419421671955729744344666315538435,
        7096582353848909528348048549251173597176314150356879228806966674,
        6072731430415003562940954686910766914077499432424835473851673802,
        2032737634329180771383313605690274052861411861448782776234083753,
        8044847065419100553893184216516772456634776114628076717286601174,
        7020577422304150937891985684459527322475767419468986416860338195,
        1077266684852733200046098926903947521762260870410772376705633457
    ];

    // Use the value from the documentation
    // https://eips.ethereum.org/EIPS/eip-197
    uint256 p = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    function MiMC5(uint256 x, uint256 k) public view returns (uint256 h) {
        uint256 lastOutput = x;
        uint256 base;
        uint256 base2;
        uint256 base4;

        for (uint256 i = 0; i < rounds;) {
            // addmod, mulmod - from 0.8.0 can't do modulo directly
            base = addmod(lastOutput, k, p);
            base = addmod(base, c[i], p);

            base2 = mulmod(base, base, p);
            base4 = mulmod(base2, base2, p);

            lastOutput = mulmod(base4, base, p);

            unchecked {
                ++i;
            }
        }

        h = addmod(lastOutput, k, p);
    }
}