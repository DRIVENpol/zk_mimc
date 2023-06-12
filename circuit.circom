pragma circom 2.0.0;

template MiMC5() {

    signal input x;
    signal input k;
    
    signal output h;

    var nRounds = 10;

    // Generated big numbers
    // The first one is always zero (by convention)
    var c[nRounds] = [
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

    signal lastOutput[nRounds + 1];

    var base[nRounds];

    signal base2[nRounds];
    signal base4[nRounds];

    lastOutput[0] <== x;

    for(var i = 0; i < nRounds; i++) {
        base[i] = lastOutput[i] + k + c[i];

        base2[i] <== base[i] * base[i];
        base4[i] <== base2[i] * base2[i];

        lastOutput[i+1] <== base4[i] * base[i];
    }

    h <== lastOutput[nRounds] - k;

}

component main = MiMC5();

// COMANDS
// node ./circuit_js/generate_witness.js ./circuit_js/circuit.wasm input.json output.wtns
// snarkjs wtns export json output.wtns output.json