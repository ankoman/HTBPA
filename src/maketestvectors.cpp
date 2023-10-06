#include<stdio.h>
#include<mcl/bls12_381.hpp>
#include<sys/time.h>

// Build command: g++ maketestvectors.cpp -lmcl -lgmp

using namespace mcl::bn;

void genR(char *s, const int len){
    static const char alphabets[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345667890";
    for(int i=0; i< len;i++){
        s[i] = alphabets[rand() % (sizeof(alphabets) - 1)];
    }
    s[len]=0;
}


int main(){

    G1 P, P2, P4;
    G2 Q, Q2, Q4;
    char *s = (char*)malloc(sizeof(char)*64);

    initPairing(mcl::BLS12_381);
    //initPairing(mcl::BN254);

    // Gen P, Q
    genR(s,20);
    hashAndMapToG1(P,s,20);
    genR(s,20);
    hashAndMapToG2(Q,s,20);
    printf("\nP = %s\n", P.getStr(16).c_str());
    printf("\nQ = %s\n", Q.getStr(16).c_str());

    // 2P, 2Q
    G1::mul(P2, P, 2);
	G2::mul(Q2, Q, 2);
    printf("\n2P = %s\n", P2.getStr(16).c_str());
    printf("\n2Q = %s\n", Q2.getStr(16).c_str());

    // 4P, 4Q
    G1::mul(P4, P, 4);
	G2::mul(Q4, Q, 4);
    printf("\n4P = %s\n", P4.getStr(16).c_str());
    printf("\n4Q = %s\n", Q4.getStr(16).c_str());

    free(s);
    return 0;
}