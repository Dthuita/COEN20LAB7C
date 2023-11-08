        .syntax     unified
        .cpu        cortex-m4
        .text

// void PutNibble(void *nibbles, uint32_t index, uint32_t nibble) ;

        .global     PutNibble
        .thumb_func
        .align

// void __attribute__((weak)) PutNibble(void *nibbles, uint32_t which, uint32_t value){
//     uint8_t *pbyte ;
//     pbyte = (uint8_t *) nibbles + (which >> 1) ;

//     if ((which & 1) == 1){
//         *pbyte &= 0b00001111 ;
//         *pbyte |= value << 4 ;      
//     }else{
//         *pbyte &= 0b11110000 ;
//         *pbyte |= value ;
//     }
// }

PutNibble: //R0 <-- *nibbles, R1 <-- which, R2 <-- value, R3 <-- *pbyte
        PUSH {R4}
        
        LSR R3, R1, 1              //R3 <-- which >> 1
        ADD R3, R0, R3             //R3 <-- nibbles[which >> 1] 
	LDRB R3, R3                //R3 == byte <-- nibbles[which >> 1] 

        AND R1, R1, 1              //R1 <-- (which & 1)
        CMP R1, 1                  
        ITTEE EQ                   //(which & 1) == 1

        ANDEQ R3, R3, 0b00001111   //R3 <-- *pbyte &= 0b00001111 ;
        ORREQ R3, R3, R2, LSL 2    //R3 <-- *pbyte |= value << 4

        ANDNE R3, R3, 0b11110000   //R3 <-- *pbyte &= 0b11110000
        ORRNE R3, R3, R2           //R3 <-- *pbyte |= value

        // STRB WHERE??

        BX          LR

// uint32_t GetNibble(void *nibbles, uint32_t index) ;

        .global     GetNibble
        .thumb_func
        .align

// uint32_t __attribute__((weak)) GetNibble(void *nibbles, uint32_t which){
//     uint8_t byte ;
//
//     byte = ((uint8_t *) nibbles)[which >> 1] ;
//     if ((which & 1) == 1) byte >>= 4 ;
//     return (uint32_t) (byte & 0b00001111) ;
// }

GetNibble: //R0 <-- *nibbles, R1 <-- which, R3 <-- byte
        LSR R3, R1, 1               //R3 <-- which >> 1
        ADD R3, R0, R3              //R3 <-- nibbles[which >> 1] 
	LDRB R3, R3                 //R3 == byte <-- nibbles[which >> 1] 

        AND R2, R1, 1               //R2 <-- (which & 1)
        CMP R2, 1                   //(which & 1) == 1

        IT EQ
        LSREQ R0, R3, 4              //R0 <-- byte >>= 4

        AND R0, R0, 0b00001111       //(byte & 0b00001111)

        BX          LR

        .end
