
bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0d00000 <main>:
  END_TRY_L(exit);
}

/* -------------------------------------------------------------- */

__attribute__((section(".boot"))) int main(void) {
c0d00000:	b5b0      	push	{r4, r5, r7, lr}
c0d00002:	b08c      	sub	sp, #48	; 0x30
  // exit critical section
  __asm volatile("cpsie i");
c0d00004:	b662      	cpsie	i


  // ensure exception will work as planned
  os_boot();
c0d00006:	f003 fbd7 	bl	c0d037b8 <os_boot>
c0d0000a:	4c11      	ldr	r4, [pc, #68]	; (c0d00050 <main+0x50>)
c0d0000c:	2100      	movs	r1, #0
c0d0000e:	22b0      	movs	r2, #176	; 0xb0
  for(;;) {
    UX_INIT();
c0d00010:	4620      	mov	r0, r4
c0d00012:	f003 fcb3 	bl	c0d0397c <os_memset>
c0d00016:	ad01      	add	r5, sp, #4

    BEGIN_TRY {
      TRY {
c0d00018:	4628      	mov	r0, r5
c0d0001a:	f006 fb91 	bl	c0d06740 <setjmp>
c0d0001e:	8528      	strh	r0, [r5, #40]	; 0x28
c0d00020:	b280      	uxth	r0, r0
c0d00022:	2800      	cmp	r0, #0
c0d00024:	d006      	beq.n	c0d00034 <main+0x34>
c0d00026:	2810      	cmp	r0, #16
c0d00028:	d0f0      	beq.n	c0d0000c <main+0xc>
      FINALLY {
      }
    }
    END_TRY;
  }
  app_exit();
c0d0002a:	f002 fb43 	bl	c0d026b4 <app_exit>
c0d0002e:	2000      	movs	r0, #0
}
c0d00030:	b00c      	add	sp, #48	; 0x30
c0d00032:	bdb0      	pop	{r4, r5, r7, pc}
c0d00034:	a801      	add	r0, sp, #4
  os_boot();
  for(;;) {
    UX_INIT();

    BEGIN_TRY {
      TRY {
c0d00036:	f003 fbc2 	bl	c0d037be <try_context_set>
      
        //start communication with MCU
        io_seproxyhal_init();
c0d0003a:	f003 fead 	bl	c0d03d98 <io_seproxyhal_init>
c0d0003e:	2001      	movs	r0, #1

        USB_power(1);
c0d00040:	f006 f88a 	bl	c0d06158 <USB_power>
        io_usb_ccid_set_card_inserted(1);
        #endif
  

        //set up
        monero_init();
c0d00044:	f001 f92e 	bl	c0d012a4 <monero_init>
  
        //set up initial screen
        ui_init();
c0d00048:	f003 fba2 	bl	c0d03790 <ui_init>
        //start the application
        //the first exchange will:
        // - display the  initial screen
        // - send the ATR
        // - receive the first command
        monero_main();
c0d0004c:	f001 ffe6 	bl	c0d0201c <monero_main>
c0d00050:	20001880 	.word	0x20001880

c0d00054 <monero_apdu_blind>:
#include "monero_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_blind() {
c0d00054:	b5b0      	push	{r4, r5, r7, lr}
c0d00056:	b098      	sub	sp, #96	; 0x60
c0d00058:	4668      	mov	r0, sp
c0d0005a:	2420      	movs	r4, #32
    unsigned char v[32];
    unsigned char k[32];
    unsigned char AKout[32];

    monero_io_fetch_decrypt(AKout,32);
c0d0005c:	4621      	mov	r1, r4
c0d0005e:	f001 fab3 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d00062:	a808      	add	r0, sp, #32
    monero_io_fetch(k,32);
c0d00064:	4621      	mov	r1, r4
c0d00066:	f001 fa93 	bl	c0d01590 <monero_io_fetch>
c0d0006a:	a810      	add	r0, sp, #64	; 0x40
    monero_io_fetch(v,32);
c0d0006c:	4621      	mov	r1, r4
c0d0006e:	f001 fa8f 	bl	c0d01590 <monero_io_fetch>
c0d00072:	2001      	movs	r0, #1

    monero_io_discard(1);
c0d00074:	f001 f9fe 	bl	c0d01474 <monero_io_discard>
c0d00078:	204f      	movs	r0, #79	; 0x4f
c0d0007a:	0080      	lsls	r0, r0, #2

    if ((G_monero_vstate.options&0x03)==2) {
c0d0007c:	491e      	ldr	r1, [pc, #120]	; (c0d000f8 <monero_apdu_blind+0xa4>)
c0d0007e:	5808      	ldr	r0, [r1, r0]
c0d00080:	2103      	movs	r1, #3
c0d00082:	4001      	ands	r1, r0
c0d00084:	2902      	cmp	r1, #2
c0d00086:	d113      	bne.n	c0d000b0 <monero_apdu_blind+0x5c>
c0d00088:	a808      	add	r0, sp, #32
c0d0008a:	2400      	movs	r4, #0
c0d0008c:	2220      	movs	r2, #32
        os_memset(k,0,32);
c0d0008e:	4621      	mov	r1, r4
c0d00090:	f003 fc74 	bl	c0d0397c <os_memset>
c0d00094:	4668      	mov	r0, sp
        monero_ecdhHash(AKout, AKout);
c0d00096:	4601      	mov	r1, r0
c0d00098:	f000 fe38 	bl	c0d00d0c <monero_ecdhHash>
c0d0009c:	a810      	add	r0, sp, #64	; 0x40
        for (int i = 0; i<8; i++){
            v[i] = v[i] ^ AKout[i];
c0d0009e:	5d01      	ldrb	r1, [r0, r4]
c0d000a0:	466a      	mov	r2, sp
c0d000a2:	5d12      	ldrb	r2, [r2, r4]
c0d000a4:	404a      	eors	r2, r1
c0d000a6:	5502      	strb	r2, [r0, r4]
    monero_io_discard(1);

    if ((G_monero_vstate.options&0x03)==2) {
        os_memset(k,0,32);
        monero_ecdhHash(AKout, AKout);
        for (int i = 0; i<8; i++){
c0d000a8:	1c64      	adds	r4, r4, #1
c0d000aa:	2c08      	cmp	r4, #8
c0d000ac:	d1f6      	bne.n	c0d0009c <monero_apdu_blind+0x48>
c0d000ae:	e015      	b.n	c0d000dc <monero_apdu_blind+0x88>
c0d000b0:	466c      	mov	r4, sp
c0d000b2:	2520      	movs	r5, #32
            v[i] = v[i] ^ AKout[i];
        }
    } else {
        //blind mask
        monero_hash_to_scalar(AKout, AKout, 32);
c0d000b4:	4620      	mov	r0, r4
c0d000b6:	4621      	mov	r1, r4
c0d000b8:	462a      	mov	r2, r5
c0d000ba:	f000 f941 	bl	c0d00340 <monero_hash_to_scalar>
c0d000be:	a808      	add	r0, sp, #32
        monero_addm(k,k,AKout);
c0d000c0:	4601      	mov	r1, r0
c0d000c2:	4622      	mov	r2, r4
c0d000c4:	f000 fc44 	bl	c0d00950 <monero_addm>
        //blind value
        monero_hash_to_scalar(AKout, AKout, 32);
c0d000c8:	4620      	mov	r0, r4
c0d000ca:	4621      	mov	r1, r4
c0d000cc:	462a      	mov	r2, r5
c0d000ce:	f000 f937 	bl	c0d00340 <monero_hash_to_scalar>
c0d000d2:	a810      	add	r0, sp, #64	; 0x40
        monero_addm(v,v,AKout);
c0d000d4:	4601      	mov	r1, r0
c0d000d6:	4622      	mov	r2, r4
c0d000d8:	f000 fc3a 	bl	c0d00950 <monero_addm>
c0d000dc:	a810      	add	r0, sp, #64	; 0x40
c0d000de:	2420      	movs	r4, #32
    }
    //ret all
    monero_io_insert(v,32);
c0d000e0:	4621      	mov	r1, r4
c0d000e2:	f001 f9f3 	bl	c0d014cc <monero_io_insert>
c0d000e6:	a808      	add	r0, sp, #32
    monero_io_insert(k,32);
c0d000e8:	4621      	mov	r1, r4
c0d000ea:	f001 f9ef 	bl	c0d014cc <monero_io_insert>
c0d000ee:	2009      	movs	r0, #9
c0d000f0:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d000f2:	b018      	add	sp, #96	; 0x60
c0d000f4:	bdb0      	pop	{r4, r5, r7, pc}
c0d000f6:	46c0      	nop			; (mov r8, r8)
c0d000f8:	20001930 	.word	0x20001930

c0d000fc <monero_unblind>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_unblind(unsigned char *v, unsigned char *k, unsigned char *AKout, unsigned int short_amount) {
c0d000fc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d000fe:	b081      	sub	sp, #4
c0d00100:	4614      	mov	r4, r2
c0d00102:	460e      	mov	r6, r1
c0d00104:	4605      	mov	r5, r0
    if (short_amount==2) {
c0d00106:	2b02      	cmp	r3, #2
c0d00108:	d110      	bne.n	c0d0012c <monero_unblind+0x30>
        monero_genCommitmentMask(k,AKout);
c0d0010a:	4630      	mov	r0, r6
c0d0010c:	4621      	mov	r1, r4
c0d0010e:	f000 fe2b 	bl	c0d00d68 <monero_genCommitmentMask>
        monero_ecdhHash(AKout, AKout);
c0d00112:	4620      	mov	r0, r4
c0d00114:	4621      	mov	r1, r4
c0d00116:	f000 fdf9 	bl	c0d00d0c <monero_ecdhHash>
c0d0011a:	2000      	movs	r0, #0
        for (int i = 0; i<8; i++) {
            v[i] = v[i] ^ AKout[i];
c0d0011c:	5c29      	ldrb	r1, [r5, r0]
c0d0011e:	5c22      	ldrb	r2, [r4, r0]
c0d00120:	404a      	eors	r2, r1
c0d00122:	542a      	strb	r2, [r5, r0]
/* ----------------------------------------------------------------------- */
int monero_unblind(unsigned char *v, unsigned char *k, unsigned char *AKout, unsigned int short_amount) {
    if (short_amount==2) {
        monero_genCommitmentMask(k,AKout);
        monero_ecdhHash(AKout, AKout);
        for (int i = 0; i<8; i++) {
c0d00124:	1c40      	adds	r0, r0, #1
c0d00126:	2808      	cmp	r0, #8
c0d00128:	d1f8      	bne.n	c0d0011c <monero_unblind+0x20>
c0d0012a:	e014      	b.n	c0d00156 <monero_unblind+0x5a>
c0d0012c:	2720      	movs	r7, #32
            v[i] = v[i] ^ AKout[i];
        }
    } else {
        //unblind mask
        monero_hash_to_scalar(AKout, AKout, 32);
c0d0012e:	4620      	mov	r0, r4
c0d00130:	4621      	mov	r1, r4
c0d00132:	463a      	mov	r2, r7
c0d00134:	f000 f904 	bl	c0d00340 <monero_hash_to_scalar>
        monero_subm(k,k,AKout);
c0d00138:	4630      	mov	r0, r6
c0d0013a:	4631      	mov	r1, r6
c0d0013c:	4622      	mov	r2, r4
c0d0013e:	f000 fe2d 	bl	c0d00d9c <monero_subm>
        //unblind value
        monero_hash_to_scalar(AKout, AKout, 32);
c0d00142:	4620      	mov	r0, r4
c0d00144:	4621      	mov	r1, r4
c0d00146:	463a      	mov	r2, r7
c0d00148:	f000 f8fa 	bl	c0d00340 <monero_hash_to_scalar>
        monero_subm(v,v,AKout);
c0d0014c:	4628      	mov	r0, r5
c0d0014e:	4629      	mov	r1, r5
c0d00150:	4622      	mov	r2, r4
c0d00152:	f000 fe23 	bl	c0d00d9c <monero_subm>
c0d00156:	2000      	movs	r0, #0
    }
    return 0;
c0d00158:	b001      	add	sp, #4
c0d0015a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0015c <monero_apdu_unblind>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_unblind() {
c0d0015c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0015e:	b099      	sub	sp, #100	; 0x64
c0d00160:	ae01      	add	r6, sp, #4
c0d00162:	2420      	movs	r4, #32
    unsigned char v[32];
    unsigned char k[32];
    unsigned char AKout[32];

    monero_io_fetch_decrypt(AKout,32);
c0d00164:	4630      	mov	r0, r6
c0d00166:	4621      	mov	r1, r4
c0d00168:	f001 fa2e 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d0016c:	ad09      	add	r5, sp, #36	; 0x24
    monero_io_fetch(k,32);
c0d0016e:	4628      	mov	r0, r5
c0d00170:	4621      	mov	r1, r4
c0d00172:	f001 fa0d 	bl	c0d01590 <monero_io_fetch>
c0d00176:	af11      	add	r7, sp, #68	; 0x44
    monero_io_fetch(v,32);
c0d00178:	4638      	mov	r0, r7
c0d0017a:	4621      	mov	r1, r4
c0d0017c:	f001 fa08 	bl	c0d01590 <monero_io_fetch>
c0d00180:	2001      	movs	r0, #1

    monero_io_discard(1);
c0d00182:	f001 f977 	bl	c0d01474 <monero_io_discard>
c0d00186:	204f      	movs	r0, #79	; 0x4f
c0d00188:	0080      	lsls	r0, r0, #2

    monero_unblind(v, k, AKout, G_monero_vstate.options&0x03);
c0d0018a:	490a      	ldr	r1, [pc, #40]	; (c0d001b4 <monero_apdu_unblind+0x58>)
c0d0018c:	5808      	ldr	r0, [r1, r0]
c0d0018e:	2303      	movs	r3, #3
c0d00190:	4003      	ands	r3, r0
c0d00192:	4638      	mov	r0, r7
c0d00194:	4629      	mov	r1, r5
c0d00196:	4632      	mov	r2, r6
c0d00198:	f7ff ffb0 	bl	c0d000fc <monero_unblind>

    //ret all
    monero_io_insert(v,32);
c0d0019c:	4638      	mov	r0, r7
c0d0019e:	4621      	mov	r1, r4
c0d001a0:	f001 f994 	bl	c0d014cc <monero_io_insert>
    monero_io_insert(k,32);
c0d001a4:	4628      	mov	r0, r5
c0d001a6:	4621      	mov	r1, r4
c0d001a8:	f001 f990 	bl	c0d014cc <monero_io_insert>
c0d001ac:	2009      	movs	r0, #9
c0d001ae:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d001b0:	b019      	add	sp, #100	; 0x64
c0d001b2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d001b4:	20001930 	.word	0x20001930

c0d001b8 <monero_apdu_gen_commitment_mask>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_gen_commitment_mask() {
c0d001b8:	b570      	push	{r4, r5, r6, lr}
c0d001ba:	b090      	sub	sp, #64	; 0x40
c0d001bc:	466d      	mov	r5, sp
c0d001be:	2420      	movs	r4, #32
    unsigned char k[32];
    unsigned char AKout[32];

    monero_io_fetch_decrypt(AKout,32);
c0d001c0:	4628      	mov	r0, r5
c0d001c2:	4621      	mov	r1, r4
c0d001c4:	f001 fa00 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d001c8:	2001      	movs	r0, #1
    monero_io_discard(1);
c0d001ca:	f001 f953 	bl	c0d01474 <monero_io_discard>
c0d001ce:	ae08      	add	r6, sp, #32
    monero_genCommitmentMask(k,AKout);
c0d001d0:	4630      	mov	r0, r6
c0d001d2:	4629      	mov	r1, r5
c0d001d4:	f000 fdc8 	bl	c0d00d68 <monero_genCommitmentMask>

    //ret all
    monero_io_insert(k,32);
c0d001d8:	4630      	mov	r0, r6
c0d001da:	4621      	mov	r1, r4
c0d001dc:	f001 f976 	bl	c0d014cc <monero_io_insert>
c0d001e0:	2009      	movs	r0, #9
c0d001e2:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d001e4:	b010      	add	sp, #64	; 0x40
c0d001e6:	bd70      	pop	{r4, r5, r6, pc}

c0d001e8 <monero_aes_derive>:
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08};

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_aes_derive(cx_aes_key_t *sk, unsigned char* seed32, unsigned char *a, unsigned char *b) {
c0d001e8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d001ea:	b091      	sub	sp, #68	; 0x44
c0d001ec:	9305      	str	r3, [sp, #20]
c0d001ee:	9203      	str	r2, [sp, #12]
c0d001f0:	460c      	mov	r4, r1
c0d001f2:	9008      	str	r0, [sp, #32]
c0d001f4:	207b      	movs	r0, #123	; 0x7b
c0d001f6:	00c0      	lsls	r0, r0, #3
void monero_hash_init_sha256(cx_hash_t * hasher) {
    cx_sha256_init((cx_sha256_t *)hasher);
}

void monero_hash_init_keccak(cx_hash_t * hasher) {
    cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d001f8:	9007      	str	r0, [sp, #28]
c0d001fa:	4923      	ldr	r1, [pc, #140]	; (c0d00288 <_nvram_data_size+0x8>)
c0d001fc:	180d      	adds	r5, r1, r0
c0d001fe:	2001      	movs	r0, #1
c0d00200:	9004      	str	r0, [sp, #16]
c0d00202:	0201      	lsls	r1, r0, #8
c0d00204:	9106      	str	r1, [sp, #24]
c0d00206:	4628      	mov	r0, r5
c0d00208:	f004 fb50 	bl	c0d048ac <cx_keccak_init>
c0d0020c:	2700      	movs	r7, #0

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_update(cx_hash_t * hasher, unsigned char* buf, unsigned int len) {
    cx_hash(hasher, 0, buf, len, NULL, 0);
c0d0020e:	4668      	mov	r0, sp
c0d00210:	6007      	str	r7, [r0, #0]
c0d00212:	6047      	str	r7, [r0, #4]
c0d00214:	2620      	movs	r6, #32
c0d00216:	4628      	mov	r0, r5
c0d00218:	4639      	mov	r1, r7
c0d0021a:	4622      	mov	r2, r4
c0d0021c:	4633      	mov	r3, r6
c0d0021e:	f004 fb13 	bl	c0d04848 <cx_hash>
c0d00222:	4668      	mov	r0, sp
c0d00224:	6007      	str	r7, [r0, #0]
c0d00226:	6047      	str	r7, [r0, #4]
c0d00228:	4628      	mov	r0, r5
c0d0022a:	4639      	mov	r1, r7
c0d0022c:	9a03      	ldr	r2, [sp, #12]
c0d0022e:	4633      	mov	r3, r6
c0d00230:	f004 fb0a 	bl	c0d04848 <cx_hash>
c0d00234:	4668      	mov	r0, sp
c0d00236:	6007      	str	r7, [r0, #0]
c0d00238:	6047      	str	r7, [r0, #4]
c0d0023a:	4628      	mov	r0, r5
c0d0023c:	4639      	mov	r1, r7
c0d0023e:	9a05      	ldr	r2, [sp, #20]
c0d00240:	4633      	mov	r3, r6
c0d00242:	f004 fb01 	bl	c0d04848 <cx_hash>

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash_final(cx_hash_t * hasher, unsigned char* out) {
    return cx_hash(hasher, CX_LAST, NULL, 0, out, 32);
c0d00246:	4668      	mov	r0, sp
c0d00248:	6046      	str	r6, [r0, #4]
c0d0024a:	ac09      	add	r4, sp, #36	; 0x24
c0d0024c:	6004      	str	r4, [r0, #0]
c0d0024e:	4628      	mov	r0, r5
c0d00250:	9904      	ldr	r1, [sp, #16]
c0d00252:	463a      	mov	r2, r7
c0d00254:	463b      	mov	r3, r7
c0d00256:	f004 faf7 	bl	c0d04848 <cx_hash>
c0d0025a:	2006      	movs	r0, #6

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d0025c:	490a      	ldr	r1, [pc, #40]	; (c0d00288 <_nvram_data_size+0x8>)
c0d0025e:	9a07      	ldr	r2, [sp, #28]
c0d00260:	5488      	strb	r0, [r1, r2]
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00262:	4628      	mov	r0, r5
c0d00264:	9906      	ldr	r1, [sp, #24]
c0d00266:	f004 fb21 	bl	c0d048ac <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d0026a:	4668      	mov	r0, sp
c0d0026c:	c050      	stmia	r0!, {r4, r6}
c0d0026e:	4907      	ldr	r1, [pc, #28]	; (c0d0028c <_nvram_data_size+0xc>)
c0d00270:	4628      	mov	r0, r5
c0d00272:	4622      	mov	r2, r4
c0d00274:	4633      	mov	r3, r6
c0d00276:	f004 fae7 	bl	c0d04848 <cx_hash>
c0d0027a:	2110      	movs	r1, #16
    monero_keccak_update_H(b, 32);
    monero_keccak_final_H(h1);

    monero_keccak_H(h1,32,h1);

    cx_aes_init_key(h1,16,sk);
c0d0027c:	4620      	mov	r0, r4
c0d0027e:	9a08      	ldr	r2, [sp, #32]

c0d00280 <_nvram_data_size>:
c0d00280:	f004 fb2c 	bl	c0d048dc <cx_aes_init_key>
}
c0d00284:	b011      	add	sp, #68	; 0x44
c0d00286:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00288:	20001930 	.word	0x20001930
c0d0028c:	00008001 	.word	0x00008001

c0d00290 <monero_hash_init_keccak>:
/* ----------------------------------------------------------------------- */
void monero_hash_init_sha256(cx_hash_t * hasher) {
    cx_sha256_init((cx_sha256_t *)hasher);
}

void monero_hash_init_keccak(cx_hash_t * hasher) {
c0d00290:	b580      	push	{r7, lr}
c0d00292:	2101      	movs	r1, #1
c0d00294:	0209      	lsls	r1, r1, #8
    cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00296:	f004 fb09 	bl	c0d048ac <cx_keccak_init>
}
c0d0029a:	bd80      	pop	{r7, pc}

c0d0029c <monero_hash_update>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_update(cx_hash_t * hasher, unsigned char* buf, unsigned int len) {
c0d0029c:	b510      	push	{r4, lr}
c0d0029e:	b082      	sub	sp, #8
c0d002a0:	4613      	mov	r3, r2
c0d002a2:	460a      	mov	r2, r1
c0d002a4:	2100      	movs	r1, #0
    cx_hash(hasher, 0, buf, len, NULL, 0);
c0d002a6:	466c      	mov	r4, sp
c0d002a8:	6021      	str	r1, [r4, #0]
c0d002aa:	6061      	str	r1, [r4, #4]
c0d002ac:	f004 facc 	bl	c0d04848 <cx_hash>
}
c0d002b0:	b002      	add	sp, #8
c0d002b2:	bd10      	pop	{r4, pc}

c0d002b4 <monero_hash_final>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash_final(cx_hash_t * hasher, unsigned char* out) {
c0d002b4:	b580      	push	{r7, lr}
c0d002b6:	b082      	sub	sp, #8
c0d002b8:	2220      	movs	r2, #32
    return cx_hash(hasher, CX_LAST, NULL, 0, out, 32);
c0d002ba:	466b      	mov	r3, sp
c0d002bc:	c306      	stmia	r3!, {r1, r2}
c0d002be:	2101      	movs	r1, #1
c0d002c0:	2200      	movs	r2, #0
c0d002c2:	4613      	mov	r3, r2
c0d002c4:	f004 fac0 	bl	c0d04848 <cx_hash>
c0d002c8:	b002      	add	sp, #8
c0d002ca:	bd80      	pop	{r7, pc}

c0d002cc <monero_hash>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
c0d002cc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d002ce:	b083      	sub	sp, #12
c0d002d0:	461c      	mov	r4, r3
c0d002d2:	4615      	mov	r5, r2
c0d002d4:	460e      	mov	r6, r1
    hasher->algo = algo;
c0d002d6:	7008      	strb	r0, [r1, #0]
c0d002d8:	9f08      	ldr	r7, [sp, #32]
    if (algo == CX_SHA256) {
c0d002da:	2803      	cmp	r0, #3
c0d002dc:	d103      	bne.n	c0d002e6 <monero_hash+0x1a>
         cx_sha256_init((cx_sha256_t *)hasher);
c0d002de:	4630      	mov	r0, r6
c0d002e0:	f004 face 	bl	c0d04880 <cx_sha256_init>
c0d002e4:	e004      	b.n	c0d002f0 <monero_hash+0x24>
c0d002e6:	2001      	movs	r0, #1
c0d002e8:	0201      	lsls	r1, r0, #8
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d002ea:	4630      	mov	r0, r6
c0d002ec:	f004 fade 	bl	c0d048ac <cx_keccak_init>
c0d002f0:	2020      	movs	r0, #32
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d002f2:	4669      	mov	r1, sp
c0d002f4:	600f      	str	r7, [r1, #0]
c0d002f6:	6048      	str	r0, [r1, #4]
c0d002f8:	4903      	ldr	r1, [pc, #12]	; (c0d00308 <monero_hash+0x3c>)
c0d002fa:	4630      	mov	r0, r6
c0d002fc:	462a      	mov	r2, r5
c0d002fe:	4623      	mov	r3, r4
c0d00300:	f004 faa2 	bl	c0d04848 <cx_hash>
c0d00304:	b003      	add	sp, #12
c0d00306:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00308:	00008001 	.word	0x00008001

c0d0030c <monero_rng>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

void monero_rng(unsigned char *r,  int len) {
c0d0030c:	b580      	push	{r7, lr}
    cx_rng(r,len);
c0d0030e:	f004 fa83 	bl	c0d04818 <cx_rng>
}
c0d00312:	bd80      	pop	{r7, pc}

c0d00314 <monero_encode_varint>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
c0d00314:	b510      	push	{r4, lr}
c0d00316:	2200      	movs	r2, #0
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d00318:	2980      	cmp	r1, #128	; 0x80
c0d0031a:	d309      	bcc.n	c0d00330 <monero_encode_varint+0x1c>
c0d0031c:	2200      	movs	r2, #0
c0d0031e:	460b      	mov	r3, r1
c0d00320:	2480      	movs	r4, #128	; 0x80
        varint[len] = (out_idx & 0x7F) | 0x80;
c0d00322:	430c      	orrs	r4, r1
c0d00324:	5484      	strb	r4, [r0, r2]
        out_idx = out_idx>>7;
c0d00326:	09d9      	lsrs	r1, r3, #7
        len++;
c0d00328:	1c52      	adds	r2, r2, #1
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d0032a:	0b9b      	lsrs	r3, r3, #14
c0d0032c:	460b      	mov	r3, r1
c0d0032e:	d1f7      	bne.n	c0d00320 <monero_encode_varint+0xc>
        varint[len] = (out_idx & 0x7F) | 0x80;
        out_idx = out_idx>>7;
        len++;
    }
    varint[len] = out_idx;
c0d00330:	5481      	strb	r1, [r0, r2]
    len++;
c0d00332:	1c50      	adds	r0, r2, #1
    return len;
c0d00334:	bd10      	pop	{r4, pc}

c0d00336 <monero_hash_init_sha256>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_init_sha256(cx_hash_t * hasher) {
c0d00336:	b580      	push	{r7, lr}
    cx_sha256_init((cx_sha256_t *)hasher);
c0d00338:	f004 faa2 	bl	c0d04880 <cx_sha256_init>
}
c0d0033c:	bd80      	pop	{r7, pc}
	...

c0d00340 <monero_hash_to_scalar>:
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_scalar(unsigned char *scalar, unsigned char *raw, unsigned int raw_len) {
c0d00340:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00342:	b083      	sub	sp, #12
c0d00344:	4615      	mov	r5, r2
c0d00346:	460e      	mov	r6, r1
c0d00348:	4604      	mov	r4, r0
c0d0034a:	2023      	movs	r0, #35	; 0x23
c0d0034c:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d0034e:	490c      	ldr	r1, [pc, #48]	; (c0d00380 <monero_hash_to_scalar+0x40>)
c0d00350:	2206      	movs	r2, #6
c0d00352:	540a      	strb	r2, [r1, r0]
c0d00354:	180f      	adds	r7, r1, r0
c0d00356:	2001      	movs	r0, #1
c0d00358:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d0035a:	4638      	mov	r0, r7
c0d0035c:	f004 faa6 	bl	c0d048ac <cx_keccak_init>
c0d00360:	2020      	movs	r0, #32
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00362:	4669      	mov	r1, sp
c0d00364:	600c      	str	r4, [r1, #0]
c0d00366:	6048      	str	r0, [r1, #4]
c0d00368:	4906      	ldr	r1, [pc, #24]	; (c0d00384 <monero_hash_to_scalar+0x44>)
c0d0036a:	4638      	mov	r0, r7
c0d0036c:	4632      	mov	r2, r6
c0d0036e:	462b      	mov	r3, r5
c0d00370:	f004 fa6a 	bl	c0d04848 <cx_hash>
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_scalar(unsigned char *scalar, unsigned char *raw, unsigned int raw_len) {
    monero_keccak_F(raw,raw_len,scalar);
    monero_reduce(scalar, scalar);
c0d00374:	4620      	mov	r0, r4
c0d00376:	4621      	mov	r1, r4
c0d00378:	f000 f806 	bl	c0d00388 <monero_reduce>
}
c0d0037c:	b003      	add	sp, #12
c0d0037e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00380:	20001930 	.word	0x20001930
c0d00384:	00008001 	.word	0x00008001

c0d00388 <monero_reduce>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reduce(unsigned char *r, unsigned char *a) {
c0d00388:	b570      	push	{r4, r5, r6, lr}
c0d0038a:	b088      	sub	sp, #32
c0d0038c:	4604      	mov	r4, r0
c0d0038e:	2000      	movs	r0, #0
c0d00390:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00392:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00394:	5c8d      	ldrb	r5, [r1, r2]
c0d00396:	466e      	mov	r6, sp
c0d00398:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d0039a:	54b3      	strb	r3, [r6, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d0039c:	1e52      	subs	r2, r2, #1
c0d0039e:	1c40      	adds	r0, r0, #1
c0d003a0:	2810      	cmp	r0, #16
c0d003a2:	d1f6      	bne.n	c0d00392 <monero_reduce+0xa>
c0d003a4:	4668      	mov	r0, sp
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reduce(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    monero_reverse32(ra,a);
    cx_math_modm(ra, 32, (unsigned char *)C_ED25519_ORDER, 32);
c0d003a6:	4a09      	ldr	r2, [pc, #36]	; (c0d003cc <monero_reduce+0x44>)
c0d003a8:	447a      	add	r2, pc
c0d003aa:	2120      	movs	r1, #32
c0d003ac:	460b      	mov	r3, r1
c0d003ae:	f004 fb87 	bl	c0d04ac0 <cx_math_modm>
c0d003b2:	2000      	movs	r0, #0
c0d003b4:	211f      	movs	r1, #31
c0d003b6:	466a      	mov	r2, sp
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d003b8:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d003ba:	5c52      	ldrb	r2, [r2, r1]
c0d003bc:	5422      	strb	r2, [r4, r0]
        rscal[31-i] = x;
c0d003be:	5463      	strb	r3, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d003c0:	1e49      	subs	r1, r1, #1
c0d003c2:	1c40      	adds	r0, r0, #1
c0d003c4:	2810      	cmp	r0, #16
c0d003c6:	d1f6      	bne.n	c0d003b6 <monero_reduce+0x2e>
void monero_reduce(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    monero_reverse32(ra,a);
    cx_math_modm(ra, 32, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,ra);
}
c0d003c8:	b008      	add	sp, #32
c0d003ca:	bd70      	pop	{r4, r5, r6, pc}
c0d003cc:	000064a0 	.word	0x000064a0

c0d003d0 <monero_hash_to_ec>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_ec(unsigned char *ec, unsigned char *ec_pub) {
c0d003d0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d003d2:	b09d      	sub	sp, #116	; 0x74
c0d003d4:	460d      	mov	r5, r1
c0d003d6:	4604      	mov	r4, r0
c0d003d8:	2023      	movs	r0, #35	; 0x23
c0d003da:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d003dc:	4fe1      	ldr	r7, [pc, #900]	; (c0d00764 <monero_hash_to_ec+0x394>)
c0d003de:	2106      	movs	r1, #6
c0d003e0:	5439      	strb	r1, [r7, r0]
c0d003e2:	183e      	adds	r6, r7, r0
c0d003e4:	2001      	movs	r0, #1
c0d003e6:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d003e8:	4630      	mov	r0, r6
c0d003ea:	f004 fa5f 	bl	c0d048ac <cx_keccak_init>
c0d003ee:	2220      	movs	r2, #32
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d003f0:	4668      	mov	r0, sp
c0d003f2:	6004      	str	r4, [r0, #0]
c0d003f4:	6042      	str	r2, [r0, #4]
c0d003f6:	49dc      	ldr	r1, [pc, #880]	; (c0d00768 <monero_hash_to_ec+0x398>)
c0d003f8:	4630      	mov	r0, r6
c0d003fa:	4616      	mov	r6, r2
c0d003fc:	462a      	mov	r2, r5
c0d003fe:	4633      	mov	r3, r6
c0d00400:	f004 fa22 	bl	c0d04848 <cx_hash>
c0d00404:	2000      	movs	r0, #0
c0d00406:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00408:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d0040a:	5c63      	ldrb	r3, [r4, r1]
c0d0040c:	183d      	adds	r5, r7, r0
c0d0040e:	73ab      	strb	r3, [r5, #14]
        rscal[31-i] = x;
c0d00410:	187b      	adds	r3, r7, r1
c0d00412:	739a      	strb	r2, [r3, #14]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00414:	1e49      	subs	r1, r1, #1
c0d00416:	1c40      	adds	r0, r0, #1
c0d00418:	290f      	cmp	r1, #15
c0d0041a:	d1f5      	bne.n	c0d00408 <monero_hash_to_ec+0x38>

    unsigned char sign;

    //cx works in BE
    monero_reverse32(u,bytes);
    cx_math_modm(u, 32, (unsigned char *)C_ED25519_FIELD, 32);
c0d0041c:	463d      	mov	r5, r7
c0d0041e:	350e      	adds	r5, #14
c0d00420:	4ad2      	ldr	r2, [pc, #840]	; (c0d0076c <monero_hash_to_ec+0x39c>)
c0d00422:	447a      	add	r2, pc
c0d00424:	920a      	str	r2, [sp, #40]	; 0x28
c0d00426:	4628      	mov	r0, r5
c0d00428:	4631      	mov	r1, r6
c0d0042a:	4633      	mov	r3, r6
c0d0042c:	f004 fb48 	bl	c0d04ac0 <cx_math_modm>

    //go on
    cx_math_multm(v, u, u, MOD);                           /* 2 * u^2 */
c0d00430:	4668      	mov	r0, sp
c0d00432:	6006      	str	r6, [r0, #0]
c0d00434:	960b      	str	r6, [sp, #44]	; 0x2c
c0d00436:	463e      	mov	r6, r7
c0d00438:	362e      	adds	r6, #46	; 0x2e
c0d0043a:	4630      	mov	r0, r6
c0d0043c:	4629      	mov	r1, r5
c0d0043e:	9507      	str	r5, [sp, #28]
c0d00440:	462a      	mov	r2, r5
c0d00442:	9d0a      	ldr	r5, [sp, #40]	; 0x28
c0d00444:	462b      	mov	r3, r5
c0d00446:	f004 fb09 	bl	c0d04a5c <cx_math_multm>
    cx_math_addm (v,  v, v, MOD);
c0d0044a:	4668      	mov	r0, sp
c0d0044c:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0044e:	6001      	str	r1, [r0, #0]
c0d00450:	4630      	mov	r0, r6
c0d00452:	4631      	mov	r1, r6
c0d00454:	4632      	mov	r2, r6
c0d00456:	462b      	mov	r3, r5
c0d00458:	f004 fad0 	bl	c0d049fc <cx_math_addm>

    os_memset    (w, 0, 32); w[31] = 1;                   /* w = 1 */
c0d0045c:	463d      	mov	r5, r7
c0d0045e:	354e      	adds	r5, #78	; 0x4e
c0d00460:	9508      	str	r5, [sp, #32]
c0d00462:	2100      	movs	r1, #0
c0d00464:	4628      	mov	r0, r5
c0d00466:	9a0b      	ldr	r2, [sp, #44]	; 0x2c
c0d00468:	f003 fa88 	bl	c0d0397c <os_memset>
c0d0046c:	206d      	movs	r0, #109	; 0x6d
c0d0046e:	2101      	movs	r1, #1
c0d00470:	9104      	str	r1, [sp, #16]
c0d00472:	5439      	strb	r1, [r7, r0]
    cx_math_addm (w, v, w,MOD );                          /* w = 2 * u^2 + 1 */
c0d00474:	4668      	mov	r0, sp
c0d00476:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00478:	6001      	str	r1, [r0, #0]
c0d0047a:	4628      	mov	r0, r5
c0d0047c:	4631      	mov	r1, r6
c0d0047e:	462a      	mov	r2, r5
c0d00480:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d00482:	f004 fabb 	bl	c0d049fc <cx_math_addm>
    cx_math_multm(x, w, w, MOD);                          /* w^2 */
c0d00486:	4668      	mov	r0, sp
c0d00488:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0048a:	6001      	str	r1, [r0, #0]
c0d0048c:	4638      	mov	r0, r7
c0d0048e:	306e      	adds	r0, #110	; 0x6e
c0d00490:	9009      	str	r0, [sp, #36]	; 0x24
c0d00492:	4629      	mov	r1, r5
c0d00494:	462a      	mov	r2, r5
c0d00496:	9d0a      	ldr	r5, [sp, #40]	; 0x28
c0d00498:	462b      	mov	r3, r5
c0d0049a:	f004 fadf 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(y, (unsigned char *)C_fe_ma2, v, MOD);  /* -2 * A^2 * u^2 */
c0d0049e:	4668      	mov	r0, sp
c0d004a0:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d004a2:	6001      	str	r1, [r0, #0]
c0d004a4:	4638      	mov	r0, r7
c0d004a6:	308e      	adds	r0, #142	; 0x8e
c0d004a8:	9005      	str	r0, [sp, #20]
c0d004aa:	49b1      	ldr	r1, [pc, #708]	; (c0d00770 <monero_hash_to_ec+0x3a0>)
c0d004ac:	4479      	add	r1, pc
c0d004ae:	9603      	str	r6, [sp, #12]
c0d004b0:	4632      	mov	r2, r6
c0d004b2:	462b      	mov	r3, r5
c0d004b4:	f004 fad2 	bl	c0d04a5c <cx_math_multm>
    cx_math_addm (x, x, y, MOD);                          /* x = w^2 - 2 * A^2 * u^2 */
c0d004b8:	4668      	mov	r0, sp
c0d004ba:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d004bc:	6006      	str	r6, [r0, #0]
c0d004be:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d004c0:	4601      	mov	r1, r0
c0d004c2:	9a05      	ldr	r2, [sp, #20]
c0d004c4:	462b      	mov	r3, r5
c0d004c6:	f004 fa99 	bl	c0d049fc <cx_math_addm>

    //inline fe_divpowm1(r->X, w, x);     // (w / x)^(m + 1) => fe_divpowm1(r,u,v)
    #define _u w
    #define _v x
    cx_math_multm(v3, _v,   _v, MOD);
c0d004ca:	4668      	mov	r0, sp
c0d004cc:	6006      	str	r6, [r0, #0]
c0d004ce:	ad0c      	add	r5, sp, #48	; 0x30
c0d004d0:	4628      	mov	r0, r5
c0d004d2:	3020      	adds	r0, #32
c0d004d4:	9006      	str	r0, [sp, #24]
c0d004d6:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d004d8:	460a      	mov	r2, r1
c0d004da:	9e0a      	ldr	r6, [sp, #40]	; 0x28
c0d004dc:	4633      	mov	r3, r6
c0d004de:	f004 fabd 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(v3,  v3,  _v, MOD);                       /* v3 = v^3 */
c0d004e2:	4668      	mov	r0, sp
c0d004e4:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d004e6:	6001      	str	r1, [r0, #0]
c0d004e8:	9806      	ldr	r0, [sp, #24]
c0d004ea:	4601      	mov	r1, r0
c0d004ec:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d004ee:	4633      	mov	r3, r6
c0d004f0:	f004 fab4 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(uv7, v3,  v3, MOD);
c0d004f4:	4668      	mov	r0, sp
c0d004f6:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d004f8:	6001      	str	r1, [r0, #0]
c0d004fa:	4628      	mov	r0, r5
c0d004fc:	9906      	ldr	r1, [sp, #24]
c0d004fe:	460a      	mov	r2, r1
c0d00500:	4633      	mov	r3, r6
c0d00502:	f004 faab 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(uv7, uv7, _v, MOD);
c0d00506:	4668      	mov	r0, sp
c0d00508:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0050a:	6001      	str	r1, [r0, #0]
c0d0050c:	4628      	mov	r0, r5
c0d0050e:	4629      	mov	r1, r5
c0d00510:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d00512:	4633      	mov	r3, r6
c0d00514:	f004 faa2 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(uv7, uv7, _u, MOD);                     /* uv7 = uv^7 */
c0d00518:	4668      	mov	r0, sp
c0d0051a:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0051c:	6001      	str	r1, [r0, #0]
c0d0051e:	4628      	mov	r0, r5
c0d00520:	4629      	mov	r1, r5
c0d00522:	9a08      	ldr	r2, [sp, #32]
c0d00524:	4633      	mov	r3, r6
c0d00526:	f004 fa99 	bl	c0d04a5c <cx_math_multm>
    cx_math_powm (uv7, uv7, (unsigned char *)C_fe_qm5div8, 32, MOD); /* (uv^7)^((q-5)/8)*/
c0d0052a:	4668      	mov	r0, sp
c0d0052c:	6006      	str	r6, [r0, #0]
c0d0052e:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00530:	6041      	str	r1, [r0, #4]
c0d00532:	4a90      	ldr	r2, [pc, #576]	; (c0d00774 <monero_hash_to_ec+0x3a4>)
c0d00534:	447a      	add	r2, pc
c0d00536:	4628      	mov	r0, r5
c0d00538:	4629      	mov	r1, r5
c0d0053a:	9b0b      	ldr	r3, [sp, #44]	; 0x2c
c0d0053c:	f004 faa6 	bl	c0d04a8c <cx_math_powm>
    cx_math_multm(uv7, uv7, v3, MOD);
c0d00540:	4668      	mov	r0, sp
c0d00542:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00544:	6001      	str	r1, [r0, #0]
c0d00546:	4628      	mov	r0, r5
c0d00548:	4629      	mov	r1, r5
c0d0054a:	9a06      	ldr	r2, [sp, #24]
c0d0054c:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d0054e:	f004 fa85 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(rX,  uv7, w, MOD);                      /* u^(m+1)v^(-(m+1)) */
c0d00552:	4668      	mov	r0, sp
c0d00554:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00556:	6001      	str	r1, [r0, #0]
c0d00558:	463e      	mov	r6, r7
c0d0055a:	36ce      	adds	r6, #206	; 0xce
c0d0055c:	4630      	mov	r0, r6
c0d0055e:	4629      	mov	r1, r5
c0d00560:	9a08      	ldr	r2, [sp, #32]
c0d00562:	9b0a      	ldr	r3, [sp, #40]	; 0x28
c0d00564:	f004 fa7a 	bl	c0d04a5c <cx_math_multm>
    #undef _u
    #undef _v

    cx_math_multm(y, rX,rX, MOD);
c0d00568:	4668      	mov	r0, sp
c0d0056a:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d0056c:	6001      	str	r1, [r0, #0]
c0d0056e:	9d05      	ldr	r5, [sp, #20]
c0d00570:	4628      	mov	r0, r5
c0d00572:	4631      	mov	r1, r6
c0d00574:	9606      	str	r6, [sp, #24]
c0d00576:	4632      	mov	r2, r6
c0d00578:	9e0a      	ldr	r6, [sp, #40]	; 0x28
c0d0057a:	4633      	mov	r3, r6
c0d0057c:	f004 fa6e 	bl	c0d04a5c <cx_math_multm>
    cx_math_multm(x, y, x, MOD);
c0d00580:	4668      	mov	r0, sp
c0d00582:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00584:	6001      	str	r1, [r0, #0]
c0d00586:	9809      	ldr	r0, [sp, #36]	; 0x24
c0d00588:	4629      	mov	r1, r5
c0d0058a:	4602      	mov	r2, r0
c0d0058c:	4633      	mov	r3, r6
c0d0058e:	f004 fa65 	bl	c0d04a5c <cx_math_multm>
    cx_math_subm(y, w, x, MOD);
c0d00592:	4668      	mov	r0, sp
c0d00594:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d00596:	6006      	str	r6, [r0, #0]
c0d00598:	4628      	mov	r0, r5
c0d0059a:	ab08      	add	r3, sp, #32
c0d0059c:	cb0e      	ldmia	r3, {r1, r2, r3}
c0d0059e:	f004 fa45 	bl	c0d04a2c <cx_math_subm>
    os_memmove(z, C_fe_ma, 32);
c0d005a2:	4638      	mov	r0, r7
c0d005a4:	30ae      	adds	r0, #174	; 0xae
c0d005a6:	4974      	ldr	r1, [pc, #464]	; (c0d00778 <monero_hash_to_ec+0x3a8>)
c0d005a8:	4479      	add	r1, pc
c0d005aa:	900a      	str	r0, [sp, #40]	; 0x28
c0d005ac:	4632      	mov	r2, r6
c0d005ae:	f003 f9ee 	bl	c0d0398e <os_memmove>

    if (!cx_math_is_zero(y,32)) {
c0d005b2:	4628      	mov	r0, r5
c0d005b4:	4631      	mov	r1, r6
c0d005b6:	f004 fa09 	bl	c0d049cc <cx_math_is_zero>
c0d005ba:	2800      	cmp	r0, #0
c0d005bc:	d006      	beq.n	c0d005cc <monero_hash_to_ec+0x1fc>
       goto negative;
     } else {
      cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb1, MOD);
     }
   } else {
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb2, MOD);
c0d005be:	4668      	mov	r0, sp
c0d005c0:	6006      	str	r6, [r0, #0]
c0d005c2:	4638      	mov	r0, r7
c0d005c4:	30ce      	adds	r0, #206	; 0xce
c0d005c6:	4a6f      	ldr	r2, [pc, #444]	; (c0d00784 <monero_hash_to_ec+0x3b4>)
c0d005c8:	447a      	add	r2, pc
c0d005ca:	e016      	b.n	c0d005fa <monero_hash_to_ec+0x22a>
    cx_math_multm(x, y, x, MOD);
    cx_math_subm(y, w, x, MOD);
    os_memmove(z, C_fe_ma, 32);

    if (!cx_math_is_zero(y,32)) {
     cx_math_addm(y, w, x, MOD);
c0d005cc:	4668      	mov	r0, sp
c0d005ce:	6006      	str	r6, [r0, #0]
c0d005d0:	463a      	mov	r2, r7
c0d005d2:	326e      	adds	r2, #110	; 0x6e
c0d005d4:	4b69      	ldr	r3, [pc, #420]	; (c0d0077c <monero_hash_to_ec+0x3ac>)
c0d005d6:	447b      	add	r3, pc
c0d005d8:	9d05      	ldr	r5, [sp, #20]
c0d005da:	4628      	mov	r0, r5
c0d005dc:	9908      	ldr	r1, [sp, #32]
c0d005de:	f004 fa0d 	bl	c0d049fc <cx_math_addm>
     if (!cx_math_is_zero(y,32)) {
c0d005e2:	4628      	mov	r0, r5
c0d005e4:	4631      	mov	r1, r6
c0d005e6:	f004 f9f1 	bl	c0d049cc <cx_math_is_zero>
c0d005ea:	2800      	cmp	r0, #0
c0d005ec:	d07c      	beq.n	c0d006e8 <monero_hash_to_ec+0x318>
       goto negative;
     } else {
      cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb1, MOD);
c0d005ee:	4668      	mov	r0, sp
c0d005f0:	6006      	str	r6, [r0, #0]
c0d005f2:	4638      	mov	r0, r7
c0d005f4:	30ce      	adds	r0, #206	; 0xce
c0d005f6:	4a62      	ldr	r2, [pc, #392]	; (c0d00780 <monero_hash_to_ec+0x3b0>)
c0d005f8:	447a      	add	r2, pc
c0d005fa:	4b63      	ldr	r3, [pc, #396]	; (c0d00788 <monero_hash_to_ec+0x3b8>)
c0d005fc:	447b      	add	r3, pc
c0d005fe:	4601      	mov	r1, r0
c0d00600:	f004 fa2c 	bl	c0d04a5c <cx_math_multm>
     }
   } else {
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb2, MOD);
   }
   cx_math_multm(rX, rX, u, MOD);  // u * sqrt(2 * A * (A + 2) * w / x)
c0d00604:	4668      	mov	r0, sp
c0d00606:	6006      	str	r6, [r0, #0]
c0d00608:	463a      	mov	r2, r7
c0d0060a:	320e      	adds	r2, #14
c0d0060c:	4d5f      	ldr	r5, [pc, #380]	; (c0d0078c <monero_hash_to_ec+0x3bc>)
c0d0060e:	447d      	add	r5, pc
c0d00610:	9806      	ldr	r0, [sp, #24]
c0d00612:	4601      	mov	r1, r0
c0d00614:	462b      	mov	r3, r5
c0d00616:	f004 fa21 	bl	c0d04a5c <cx_math_multm>
   cx_math_multm(z, z, v, MOD);        // -2 * A * u^2
c0d0061a:	4668      	mov	r0, sp
c0d0061c:	6006      	str	r6, [r0, #0]
c0d0061e:	980a      	ldr	r0, [sp, #40]	; 0x28
c0d00620:	4601      	mov	r1, r0
c0d00622:	9a03      	ldr	r2, [sp, #12]
c0d00624:	462b      	mov	r3, r5
c0d00626:	f004 fa19 	bl	c0d04a5c <cx_math_multm>
c0d0062a:	2000      	movs	r0, #0
c0d0062c:	21ed      	movs	r1, #237	; 0xed
   // r->X = sqrt(A * (A + 2) * w / x)
   // z = -A
   sign = 1;

 setsign:
   if (fe_isnegative(rX) != sign) {
c0d0062e:	5c79      	ldrb	r1, [r7, r1]
c0d00630:	9a04      	ldr	r2, [sp, #16]
c0d00632:	4011      	ands	r1, r2
c0d00634:	4288      	cmp	r0, r1
c0d00636:	d009      	beq.n	c0d0064c <monero_hash_to_ec+0x27c>
     //fe_neg(r->X, r->X);
    cx_math_subm(rX, (unsigned char *)C_ED25519_FIELD, rX, MOD);
c0d00638:	4668      	mov	r0, sp
c0d0063a:	6006      	str	r6, [r0, #0]
c0d0063c:	4638      	mov	r0, r7
c0d0063e:	30ce      	adds	r0, #206	; 0xce
c0d00640:	4959      	ldr	r1, [pc, #356]	; (c0d007a8 <monero_hash_to_ec+0x3d8>)
c0d00642:	4479      	add	r1, pc
c0d00644:	4602      	mov	r2, r0
c0d00646:	460b      	mov	r3, r1
c0d00648:	f004 f9f0 	bl	c0d04a2c <cx_math_subm>
   }
   cx_math_addm(rZ, z, w, MOD);
c0d0064c:	4668      	mov	r0, sp
c0d0064e:	6006      	str	r6, [r0, #0]
c0d00650:	2087      	movs	r0, #135	; 0x87
c0d00652:	0040      	lsls	r0, r0, #1
c0d00654:	1838      	adds	r0, r7, r0
c0d00656:	9009      	str	r0, [sp, #36]	; 0x24
c0d00658:	463e      	mov	r6, r7
c0d0065a:	364e      	adds	r6, #78	; 0x4e
c0d0065c:	4d53      	ldr	r5, [pc, #332]	; (c0d007ac <monero_hash_to_ec+0x3dc>)
c0d0065e:	447d      	add	r5, pc
c0d00660:	9508      	str	r5, [sp, #32]
c0d00662:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d00664:	4632      	mov	r2, r6
c0d00666:	462b      	mov	r3, r5
c0d00668:	f004 f9c8 	bl	c0d049fc <cx_math_addm>
   cx_math_subm(rY, z, w, MOD);
c0d0066c:	4668      	mov	r0, sp
c0d0066e:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00670:	6001      	str	r1, [r0, #0]
c0d00672:	37ee      	adds	r7, #238	; 0xee
c0d00674:	4638      	mov	r0, r7
c0d00676:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d00678:	4632      	mov	r2, r6
c0d0067a:	462b      	mov	r3, r5
c0d0067c:	f004 f9d6 	bl	c0d04a2c <cx_math_subm>
   cx_math_multm(rX, rX, rZ, MOD);
c0d00680:	4668      	mov	r0, sp
c0d00682:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d00684:	6006      	str	r6, [r0, #0]
c0d00686:	9806      	ldr	r0, [sp, #24]
c0d00688:	4601      	mov	r1, r0
c0d0068a:	9a09      	ldr	r2, [sp, #36]	; 0x24
c0d0068c:	462b      	mov	r3, r5
c0d0068e:	f004 f9e5 	bl	c0d04a5c <cx_math_multm>

   //back to monero y-affine
   cx_math_invprimem(u, rZ, MOD);
c0d00692:	9807      	ldr	r0, [sp, #28]
c0d00694:	9909      	ldr	r1, [sp, #36]	; 0x24
c0d00696:	462a      	mov	r2, r5
c0d00698:	4633      	mov	r3, r6
c0d0069a:	4635      	mov	r5, r6
c0d0069c:	f004 fa26 	bl	c0d04aec <cx_math_invprimem>
c0d006a0:	ae0c      	add	r6, sp, #48	; 0x30
c0d006a2:	2004      	movs	r0, #4
   Pxy[0] = 0x04;
c0d006a4:	7030      	strb	r0, [r6, #0]
   cx_math_multm(&Pxy[1],    rX, u, MOD);
c0d006a6:	4668      	mov	r0, sp
c0d006a8:	6005      	str	r5, [r0, #0]
c0d006aa:	1c70      	adds	r0, r6, #1
c0d006ac:	900a      	str	r0, [sp, #40]	; 0x28
c0d006ae:	ab06      	add	r3, sp, #24
c0d006b0:	cb0e      	ldmia	r3, {r1, r2, r3}
c0d006b2:	f004 f9d3 	bl	c0d04a5c <cx_math_multm>
   cx_math_multm(&Pxy[1+32], rY, u, MOD);
c0d006b6:	4668      	mov	r0, sp
c0d006b8:	6005      	str	r5, [r0, #0]
c0d006ba:	4630      	mov	r0, r6
c0d006bc:	3021      	adds	r0, #33	; 0x21
c0d006be:	4639      	mov	r1, r7
c0d006c0:	9a07      	ldr	r2, [sp, #28]
c0d006c2:	9b08      	ldr	r3, [sp, #32]
c0d006c4:	f004 f9ca 	bl	c0d04a5c <cx_math_multm>
c0d006c8:	2041      	movs	r0, #65	; 0x41
   cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d006ca:	4631      	mov	r1, r6
c0d006cc:	4602      	mov	r2, r0
c0d006ce:	f004 f951 	bl	c0d04974 <cx_edward_compress_point>
   os_memmove(ge, &Pxy[1], 32);
c0d006d2:	4620      	mov	r0, r4
c0d006d4:	990a      	ldr	r1, [sp, #40]	; 0x28
c0d006d6:	462a      	mov	r2, r5
c0d006d8:	f003 f959 	bl	c0d0398e <os_memmove>
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_hash_to_ec(unsigned char *ec, unsigned char *ec_pub) {
    monero_keccak_F(ec_pub, 32, ec);
    monero_ge_fromfe_frombytes(ec, ec);
    monero_ecmul_8(ec, ec);
c0d006dc:	4620      	mov	r0, r4
c0d006de:	4621      	mov	r1, r4
c0d006e0:	f000 f866 	bl	c0d007b0 <monero_ecmul_8>
}
c0d006e4:	b01d      	add	sp, #116	; 0x74
c0d006e6:	bdf0      	pop	{r4, r5, r6, r7, pc}
   sign = 0;

   goto setsign;

  negative:
   cx_math_multm(x, x, (unsigned char *)C_fe_sqrtm1, MOD);
c0d006e8:	4668      	mov	r0, sp
c0d006ea:	6006      	str	r6, [r0, #0]
c0d006ec:	463d      	mov	r5, r7
c0d006ee:	356e      	adds	r5, #110	; 0x6e
c0d006f0:	4a27      	ldr	r2, [pc, #156]	; (c0d00790 <monero_hash_to_ec+0x3c0>)
c0d006f2:	447a      	add	r2, pc
c0d006f4:	4e27      	ldr	r6, [pc, #156]	; (c0d00794 <monero_hash_to_ec+0x3c4>)
c0d006f6:	447e      	add	r6, pc
c0d006f8:	4628      	mov	r0, r5
c0d006fa:	4629      	mov	r1, r5
c0d006fc:	4633      	mov	r3, r6
c0d006fe:	f004 f9ad 	bl	c0d04a5c <cx_math_multm>
   cx_math_subm(y, w, x, MOD);
c0d00702:	4668      	mov	r0, sp
c0d00704:	990b      	ldr	r1, [sp, #44]	; 0x2c
c0d00706:	6001      	str	r1, [r0, #0]
c0d00708:	9805      	ldr	r0, [sp, #20]
c0d0070a:	9908      	ldr	r1, [sp, #32]
c0d0070c:	462a      	mov	r2, r5
c0d0070e:	4633      	mov	r3, r6
c0d00710:	9e0b      	ldr	r6, [sp, #44]	; 0x2c
c0d00712:	f004 f98b 	bl	c0d04a2c <cx_math_subm>
   if (!cx_math_is_zero(y,32)) {
c0d00716:	9805      	ldr	r0, [sp, #20]
c0d00718:	4631      	mov	r1, r6
c0d0071a:	f004 f957 	bl	c0d049cc <cx_math_is_zero>
c0d0071e:	2800      	cmp	r0, #0
c0d00720:	d009      	beq.n	c0d00736 <monero_hash_to_ec+0x366>
     cx_math_addm(y, w, x, MOD);
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb3, MOD);
   } else {
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb4, MOD);
c0d00722:	4668      	mov	r0, sp
c0d00724:	6006      	str	r6, [r0, #0]
c0d00726:	4638      	mov	r0, r7
c0d00728:	30ce      	adds	r0, #206	; 0xce
c0d0072a:	4a1d      	ldr	r2, [pc, #116]	; (c0d007a0 <monero_hash_to_ec+0x3d0>)
c0d0072c:	447a      	add	r2, pc
c0d0072e:	4b1d      	ldr	r3, [pc, #116]	; (c0d007a4 <monero_hash_to_ec+0x3d4>)
c0d00730:	447b      	add	r3, pc
c0d00732:	4601      	mov	r1, r0
c0d00734:	e012      	b.n	c0d0075c <monero_hash_to_ec+0x38c>

  negative:
   cx_math_multm(x, x, (unsigned char *)C_fe_sqrtm1, MOD);
   cx_math_subm(y, w, x, MOD);
   if (!cx_math_is_zero(y,32)) {
     cx_math_addm(y, w, x, MOD);
c0d00736:	4668      	mov	r0, sp
c0d00738:	6006      	str	r6, [r0, #0]
c0d0073a:	463a      	mov	r2, r7
c0d0073c:	326e      	adds	r2, #110	; 0x6e
c0d0073e:	4d16      	ldr	r5, [pc, #88]	; (c0d00798 <monero_hash_to_ec+0x3c8>)
c0d00740:	447d      	add	r5, pc
c0d00742:	9805      	ldr	r0, [sp, #20]
c0d00744:	9908      	ldr	r1, [sp, #32]
c0d00746:	462b      	mov	r3, r5
c0d00748:	f004 f958 	bl	c0d049fc <cx_math_addm>
     cx_math_multm(rX, rX, (unsigned char *)C_fe_fffb3, MOD);
c0d0074c:	4668      	mov	r0, sp
c0d0074e:	6006      	str	r6, [r0, #0]
c0d00750:	4638      	mov	r0, r7
c0d00752:	30ce      	adds	r0, #206	; 0xce
c0d00754:	4a11      	ldr	r2, [pc, #68]	; (c0d0079c <monero_hash_to_ec+0x3cc>)
c0d00756:	447a      	add	r2, pc
c0d00758:	4601      	mov	r1, r0
c0d0075a:	462b      	mov	r3, r5
c0d0075c:	f004 f97e 	bl	c0d04a5c <cx_math_multm>
c0d00760:	2001      	movs	r0, #1
c0d00762:	e763      	b.n	c0d0062c <monero_hash_to_ec+0x25c>
c0d00764:	20001930 	.word	0x20001930
c0d00768:	00008001 	.word	0x00008001
c0d0076c:	00006446 	.word	0x00006446
c0d00770:	000063dc 	.word	0x000063dc
c0d00774:	00006434 	.word	0x00006434
c0d00778:	00006300 	.word	0x00006300
c0d0077c:	00006292 	.word	0x00006292
c0d00780:	000062d0 	.word	0x000062d0
c0d00784:	00006320 	.word	0x00006320
c0d00788:	0000626c 	.word	0x0000626c
c0d0078c:	0000625a 	.word	0x0000625a
c0d00790:	00006256 	.word	0x00006256
c0d00794:	00006172 	.word	0x00006172
c0d00798:	00006128 	.word	0x00006128
c0d0079c:	000061b2 	.word	0x000061b2
c0d007a0:	000061fc 	.word	0x000061fc
c0d007a4:	00006138 	.word	0x00006138
c0d007a8:	00006226 	.word	0x00006226
c0d007ac:	0000620a 	.word	0x0000620a

c0d007b0 <monero_ecmul_8>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_8(unsigned char *W, unsigned char *P) {
c0d007b0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d007b2:	b093      	sub	sp, #76	; 0x4c
c0d007b4:	9001      	str	r0, [sp, #4]
c0d007b6:	af02      	add	r7, sp, #8
c0d007b8:	2002      	movs	r0, #2
    unsigned char Pxy[65];

    Pxy[0] = 0x02;
c0d007ba:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d007bc:	1c7d      	adds	r5, r7, #1
c0d007be:	2620      	movs	r6, #32
c0d007c0:	4628      	mov	r0, r5
c0d007c2:	4632      	mov	r2, r6
c0d007c4:	f003 f8e3 	bl	c0d0398e <os_memmove>
c0d007c8:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d007ca:	4620      	mov	r0, r4
c0d007cc:	4639      	mov	r1, r7
c0d007ce:	4622      	mov	r2, r4
c0d007d0:	f004 f8e6 	bl	c0d049a0 <cx_edward_decompress_point>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
c0d007d4:	4668      	mov	r0, sp
c0d007d6:	6004      	str	r4, [r0, #0]
c0d007d8:	4620      	mov	r0, r4
c0d007da:	4639      	mov	r1, r7
c0d007dc:	463a      	mov	r2, r7
c0d007de:	463b      	mov	r3, r7
c0d007e0:	f004 f894 	bl	c0d0490c <cx_ecfp_add_point>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
c0d007e4:	4668      	mov	r0, sp
c0d007e6:	6004      	str	r4, [r0, #0]
c0d007e8:	4620      	mov	r0, r4
c0d007ea:	4639      	mov	r1, r7
c0d007ec:	463a      	mov	r2, r7
c0d007ee:	463b      	mov	r3, r7
c0d007f0:	f004 f88c 	bl	c0d0490c <cx_ecfp_add_point>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Pxy, sizeof(Pxy));
c0d007f4:	4668      	mov	r0, sp
c0d007f6:	6004      	str	r4, [r0, #0]
c0d007f8:	4620      	mov	r0, r4
c0d007fa:	4639      	mov	r1, r7
c0d007fc:	463a      	mov	r2, r7
c0d007fe:	463b      	mov	r3, r7
c0d00800:	f004 f884 	bl	c0d0490c <cx_ecfp_add_point>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00804:	4620      	mov	r0, r4
c0d00806:	4639      	mov	r1, r7
c0d00808:	4622      	mov	r2, r4
c0d0080a:	f004 f8b3 	bl	c0d04974 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d0080e:	9801      	ldr	r0, [sp, #4]
c0d00810:	4629      	mov	r1, r5
c0d00812:	4632      	mov	r2, r6
c0d00814:	f003 f8bb 	bl	c0d0398e <os_memmove>
}
c0d00818:	b013      	add	sp, #76	; 0x4c
c0d0081a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0081c <monero_generate_keypair>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_keypair(unsigned char *ec_pub, unsigned char *ec_priv) {
c0d0081c:	b5b0      	push	{r4, r5, r7, lr}
c0d0081e:	460c      	mov	r4, r1
c0d00820:	4605      	mov	r5, r0
c0d00822:	2120      	movs	r1, #32
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */

void monero_rng(unsigned char *r,  int len) {
    cx_rng(r,len);
c0d00824:	4620      	mov	r0, r4
c0d00826:	f003 fff7 	bl	c0d04818 <cx_rng>
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_keypair(unsigned char *ec_pub, unsigned char *ec_priv) {
    monero_rng(ec_priv,32);
    monero_reduce(ec_priv, ec_priv);
c0d0082a:	4620      	mov	r0, r4
c0d0082c:	4621      	mov	r1, r4
c0d0082e:	f7ff fdab 	bl	c0d00388 <monero_reduce>
    monero_ecmul_G(ec_pub, ec_priv);
c0d00832:	4628      	mov	r0, r5
c0d00834:	4621      	mov	r1, r4
c0d00836:	f000 f801 	bl	c0d0083c <monero_ecmul_G>
}
c0d0083a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0083c <monero_ecmul_G>:
/* ======================================================================= */

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_G(unsigned char *W,  unsigned char *scalar32) {
c0d0083c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0083e:	b09b      	sub	sp, #108	; 0x6c
c0d00840:	4604      	mov	r4, r0
c0d00842:	2000      	movs	r0, #0
c0d00844:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00846:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00848:	5c8d      	ldrb	r5, [r1, r2]
c0d0084a:	ae02      	add	r6, sp, #8
c0d0084c:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d0084e:	54b3      	strb	r3, [r6, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00850:	1e52      	subs	r2, r2, #1
c0d00852:	1c40      	adds	r0, r0, #1
c0d00854:	2810      	cmp	r0, #16
c0d00856:	d1f6      	bne.n	c0d00846 <monero_ecmul_G+0xa>
c0d00858:	ad0a      	add	r5, sp, #40	; 0x28
/* ----------------------------------------------------------------------- */
void monero_ecmul_G(unsigned char *W,  unsigned char *scalar32) {
    unsigned char Pxy[65];
    unsigned char s[32];
    monero_reverse32(s, scalar32);
    os_memmove(Pxy, C_ED25519_G, 65);
c0d0085a:	490e      	ldr	r1, [pc, #56]	; (c0d00894 <monero_ecmul_G+0x58>)
c0d0085c:	4479      	add	r1, pc
c0d0085e:	2641      	movs	r6, #65	; 0x41
c0d00860:	4628      	mov	r0, r5
c0d00862:	4632      	mov	r2, r6
c0d00864:	f003 f893 	bl	c0d0398e <os_memmove>
c0d00868:	2720      	movs	r7, #32
    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
c0d0086a:	4668      	mov	r0, sp
c0d0086c:	6007      	str	r7, [r0, #0]
c0d0086e:	ab02      	add	r3, sp, #8
c0d00870:	4630      	mov	r0, r6
c0d00872:	4629      	mov	r1, r5
c0d00874:	4632      	mov	r2, r6
c0d00876:	f004 f863 	bl	c0d04940 <cx_ecfp_scalar_mult>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d0087a:	4630      	mov	r0, r6
c0d0087c:	4629      	mov	r1, r5
c0d0087e:	4632      	mov	r2, r6
c0d00880:	f004 f878 	bl	c0d04974 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d00884:	1c69      	adds	r1, r5, #1
c0d00886:	4620      	mov	r0, r4
c0d00888:	463a      	mov	r2, r7
c0d0088a:	f003 f880 	bl	c0d0398e <os_memmove>
}
c0d0088e:	b01b      	add	sp, #108	; 0x6c
c0d00890:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00892:	46c0      	nop			; (mov r8, r8)
c0d00894:	00006134 	.word	0x00006134

c0d00898 <monero_generate_key_derivation>:
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_derivation(unsigned char *drv_data, unsigned char *P, unsigned char *scalar) {
c0d00898:	b570      	push	{r4, r5, r6, lr}
c0d0089a:	b088      	sub	sp, #32
c0d0089c:	460c      	mov	r4, r1
c0d0089e:	4605      	mov	r5, r0
c0d008a0:	466e      	mov	r6, sp
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_8k(unsigned char *W, unsigned char *P, unsigned char *scalar32) {
    unsigned char s[32];
    monero_multm_8(s, scalar32);
c0d008a2:	4630      	mov	r0, r6
c0d008a4:	4611      	mov	r1, r2
c0d008a6:	f000 fa03 	bl	c0d00cb0 <monero_multm_8>
    monero_ecmul_k(W, P, s);
c0d008aa:	4628      	mov	r0, r5
c0d008ac:	4621      	mov	r1, r4
c0d008ae:	4632      	mov	r2, r6
c0d008b0:	f000 f8db 	bl	c0d00a6a <monero_ecmul_k>
/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_derivation(unsigned char *drv_data, unsigned char *P, unsigned char *scalar) {
    monero_ecmul_8k(drv_data,P,scalar);
}
c0d008b4:	b008      	add	sp, #32
c0d008b6:	bd70      	pop	{r4, r5, r6, pc}

c0d008b8 <monero_derivation_to_scalar>:

/* ----------------------------------------------------------------------- */
/* ---  ok                                                             --- */
/* ----------------------------------------------------------------------- */
void monero_derivation_to_scalar(unsigned char *scalar, unsigned char *drv_data, unsigned int out_idx) {
c0d008b8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d008ba:	b08d      	sub	sp, #52	; 0x34
c0d008bc:	4617      	mov	r7, r2
c0d008be:	9002      	str	r0, [sp, #8]
c0d008c0:	ac03      	add	r4, sp, #12
c0d008c2:	2520      	movs	r5, #32
    unsigned char varint[32+8];
    unsigned int len_varint;

    os_memmove(varint, drv_data, 32);
c0d008c4:	4620      	mov	r0, r4
c0d008c6:	462a      	mov	r2, r5
c0d008c8:	f003 f861 	bl	c0d0398e <os_memmove>
    len_varint = monero_encode_varint(varint+32, out_idx);
c0d008cc:	3420      	adds	r4, #32
c0d008ce:	2600      	movs	r6, #0
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d008d0:	2f80      	cmp	r7, #128	; 0x80
c0d008d2:	d30b      	bcc.n	c0d008ec <monero_derivation_to_scalar+0x34>
c0d008d4:	a803      	add	r0, sp, #12
        varint[len] = (out_idx & 0x7F) | 0x80;
c0d008d6:	3020      	adds	r0, #32
c0d008d8:	2600      	movs	r6, #0
c0d008da:	4639      	mov	r1, r7
c0d008dc:	2280      	movs	r2, #128	; 0x80
c0d008de:	433a      	orrs	r2, r7
c0d008e0:	5582      	strb	r2, [r0, r6]
        out_idx = out_idx>>7;
c0d008e2:	09cf      	lsrs	r7, r1, #7
        len++;
c0d008e4:	1c76      	adds	r6, r6, #1
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
unsigned int monero_encode_varint(unsigned char varint[8], unsigned int out_idx) {
    unsigned int len;
    len = 0;
    while(out_idx >= 0x80) {
c0d008e6:	0b89      	lsrs	r1, r1, #14
c0d008e8:	4639      	mov	r1, r7
c0d008ea:	d1f7      	bne.n	c0d008dc <monero_derivation_to_scalar+0x24>
        varint[len] = (out_idx & 0x7F) | 0x80;
        out_idx = out_idx>>7;
        len++;
    }
    varint[len] = out_idx;
c0d008ec:	55a7      	strb	r7, [r4, r6]
c0d008ee:	2023      	movs	r0, #35	; 0x23
c0d008f0:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d008f2:	490d      	ldr	r1, [pc, #52]	; (c0d00928 <monero_derivation_to_scalar+0x70>)
c0d008f4:	2206      	movs	r2, #6
c0d008f6:	540a      	strb	r2, [r1, r0]
c0d008f8:	180c      	adds	r4, r1, r0
c0d008fa:	2001      	movs	r0, #1
c0d008fc:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d008fe:	4620      	mov	r0, r4
c0d00900:	f003 ffd4 	bl	c0d048ac <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00904:	4668      	mov	r0, sp
c0d00906:	6045      	str	r5, [r0, #4]
c0d00908:	ad03      	add	r5, sp, #12
c0d0090a:	6005      	str	r5, [r0, #0]
    unsigned char varint[32+8];
    unsigned int len_varint;

    os_memmove(varint, drv_data, 32);
    len_varint = monero_encode_varint(varint+32, out_idx);
    len_varint += 32;
c0d0090c:	3621      	adds	r6, #33	; 0x21
c0d0090e:	4907      	ldr	r1, [pc, #28]	; (c0d0092c <monero_derivation_to_scalar+0x74>)
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00910:	4620      	mov	r0, r4
c0d00912:	462a      	mov	r2, r5
c0d00914:	4633      	mov	r3, r6
c0d00916:	f003 ff97 	bl	c0d04848 <cx_hash>

    os_memmove(varint, drv_data, 32);
    len_varint = monero_encode_varint(varint+32, out_idx);
    len_varint += 32;
    monero_keccak_F(varint,len_varint,varint);
    monero_reduce(scalar, varint);
c0d0091a:	9802      	ldr	r0, [sp, #8]
c0d0091c:	4629      	mov	r1, r5
c0d0091e:	f7ff fd33 	bl	c0d00388 <monero_reduce>
}
c0d00922:	b00d      	add	sp, #52	; 0x34
c0d00924:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00926:	46c0      	nop			; (mov r8, r8)
c0d00928:	20001930 	.word	0x20001930
c0d0092c:	00008001 	.word	0x00008001

c0d00930 <monero_derive_secret_key>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_derive_secret_key(unsigned char *x,
                              unsigned char *drv_data, unsigned int out_idx, unsigned char *ec_priv) {
c0d00930:	b570      	push	{r4, r5, r6, lr}
c0d00932:	b088      	sub	sp, #32
c0d00934:	461c      	mov	r4, r3
c0d00936:	4605      	mov	r5, r0
c0d00938:	466e      	mov	r6, sp
    unsigned char tmp[32];

    //derivation to scalar
    monero_derivation_to_scalar(tmp,drv_data,out_idx);
c0d0093a:	4630      	mov	r0, r6
c0d0093c:	f7ff ffbc 	bl	c0d008b8 <monero_derivation_to_scalar>

    //generate
    monero_addm(x, tmp, ec_priv);
c0d00940:	4628      	mov	r0, r5
c0d00942:	4631      	mov	r1, r6
c0d00944:	4622      	mov	r2, r4
c0d00946:	f000 f803 	bl	c0d00950 <monero_addm>
}
c0d0094a:	b008      	add	sp, #32
c0d0094c:	bd70      	pop	{r4, r5, r6, pc}
	...

c0d00950 <monero_addm>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_addm(unsigned char *r, unsigned char *a, unsigned char *b) {
c0d00950:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00952:	b091      	sub	sp, #68	; 0x44
c0d00954:	4604      	mov	r4, r0
c0d00956:	2000      	movs	r0, #0
c0d00958:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d0095a:	5c0d      	ldrb	r5, [r1, r0]
        rscal[i]    = scal [31-i];
c0d0095c:	5cce      	ldrb	r6, [r1, r3]
c0d0095e:	af09      	add	r7, sp, #36	; 0x24
c0d00960:	543e      	strb	r6, [r7, r0]
        rscal[31-i] = x;
c0d00962:	54fd      	strb	r5, [r7, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00964:	1e5b      	subs	r3, r3, #1
c0d00966:	1c40      	adds	r0, r0, #1
c0d00968:	2810      	cmp	r0, #16
c0d0096a:	d1f6      	bne.n	c0d0095a <monero_addm+0xa>
c0d0096c:	2000      	movs	r0, #0
c0d0096e:	211f      	movs	r1, #31
        x           = scal[i];
c0d00970:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00972:	5c55      	ldrb	r5, [r2, r1]
c0d00974:	ae01      	add	r6, sp, #4
c0d00976:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00978:	5473      	strb	r3, [r6, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d0097a:	1e49      	subs	r1, r1, #1
c0d0097c:	1c40      	adds	r0, r0, #1
c0d0097e:	2810      	cmp	r0, #16
c0d00980:	d1f6      	bne.n	c0d00970 <monero_addm+0x20>
c0d00982:	2020      	movs	r0, #32
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_addm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00984:	4669      	mov	r1, sp
c0d00986:	6008      	str	r0, [r1, #0]
c0d00988:	a909      	add	r1, sp, #36	; 0x24
c0d0098a:	aa01      	add	r2, sp, #4
c0d0098c:	4b08      	ldr	r3, [pc, #32]	; (c0d009b0 <monero_addm+0x60>)
c0d0098e:	447b      	add	r3, pc
c0d00990:	4620      	mov	r0, r4
c0d00992:	f004 f833 	bl	c0d049fc <cx_math_addm>
c0d00996:	2000      	movs	r0, #0
c0d00998:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d0099a:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d0099c:	5c63      	ldrb	r3, [r4, r1]
c0d0099e:	5423      	strb	r3, [r4, r0]
        rscal[31-i] = x;
c0d009a0:	5462      	strb	r2, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d009a2:	1e49      	subs	r1, r1, #1
c0d009a4:	1c40      	adds	r0, r0, #1
c0d009a6:	290f      	cmp	r1, #15
c0d009a8:	d1f7      	bne.n	c0d0099a <monero_addm+0x4a>

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_addm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d009aa:	b011      	add	sp, #68	; 0x44
c0d009ac:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d009ae:	46c0      	nop			; (mov r8, r8)
c0d009b0:	00005eba 	.word	0x00005eba

c0d009b4 <monero_derive_public_key>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_derive_public_key(unsigned char *x,
                              unsigned char* drv_data, unsigned int out_idx, unsigned char *ec_pub) {
c0d009b4:	b570      	push	{r4, r5, r6, lr}
c0d009b6:	b088      	sub	sp, #32
c0d009b8:	461c      	mov	r4, r3
c0d009ba:	4605      	mov	r5, r0
c0d009bc:	466e      	mov	r6, sp
    unsigned char tmp[32];

    //derivation to scalar
    monero_derivation_to_scalar(tmp,drv_data,out_idx);
c0d009be:	4630      	mov	r0, r6
c0d009c0:	f7ff ff7a 	bl	c0d008b8 <monero_derivation_to_scalar>
    //generate
    monero_ecmul_G(tmp,tmp);
c0d009c4:	4630      	mov	r0, r6
c0d009c6:	4631      	mov	r1, r6
c0d009c8:	f7ff ff38 	bl	c0d0083c <monero_ecmul_G>
    monero_ecadd(x,tmp,ec_pub);
c0d009cc:	4628      	mov	r0, r5
c0d009ce:	4631      	mov	r1, r6
c0d009d0:	4622      	mov	r2, r4
c0d009d2:	f000 f802 	bl	c0d009da <monero_ecadd>
}
c0d009d6:	b008      	add	sp, #32
c0d009d8:	bd70      	pop	{r4, r5, r6, pc}

c0d009da <monero_ecadd>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecadd(unsigned char *W, unsigned char *P, unsigned char *Q) {
c0d009da:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d009dc:	b0a7      	sub	sp, #156	; 0x9c
c0d009de:	9202      	str	r2, [sp, #8]
c0d009e0:	9004      	str	r0, [sp, #16]
c0d009e2:	af16      	add	r7, sp, #88	; 0x58
c0d009e4:	2002      	movs	r0, #2
    unsigned char Pxy[65];
    unsigned char Qxy[65];

    Pxy[0] = 0x02;
c0d009e6:	9001      	str	r0, [sp, #4]
c0d009e8:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d009ea:	1c78      	adds	r0, r7, #1
c0d009ec:	9003      	str	r0, [sp, #12]
c0d009ee:	2620      	movs	r6, #32
c0d009f0:	4632      	mov	r2, r6
c0d009f2:	f002 ffcc 	bl	c0d0398e <os_memmove>
c0d009f6:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d009f8:	4620      	mov	r0, r4
c0d009fa:	4639      	mov	r1, r7
c0d009fc:	4622      	mov	r2, r4
c0d009fe:	f003 ffcf 	bl	c0d049a0 <cx_edward_decompress_point>
c0d00a02:	ad05      	add	r5, sp, #20

    Qxy[0] = 0x02;
c0d00a04:	9801      	ldr	r0, [sp, #4]
c0d00a06:	7028      	strb	r0, [r5, #0]
    os_memmove(&Qxy[1], Q, 32);
c0d00a08:	1c68      	adds	r0, r5, #1
c0d00a0a:	9902      	ldr	r1, [sp, #8]
c0d00a0c:	4632      	mov	r2, r6
c0d00a0e:	f002 ffbe 	bl	c0d0398e <os_memmove>
    cx_edward_decompress_point(CX_CURVE_Ed25519, Qxy, sizeof(Qxy));
c0d00a12:	4620      	mov	r0, r4
c0d00a14:	4629      	mov	r1, r5
c0d00a16:	4622      	mov	r2, r4
c0d00a18:	f003 ffc2 	bl	c0d049a0 <cx_edward_decompress_point>

    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Qxy, sizeof(Pxy));
c0d00a1c:	4668      	mov	r0, sp
c0d00a1e:	6004      	str	r4, [r0, #0]
c0d00a20:	4620      	mov	r0, r4
c0d00a22:	4639      	mov	r1, r7
c0d00a24:	463a      	mov	r2, r7
c0d00a26:	462b      	mov	r3, r5
c0d00a28:	f003 ff70 	bl	c0d0490c <cx_ecfp_add_point>

    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00a2c:	4620      	mov	r0, r4
c0d00a2e:	4639      	mov	r1, r7
c0d00a30:	4622      	mov	r2, r4
c0d00a32:	f003 ff9f 	bl	c0d04974 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d00a36:	9804      	ldr	r0, [sp, #16]
c0d00a38:	9903      	ldr	r1, [sp, #12]
c0d00a3a:	4632      	mov	r2, r6
c0d00a3c:	f002 ffa7 	bl	c0d0398e <os_memmove>
}
c0d00a40:	b027      	add	sp, #156	; 0x9c
c0d00a42:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00a44 <monero_secret_key_to_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_secret_key_to_public_key(unsigned char *ec_pub, unsigned char *ec_priv) {
c0d00a44:	b580      	push	{r7, lr}
    monero_ecmul_G(ec_pub, ec_priv);
c0d00a46:	f7ff fef9 	bl	c0d0083c <monero_ecmul_G>
}
c0d00a4a:	bd80      	pop	{r7, pc}

c0d00a4c <monero_generate_key_image>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_generate_key_image(unsigned char *img, unsigned char *P, unsigned char* x) {
c0d00a4c:	b570      	push	{r4, r5, r6, lr}
c0d00a4e:	b088      	sub	sp, #32
c0d00a50:	4614      	mov	r4, r2
c0d00a52:	4605      	mov	r5, r0
c0d00a54:	466e      	mov	r6, sp
    unsigned char I[32];
    monero_hash_to_ec(I,P);
c0d00a56:	4630      	mov	r0, r6
c0d00a58:	f7ff fcba 	bl	c0d003d0 <monero_hash_to_ec>
    monero_ecmul_k(img, I,x);
c0d00a5c:	4628      	mov	r0, r5
c0d00a5e:	4631      	mov	r1, r6
c0d00a60:	4622      	mov	r2, r4
c0d00a62:	f000 f802 	bl	c0d00a6a <monero_ecmul_k>
}
c0d00a66:	b008      	add	sp, #32
c0d00a68:	bd70      	pop	{r4, r5, r6, pc}

c0d00a6a <monero_ecmul_k>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_k(unsigned char *W, unsigned char *P, unsigned char *scalar32) {
c0d00a6a:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00a6c:	b09b      	sub	sp, #108	; 0x6c
c0d00a6e:	9001      	str	r0, [sp, #4]
c0d00a70:	2000      	movs	r0, #0
c0d00a72:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00a74:	5c14      	ldrb	r4, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00a76:	5cd5      	ldrb	r5, [r2, r3]
c0d00a78:	ae02      	add	r6, sp, #8
c0d00a7a:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00a7c:	54f4      	strb	r4, [r6, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00a7e:	1e5b      	subs	r3, r3, #1
c0d00a80:	1c40      	adds	r0, r0, #1
c0d00a82:	2810      	cmp	r0, #16
c0d00a84:	d1f6      	bne.n	c0d00a74 <monero_ecmul_k+0xa>
c0d00a86:	af0a      	add	r7, sp, #40	; 0x28
c0d00a88:	2002      	movs	r0, #2
    unsigned char Pxy[65];
    unsigned char s[32];

    monero_reverse32(s, scalar32);

    Pxy[0] = 0x02;
c0d00a8a:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], P, 32);
c0d00a8c:	1c7d      	adds	r5, r7, #1
c0d00a8e:	2620      	movs	r6, #32
c0d00a90:	4628      	mov	r0, r5
c0d00a92:	4632      	mov	r2, r6
c0d00a94:	f002 ff7b 	bl	c0d0398e <os_memmove>
c0d00a98:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00a9a:	4620      	mov	r0, r4
c0d00a9c:	4639      	mov	r1, r7
c0d00a9e:	4622      	mov	r2, r4
c0d00aa0:	f003 ff7e 	bl	c0d049a0 <cx_edward_decompress_point>

    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
c0d00aa4:	4668      	mov	r0, sp
c0d00aa6:	6006      	str	r6, [r0, #0]
c0d00aa8:	ab02      	add	r3, sp, #8
c0d00aaa:	4620      	mov	r0, r4
c0d00aac:	4639      	mov	r1, r7
c0d00aae:	4622      	mov	r2, r4
c0d00ab0:	f003 ff46 	bl	c0d04940 <cx_ecfp_scalar_mult>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00ab4:	4620      	mov	r0, r4
c0d00ab6:	4639      	mov	r1, r7
c0d00ab8:	4622      	mov	r2, r4
c0d00aba:	f003 ff5b 	bl	c0d04974 <cx_edward_compress_point>

    os_memmove(W, &Pxy[1], 32);
c0d00abe:	9801      	ldr	r0, [sp, #4]
c0d00ac0:	4629      	mov	r1, r5
c0d00ac2:	4632      	mov	r2, r6
c0d00ac4:	f002 ff63 	bl	c0d0398e <os_memmove>
}
c0d00ac8:	b01b      	add	sp, #108	; 0x6c
c0d00aca:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00acc <monero_derive_subaddress_public_key>:

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_derive_subaddress_public_key(unsigned char *x,
                                         unsigned char *pub, unsigned char* drv_data, unsigned int index) {
c0d00acc:	b570      	push	{r4, r5, r6, lr}
c0d00ace:	b088      	sub	sp, #32
c0d00ad0:	460c      	mov	r4, r1
c0d00ad2:	4605      	mov	r5, r0
c0d00ad4:	466e      	mov	r6, sp
  unsigned char scalarG[32];

  monero_derivation_to_scalar(scalarG , drv_data, index);
c0d00ad6:	4630      	mov	r0, r6
c0d00ad8:	4611      	mov	r1, r2
c0d00ada:	461a      	mov	r2, r3
c0d00adc:	f7ff feec 	bl	c0d008b8 <monero_derivation_to_scalar>
  monero_ecmul_G(scalarG, scalarG);
c0d00ae0:	4630      	mov	r0, r6
c0d00ae2:	4631      	mov	r1, r6
c0d00ae4:	f7ff feaa 	bl	c0d0083c <monero_ecmul_G>
  monero_ecsub(x, pub, scalarG);
c0d00ae8:	4628      	mov	r0, r5
c0d00aea:	4621      	mov	r1, r4
c0d00aec:	4632      	mov	r2, r6
c0d00aee:	f000 f803 	bl	c0d00af8 <monero_ecsub>
}
c0d00af2:	b008      	add	sp, #32
c0d00af4:	bd70      	pop	{r4, r5, r6, pc}
	...

c0d00af8 <monero_ecsub>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecsub(unsigned char *W, unsigned char *P, unsigned char *Q) {
c0d00af8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00afa:	b0a7      	sub	sp, #156	; 0x9c
c0d00afc:	9201      	str	r2, [sp, #4]
c0d00afe:	9004      	str	r0, [sp, #16]
c0d00b00:	ad16      	add	r5, sp, #88	; 0x58
c0d00b02:	2602      	movs	r6, #2
    unsigned char Pxy[65];
    unsigned char Qxy[65];

    Pxy[0] = 0x02;
c0d00b04:	702e      	strb	r6, [r5, #0]
    os_memmove(&Pxy[1], P, 32);
c0d00b06:	1c68      	adds	r0, r5, #1
c0d00b08:	9502      	str	r5, [sp, #8]
c0d00b0a:	9003      	str	r0, [sp, #12]
c0d00b0c:	2720      	movs	r7, #32
c0d00b0e:	463a      	mov	r2, r7
c0d00b10:	f002 ff3d 	bl	c0d0398e <os_memmove>
c0d00b14:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00b16:	4620      	mov	r0, r4
c0d00b18:	4629      	mov	r1, r5
c0d00b1a:	4622      	mov	r2, r4
c0d00b1c:	f003 ff40 	bl	c0d049a0 <cx_edward_decompress_point>
c0d00b20:	ad05      	add	r5, sp, #20

    Qxy[0] = 0x02;
c0d00b22:	702e      	strb	r6, [r5, #0]
    os_memmove(&Qxy[1], Q, 32);
c0d00b24:	1c6e      	adds	r6, r5, #1
c0d00b26:	4630      	mov	r0, r6
c0d00b28:	9901      	ldr	r1, [sp, #4]
c0d00b2a:	463a      	mov	r2, r7
c0d00b2c:	f002 ff2f 	bl	c0d0398e <os_memmove>
    cx_edward_decompress_point(CX_CURVE_Ed25519, Qxy, sizeof(Qxy));
c0d00b30:	4620      	mov	r0, r4
c0d00b32:	4629      	mov	r1, r5
c0d00b34:	4622      	mov	r2, r4
c0d00b36:	f003 ff33 	bl	c0d049a0 <cx_edward_decompress_point>

    cx_math_subm(Qxy+1, (unsigned char *)C_ED25519_FIELD,  Qxy+1, (unsigned char *)C_ED25519_FIELD, 32);
c0d00b3a:	4668      	mov	r0, sp
c0d00b3c:	6007      	str	r7, [r0, #0]
c0d00b3e:	490e      	ldr	r1, [pc, #56]	; (c0d00b78 <monero_ecsub+0x80>)
c0d00b40:	4479      	add	r1, pc
c0d00b42:	4630      	mov	r0, r6
c0d00b44:	4632      	mov	r2, r6
c0d00b46:	460b      	mov	r3, r1
c0d00b48:	f003 ff70 	bl	c0d04a2c <cx_math_subm>
    cx_ecfp_add_point(CX_CURVE_Ed25519, Pxy, Pxy, Qxy, sizeof(Pxy));
c0d00b4c:	4668      	mov	r0, sp
c0d00b4e:	6004      	str	r4, [r0, #0]
c0d00b50:	4620      	mov	r0, r4
c0d00b52:	9e02      	ldr	r6, [sp, #8]
c0d00b54:	4631      	mov	r1, r6
c0d00b56:	4632      	mov	r2, r6
c0d00b58:	462b      	mov	r3, r5
c0d00b5a:	f003 fed7 	bl	c0d0490c <cx_ecfp_add_point>

    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00b5e:	4620      	mov	r0, r4
c0d00b60:	4631      	mov	r1, r6
c0d00b62:	4622      	mov	r2, r4
c0d00b64:	f003 ff06 	bl	c0d04974 <cx_edward_compress_point>
    os_memmove(W, &Pxy[1], 32);
c0d00b68:	9804      	ldr	r0, [sp, #16]
c0d00b6a:	9903      	ldr	r1, [sp, #12]
c0d00b6c:	463a      	mov	r2, r7
c0d00b6e:	f002 ff0e 	bl	c0d0398e <os_memmove>
}
c0d00b72:	b027      	add	sp, #156	; 0x9c
c0d00b74:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00b76:	46c0      	nop			; (mov r8, r8)
c0d00b78:	00005d28 	.word	0x00005d28

c0d00b7c <monero_get_subaddress_spend_public_key>:
}

/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
void monero_get_subaddress_spend_public_key(unsigned char *x,unsigned char *index) {
c0d00b7c:	b5b0      	push	{r4, r5, r7, lr}
c0d00b7e:	460a      	mov	r2, r1
c0d00b80:	4604      	mov	r4, r0
c0d00b82:	2051      	movs	r0, #81	; 0x51
c0d00b84:	0080      	lsls	r0, r0, #2
    // m = Hs(a || index_major || index_minor)
    monero_get_subaddress_secret_key(x, G_monero_vstate.a, index);
c0d00b86:	4d08      	ldr	r5, [pc, #32]	; (c0d00ba8 <monero_get_subaddress_spend_public_key+0x2c>)
c0d00b88:	1829      	adds	r1, r5, r0
c0d00b8a:	4620      	mov	r0, r4
c0d00b8c:	f000 f80e 	bl	c0d00bac <monero_get_subaddress_secret_key>

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_secret_key_to_public_key(unsigned char *ec_pub, unsigned char *ec_priv) {
    monero_ecmul_G(ec_pub, ec_priv);
c0d00b90:	4620      	mov	r0, r4
c0d00b92:	4621      	mov	r1, r4
c0d00b94:	f7ff fe52 	bl	c0d0083c <monero_ecmul_G>
c0d00b98:	2069      	movs	r0, #105	; 0x69
c0d00b9a:	0080      	lsls	r0, r0, #2
    // m = Hs(a || index_major || index_minor)
    monero_get_subaddress_secret_key(x, G_monero_vstate.a, index);
    // M = m*G
    monero_secret_key_to_public_key(x,x);
    // D = B + M
    monero_ecadd(x,x,G_monero_vstate.B);
c0d00b9c:	182a      	adds	r2, r5, r0
c0d00b9e:	4620      	mov	r0, r4
c0d00ba0:	4621      	mov	r1, r4
c0d00ba2:	f7ff ff1a 	bl	c0d009da <monero_ecadd>
 }
c0d00ba6:	bdb0      	pop	{r4, r5, r7, pc}
c0d00ba8:	20001930 	.word	0x20001930

c0d00bac <monero_get_subaddress_secret_key>:
/* ----------------------------------------------------------------------- */
/* --- ok                                                              --- */
/* ----------------------------------------------------------------------- */
static const  char C_sub_address_prefix[] = {'S','u','b','A','d','d','r', 0};

void monero_get_subaddress_secret_key(unsigned char *sub_s, unsigned char *s, unsigned char *index) {
c0d00bac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00bae:	b091      	sub	sp, #68	; 0x44
c0d00bb0:	9204      	str	r2, [sp, #16]
c0d00bb2:	9103      	str	r1, [sp, #12]
c0d00bb4:	4604      	mov	r4, r0
c0d00bb6:	ad05      	add	r5, sp, #20
    unsigned char in[sizeof(C_sub_address_prefix)+32+8];

    os_memmove(in,                               C_sub_address_prefix, sizeof(C_sub_address_prefix)),
c0d00bb8:	4918      	ldr	r1, [pc, #96]	; (c0d00c1c <monero_get_subaddress_secret_key+0x70>)
c0d00bba:	4479      	add	r1, pc
c0d00bbc:	2708      	movs	r7, #8
c0d00bbe:	4628      	mov	r0, r5
c0d00bc0:	463a      	mov	r2, r7
c0d00bc2:	f002 fee4 	bl	c0d0398e <os_memmove>
    os_memmove(in+sizeof(C_sub_address_prefix),    s,                  32);
c0d00bc6:	4628      	mov	r0, r5
c0d00bc8:	3008      	adds	r0, #8
c0d00bca:	2620      	movs	r6, #32
c0d00bcc:	9903      	ldr	r1, [sp, #12]
c0d00bce:	4632      	mov	r2, r6
c0d00bd0:	f002 fedd 	bl	c0d0398e <os_memmove>
    os_memmove(in+sizeof(C_sub_address_prefix)+32, index,              8);
c0d00bd4:	4628      	mov	r0, r5
c0d00bd6:	3028      	adds	r0, #40	; 0x28
c0d00bd8:	9904      	ldr	r1, [sp, #16]
c0d00bda:	463a      	mov	r2, r7
c0d00bdc:	f002 fed7 	bl	c0d0398e <os_memmove>
c0d00be0:	2023      	movs	r0, #35	; 0x23
c0d00be2:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d00be4:	490b      	ldr	r1, [pc, #44]	; (c0d00c14 <monero_get_subaddress_secret_key+0x68>)
c0d00be6:	2206      	movs	r2, #6
c0d00be8:	540a      	strb	r2, [r1, r0]
c0d00bea:	180f      	adds	r7, r1, r0
c0d00bec:	2001      	movs	r0, #1
c0d00bee:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00bf0:	4638      	mov	r0, r7
c0d00bf2:	f003 fe5b 	bl	c0d048ac <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00bf6:	4668      	mov	r0, sp
c0d00bf8:	c050      	stmia	r0!, {r4, r6}
c0d00bfa:	4907      	ldr	r1, [pc, #28]	; (c0d00c18 <monero_get_subaddress_secret_key+0x6c>)
c0d00bfc:	2330      	movs	r3, #48	; 0x30
c0d00bfe:	4638      	mov	r0, r7
c0d00c00:	462a      	mov	r2, r5
c0d00c02:	f003 fe21 	bl	c0d04848 <cx_hash>
    os_memmove(in,                               C_sub_address_prefix, sizeof(C_sub_address_prefix)),
    os_memmove(in+sizeof(C_sub_address_prefix),    s,                  32);
    os_memmove(in+sizeof(C_sub_address_prefix)+32, index,              8);
    //hash_to_scalar with more that 32bytes:
    monero_keccak_F(in, sizeof(in), sub_s);
    monero_reduce(sub_s, sub_s);
c0d00c06:	4620      	mov	r0, r4
c0d00c08:	4621      	mov	r1, r4
c0d00c0a:	f7ff fbbd 	bl	c0d00388 <monero_reduce>
}
c0d00c0e:	b011      	add	sp, #68	; 0x44
c0d00c10:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00c12:	46c0      	nop			; (mov r8, r8)
c0d00c14:	20001930 	.word	0x20001930
c0d00c18:	00008001 	.word	0x00008001
c0d00c1c:	00005dce 	.word	0x00005dce

c0d00c20 <monero_get_subaddress>:
 }

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_get_subaddress(unsigned char *C, unsigned char *D, unsigned char *index) {
c0d00c20:	b5b0      	push	{r4, r5, r7, lr}
c0d00c22:	460c      	mov	r4, r1
c0d00c24:	4605      	mov	r5, r0
    //retrieve D
    monero_get_subaddress_spend_public_key(D, index);
c0d00c26:	4608      	mov	r0, r1
c0d00c28:	4611      	mov	r1, r2
c0d00c2a:	f7ff ffa7 	bl	c0d00b7c <monero_get_subaddress_spend_public_key>
c0d00c2e:	2051      	movs	r0, #81	; 0x51
c0d00c30:	0080      	lsls	r0, r0, #2
    // C = a*D
    monero_ecmul_k(C,D,G_monero_vstate.a);
c0d00c32:	4903      	ldr	r1, [pc, #12]	; (c0d00c40 <monero_get_subaddress+0x20>)
c0d00c34:	180a      	adds	r2, r1, r0
c0d00c36:	4628      	mov	r0, r5
c0d00c38:	4621      	mov	r1, r4
c0d00c3a:	f7ff ff16 	bl	c0d00a6a <monero_ecmul_k>
}
c0d00c3e:	bdb0      	pop	{r4, r5, r7, pc}
c0d00c40:	20001930 	.word	0x20001930

c0d00c44 <monero_ecmul_H>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_ecmul_H(unsigned char *W,  unsigned char *scalar32) {
c0d00c44:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00c46:	b09b      	sub	sp, #108	; 0x6c
c0d00c48:	9001      	str	r0, [sp, #4]
c0d00c4a:	2000      	movs	r0, #0
c0d00c4c:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00c4e:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00c50:	5c8c      	ldrb	r4, [r1, r2]
c0d00c52:	ad02      	add	r5, sp, #8
c0d00c54:	542c      	strb	r4, [r5, r0]
        rscal[31-i] = x;
c0d00c56:	54ab      	strb	r3, [r5, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00c58:	1e52      	subs	r2, r2, #1
c0d00c5a:	1c40      	adds	r0, r0, #1
c0d00c5c:	2810      	cmp	r0, #16
c0d00c5e:	d1f6      	bne.n	c0d00c4e <monero_ecmul_H+0xa>
c0d00c60:	af0a      	add	r7, sp, #40	; 0x28
c0d00c62:	2002      	movs	r0, #2
    unsigned char Pxy[65];
    unsigned char s[32];

    monero_reverse32(s, scalar32);

    Pxy[0] = 0x02;
c0d00c64:	7038      	strb	r0, [r7, #0]
    os_memmove(&Pxy[1], C_ED25519_Hy, 32);
c0d00c66:	1c7d      	adds	r5, r7, #1
c0d00c68:	4910      	ldr	r1, [pc, #64]	; (c0d00cac <monero_ecmul_H+0x68>)
c0d00c6a:	4479      	add	r1, pc
c0d00c6c:	2620      	movs	r6, #32
c0d00c6e:	4628      	mov	r0, r5
c0d00c70:	4632      	mov	r2, r6
c0d00c72:	f002 fe8c 	bl	c0d0398e <os_memmove>
c0d00c76:	2441      	movs	r4, #65	; 0x41
    cx_edward_decompress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00c78:	4620      	mov	r0, r4
c0d00c7a:	4639      	mov	r1, r7
c0d00c7c:	4622      	mov	r2, r4
c0d00c7e:	f003 fe8f 	bl	c0d049a0 <cx_edward_decompress_point>

    cx_ecfp_scalar_mult(CX_CURVE_Ed25519, Pxy, sizeof(Pxy), s, 32);
c0d00c82:	4668      	mov	r0, sp
c0d00c84:	6006      	str	r6, [r0, #0]
c0d00c86:	ab02      	add	r3, sp, #8
c0d00c88:	4620      	mov	r0, r4
c0d00c8a:	4639      	mov	r1, r7
c0d00c8c:	4622      	mov	r2, r4
c0d00c8e:	f003 fe57 	bl	c0d04940 <cx_ecfp_scalar_mult>
    cx_edward_compress_point(CX_CURVE_Ed25519, Pxy, sizeof(Pxy));
c0d00c92:	4620      	mov	r0, r4
c0d00c94:	4639      	mov	r1, r7
c0d00c96:	4622      	mov	r2, r4
c0d00c98:	f003 fe6c 	bl	c0d04974 <cx_edward_compress_point>

    os_memmove(W, &Pxy[1], 32);
c0d00c9c:	9801      	ldr	r0, [sp, #4]
c0d00c9e:	4629      	mov	r1, r5
c0d00ca0:	4632      	mov	r2, r6
c0d00ca2:	f002 fe74 	bl	c0d0398e <os_memmove>
}
c0d00ca6:	b01b      	add	sp, #108	; 0x6c
c0d00ca8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00caa:	46c0      	nop			; (mov r8, r8)
c0d00cac:	00005d67 	.word	0x00005d67

c0d00cb0 <monero_multm_8>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_multm_8(unsigned char *r, unsigned char *a) {
c0d00cb0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00cb2:	b091      	sub	sp, #68	; 0x44
c0d00cb4:	4604      	mov	r4, r0
c0d00cb6:	2000      	movs	r0, #0
c0d00cb8:	221f      	movs	r2, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00cba:	5c0b      	ldrb	r3, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00cbc:	5c8d      	ldrb	r5, [r1, r2]
c0d00cbe:	ae09      	add	r6, sp, #36	; 0x24
c0d00cc0:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00cc2:	54b3      	strb	r3, [r6, r2]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00cc4:	1e52      	subs	r2, r2, #1
c0d00cc6:	1c40      	adds	r0, r0, #1
c0d00cc8:	2810      	cmp	r0, #16
c0d00cca:	d1f6      	bne.n	c0d00cba <monero_multm_8+0xa>
c0d00ccc:	ae01      	add	r6, sp, #4
c0d00cce:	2500      	movs	r5, #0
c0d00cd0:	2720      	movs	r7, #32
void monero_multm_8(unsigned char *r, unsigned char *a) {
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    os_memset(rb,0,32);
c0d00cd2:	4630      	mov	r0, r6
c0d00cd4:	4629      	mov	r1, r5
c0d00cd6:	463a      	mov	r2, r7
c0d00cd8:	f002 fe50 	bl	c0d0397c <os_memset>
c0d00cdc:	2008      	movs	r0, #8
    rb[31] = 8;
c0d00cde:	77f0      	strb	r0, [r6, #31]
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00ce0:	4668      	mov	r0, sp
c0d00ce2:	6007      	str	r7, [r0, #0]
c0d00ce4:	a909      	add	r1, sp, #36	; 0x24
c0d00ce6:	4b08      	ldr	r3, [pc, #32]	; (c0d00d08 <monero_multm_8+0x58>)
c0d00ce8:	447b      	add	r3, pc
c0d00cea:	4620      	mov	r0, r4
c0d00cec:	4632      	mov	r2, r6
c0d00cee:	f003 feb5 	bl	c0d04a5c <cx_math_multm>
c0d00cf2:	201f      	movs	r0, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00cf4:	5d61      	ldrb	r1, [r4, r5]
        rscal[i]    = scal [31-i];
c0d00cf6:	5c22      	ldrb	r2, [r4, r0]
c0d00cf8:	5562      	strb	r2, [r4, r5]
        rscal[31-i] = x;
c0d00cfa:	5421      	strb	r1, [r4, r0]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00cfc:	1e40      	subs	r0, r0, #1
c0d00cfe:	1c6d      	adds	r5, r5, #1
c0d00d00:	280f      	cmp	r0, #15
c0d00d02:	d1f7      	bne.n	c0d00cf4 <monero_multm_8+0x44>
    monero_reverse32(ra,a);
    os_memset(rb,0,32);
    rb[31] = 8;
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d00d04:	b011      	add	sp, #68	; 0x44
c0d00d06:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00d08:	00005b60 	.word	0x00005b60

c0d00d0c <monero_ecdhHash>:
        memcpy(data + 6, &k, sizeof(k));
        cn_fast_hash(hash, data, sizeof(data));
        return hash;
    }
*/
void monero_ecdhHash(unsigned char *x, unsigned char *k) {
c0d00d0c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00d0e:	b08d      	sub	sp, #52	; 0x34
c0d00d10:	460d      	mov	r5, r1
c0d00d12:	9002      	str	r0, [sp, #8]
c0d00d14:	ac03      	add	r4, sp, #12
  unsigned char data[38];
  os_memmove(data, "amount", 6);
c0d00d16:	4913      	ldr	r1, [pc, #76]	; (c0d00d64 <monero_ecdhHash+0x58>)
c0d00d18:	4479      	add	r1, pc
c0d00d1a:	2706      	movs	r7, #6
c0d00d1c:	4620      	mov	r0, r4
c0d00d1e:	463a      	mov	r2, r7
c0d00d20:	f002 fe35 	bl	c0d0398e <os_memmove>
  os_memmove(data + 6, k, 32);
c0d00d24:	1da0      	adds	r0, r4, #6
c0d00d26:	2620      	movs	r6, #32
c0d00d28:	4629      	mov	r1, r5
c0d00d2a:	4632      	mov	r2, r6
c0d00d2c:	f002 fe2f 	bl	c0d0398e <os_memmove>
c0d00d30:	2023      	movs	r0, #35	; 0x23
c0d00d32:	0100      	lsls	r0, r0, #4

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_hash(unsigned int algo, cx_hash_t * hasher, unsigned char* buf, unsigned int len, unsigned char* out) {
    hasher->algo = algo;
c0d00d34:	4909      	ldr	r1, [pc, #36]	; (c0d00d5c <monero_ecdhHash+0x50>)
c0d00d36:	540f      	strb	r7, [r1, r0]
c0d00d38:	180d      	adds	r5, r1, r0
c0d00d3a:	2001      	movs	r0, #1
c0d00d3c:	0201      	lsls	r1, r0, #8
    if (algo == CX_SHA256) {
         cx_sha256_init((cx_sha256_t *)hasher);
    } else {
        cx_keccak_init((cx_sha3_t *)hasher, 256);
c0d00d3e:	4628      	mov	r0, r5
c0d00d40:	f003 fdb4 	bl	c0d048ac <cx_keccak_init>
    }
    return cx_hash(hasher, CX_LAST|CX_NO_REINIT, buf, len, out, 32);
c0d00d44:	4668      	mov	r0, sp
c0d00d46:	9902      	ldr	r1, [sp, #8]
c0d00d48:	c042      	stmia	r0!, {r1, r6}
c0d00d4a:	4905      	ldr	r1, [pc, #20]	; (c0d00d60 <monero_ecdhHash+0x54>)
c0d00d4c:	2326      	movs	r3, #38	; 0x26
c0d00d4e:	4628      	mov	r0, r5
c0d00d50:	4622      	mov	r2, r4
c0d00d52:	f003 fd79 	bl	c0d04848 <cx_hash>
void monero_ecdhHash(unsigned char *x, unsigned char *k) {
  unsigned char data[38];
  os_memmove(data, "amount", 6);
  os_memmove(data + 6, k, 32);
  monero_keccak_F(data, 38, x);
}
c0d00d56:	b00d      	add	sp, #52	; 0x34
c0d00d58:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00d5a:	46c0      	nop			; (mov r8, r8)
c0d00d5c:	20001930 	.word	0x20001930
c0d00d60:	00008001 	.word	0x00008001
c0d00d64:	00005cd9 	.word	0x00005cd9

c0d00d68 <monero_genCommitmentMask>:
        key scalar;
        hash_to_scalar(scalar, data, sizeof(data));
        return scalar;
    }
*/
void monero_genCommitmentMask(unsigned char *c,  unsigned char *sk) {
c0d00d68:	b570      	push	{r4, r5, r6, lr}
c0d00d6a:	b08c      	sub	sp, #48	; 0x30
c0d00d6c:	460e      	mov	r6, r1
c0d00d6e:	4604      	mov	r4, r0
c0d00d70:	466d      	mov	r5, sp
    unsigned char data[15 + 32];
    os_memmove(data, "commitment_mask", 15);
c0d00d72:	4909      	ldr	r1, [pc, #36]	; (c0d00d98 <monero_genCommitmentMask+0x30>)
c0d00d74:	4479      	add	r1, pc
c0d00d76:	220f      	movs	r2, #15
c0d00d78:	4628      	mov	r0, r5
c0d00d7a:	f002 fe08 	bl	c0d0398e <os_memmove>
    os_memmove(data + 15, sk, 32);
c0d00d7e:	4628      	mov	r0, r5
c0d00d80:	300f      	adds	r0, #15
c0d00d82:	2220      	movs	r2, #32
c0d00d84:	4631      	mov	r1, r6
c0d00d86:	f002 fe02 	bl	c0d0398e <os_memmove>
c0d00d8a:	222f      	movs	r2, #47	; 0x2f
    monero_hash_to_scalar(c, data, 15+32);
c0d00d8c:	4620      	mov	r0, r4
c0d00d8e:	4629      	mov	r1, r5
c0d00d90:	f7ff fad6 	bl	c0d00340 <monero_hash_to_scalar>
}
c0d00d94:	b00c      	add	sp, #48	; 0x30
c0d00d96:	bd70      	pop	{r4, r5, r6, pc}
c0d00d98:	00005c84 	.word	0x00005c84

c0d00d9c <monero_subm>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_subm(unsigned char *r, unsigned char *a, unsigned char *b) {
c0d00d9c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00d9e:	b091      	sub	sp, #68	; 0x44
c0d00da0:	4604      	mov	r4, r0
c0d00da2:	2000      	movs	r0, #0
c0d00da4:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00da6:	5c0d      	ldrb	r5, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00da8:	5cce      	ldrb	r6, [r1, r3]
c0d00daa:	af09      	add	r7, sp, #36	; 0x24
c0d00dac:	543e      	strb	r6, [r7, r0]
        rscal[31-i] = x;
c0d00dae:	54fd      	strb	r5, [r7, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00db0:	1e5b      	subs	r3, r3, #1
c0d00db2:	1c40      	adds	r0, r0, #1
c0d00db4:	2810      	cmp	r0, #16
c0d00db6:	d1f6      	bne.n	c0d00da6 <monero_subm+0xa>
c0d00db8:	2000      	movs	r0, #0
c0d00dba:	211f      	movs	r1, #31
        x           = scal[i];
c0d00dbc:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00dbe:	5c55      	ldrb	r5, [r2, r1]
c0d00dc0:	ae01      	add	r6, sp, #4
c0d00dc2:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00dc4:	5473      	strb	r3, [r6, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00dc6:	1e49      	subs	r1, r1, #1
c0d00dc8:	1c40      	adds	r0, r0, #1
c0d00dca:	2810      	cmp	r0, #16
c0d00dcc:	d1f6      	bne.n	c0d00dbc <monero_subm+0x20>
c0d00dce:	2020      	movs	r0, #32
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_subm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00dd0:	4669      	mov	r1, sp
c0d00dd2:	6008      	str	r0, [r1, #0]
c0d00dd4:	a909      	add	r1, sp, #36	; 0x24
c0d00dd6:	aa01      	add	r2, sp, #4
c0d00dd8:	4b08      	ldr	r3, [pc, #32]	; (c0d00dfc <monero_subm+0x60>)
c0d00dda:	447b      	add	r3, pc
c0d00ddc:	4620      	mov	r0, r4
c0d00dde:	f003 fe25 	bl	c0d04a2c <cx_math_subm>
c0d00de2:	2000      	movs	r0, #0
c0d00de4:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00de6:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d00de8:	5c63      	ldrb	r3, [r4, r1]
c0d00dea:	5423      	strb	r3, [r4, r0]
        rscal[31-i] = x;
c0d00dec:	5462      	strb	r2, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00dee:	1e49      	subs	r1, r1, #1
c0d00df0:	1c40      	adds	r0, r0, #1
c0d00df2:	290f      	cmp	r1, #15
c0d00df4:	d1f7      	bne.n	c0d00de6 <monero_subm+0x4a>

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_subm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d00df6:	b011      	add	sp, #68	; 0x44
c0d00df8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00dfa:	46c0      	nop			; (mov r8, r8)
c0d00dfc:	00005a6e 	.word	0x00005a6e

c0d00e00 <monero_multm>:
/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_multm(unsigned char *r, unsigned char *a, unsigned char *b) {
c0d00e00:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00e02:	b091      	sub	sp, #68	; 0x44
c0d00e04:	4604      	mov	r4, r0
c0d00e06:	2000      	movs	r0, #0
c0d00e08:	231f      	movs	r3, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00e0a:	5c0d      	ldrb	r5, [r1, r0]
        rscal[i]    = scal [31-i];
c0d00e0c:	5cce      	ldrb	r6, [r1, r3]
c0d00e0e:	af09      	add	r7, sp, #36	; 0x24
c0d00e10:	543e      	strb	r6, [r7, r0]
        rscal[31-i] = x;
c0d00e12:	54fd      	strb	r5, [r7, r3]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00e14:	1e5b      	subs	r3, r3, #1
c0d00e16:	1c40      	adds	r0, r0, #1
c0d00e18:	2810      	cmp	r0, #16
c0d00e1a:	d1f6      	bne.n	c0d00e0a <monero_multm+0xa>
c0d00e1c:	2000      	movs	r0, #0
c0d00e1e:	211f      	movs	r1, #31
        x           = scal[i];
c0d00e20:	5c13      	ldrb	r3, [r2, r0]
        rscal[i]    = scal [31-i];
c0d00e22:	5c55      	ldrb	r5, [r2, r1]
c0d00e24:	ae01      	add	r6, sp, #4
c0d00e26:	5435      	strb	r5, [r6, r0]
        rscal[31-i] = x;
c0d00e28:	5473      	strb	r3, [r6, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00e2a:	1e49      	subs	r1, r1, #1
c0d00e2c:	1c40      	adds	r0, r0, #1
c0d00e2e:	2810      	cmp	r0, #16
c0d00e30:	d1f6      	bne.n	c0d00e20 <monero_multm+0x20>
c0d00e32:	2020      	movs	r0, #32
    unsigned char ra[32];
    unsigned char rb[32];

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
c0d00e34:	4669      	mov	r1, sp
c0d00e36:	6008      	str	r0, [r1, #0]
c0d00e38:	a909      	add	r1, sp, #36	; 0x24
c0d00e3a:	aa01      	add	r2, sp, #4
c0d00e3c:	4b08      	ldr	r3, [pc, #32]	; (c0d00e60 <monero_multm+0x60>)
c0d00e3e:	447b      	add	r3, pc
c0d00e40:	4620      	mov	r0, r4
c0d00e42:	f003 fe0b 	bl	c0d04a5c <cx_math_multm>
c0d00e46:	2000      	movs	r0, #0
c0d00e48:	211f      	movs	r1, #31
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
        x           = scal[i];
c0d00e4a:	5c22      	ldrb	r2, [r4, r0]
        rscal[i]    = scal [31-i];
c0d00e4c:	5c63      	ldrb	r3, [r4, r1]
c0d00e4e:	5423      	strb	r3, [r4, r0]
        rscal[31-i] = x;
c0d00e50:	5462      	strb	r2, [r4, r1]
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reverse32(unsigned char *rscal, unsigned char *scal) {
    unsigned char x;
    unsigned int i;
    for (i = 0; i<16; i++) {
c0d00e52:	1e49      	subs	r1, r1, #1
c0d00e54:	1c40      	adds	r0, r0, #1
c0d00e56:	290f      	cmp	r1, #15
c0d00e58:	d1f7      	bne.n	c0d00e4a <monero_multm+0x4a>

    monero_reverse32(ra,a);
    monero_reverse32(rb,b);
    cx_math_multm(r, ra,  rb, (unsigned char *)C_ED25519_ORDER, 32);
    monero_reverse32(r,r);
}
c0d00e5a:	b011      	add	sp, #68	; 0x44
c0d00e5c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d00e5e:	46c0      	nop			; (mov r8, r8)
c0d00e60:	00005a0a 	.word	0x00005a0a

c0d00e64 <monero_amount2str>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/* return 0 if ok, 1 if missing decimal */
int monero_amount2str(uint64_t xmr,  char *str, unsigned int str_len) {
c0d00e64:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00e66:	b08f      	sub	sp, #60	; 0x3c
c0d00e68:	9108      	str	r1, [sp, #32]
c0d00e6a:	4605      	mov	r5, r0
c0d00e6c:	2400      	movs	r4, #0
c0d00e6e:	9202      	str	r2, [sp, #8]
    //max uint64 is 18446744073709551616, aka 20 char, plus dot
    char stramount[22];
    unsigned int offset,len,ov;

    os_memset(str,0,str_len);
c0d00e70:	4610      	mov	r0, r2
c0d00e72:	4621      	mov	r1, r4
c0d00e74:	9301      	str	r3, [sp, #4]
c0d00e76:	461a      	mov	r2, r3
c0d00e78:	f002 fd80 	bl	c0d0397c <os_memset>
c0d00e7c:	af09      	add	r7, sp, #36	; 0x24
c0d00e7e:	2130      	movs	r1, #48	; 0x30
c0d00e80:	2616      	movs	r6, #22

    os_memset(stramount,'0',sizeof(stramount));
c0d00e82:	4638      	mov	r0, r7
c0d00e84:	9104      	str	r1, [sp, #16]
c0d00e86:	4632      	mov	r2, r6
c0d00e88:	f002 fd78 	bl	c0d0397c <os_memset>
c0d00e8c:	9908      	ldr	r1, [sp, #32]
c0d00e8e:	9405      	str	r4, [sp, #20]
    stramount[21] = 0;
c0d00e90:	757c      	strb	r4, [r7, #21]
    //special case
    if (xmr == 0) {
c0d00e92:	4628      	mov	r0, r5
c0d00e94:	4308      	orrs	r0, r1
c0d00e96:	2800      	cmp	r0, #0
c0d00e98:	d051      	beq.n	c0d00f3e <monero_amount2str+0xda>
c0d00e9a:	ac09      	add	r4, sp, #36	; 0x24
    // value:  0 | xmrunits | 0

    offset = 20;
    while (xmr) {
        stramount[offset] = '0' + xmr % 10;
        xmr = xmr / 10;
c0d00e9c:	3414      	adds	r4, #20
c0d00e9e:	43f6      	mvns	r6, r6
c0d00ea0:	9603      	str	r6, [sp, #12]
c0d00ea2:	260a      	movs	r6, #10
c0d00ea4:	4628      	mov	r0, r5
c0d00ea6:	9108      	str	r1, [sp, #32]
c0d00ea8:	4632      	mov	r2, r6
c0d00eaa:	9f05      	ldr	r7, [sp, #20]
c0d00eac:	463b      	mov	r3, r7
c0d00eae:	f005 fa7b 	bl	c0d063a8 <__aeabi_uldivmod>
c0d00eb2:	9007      	str	r0, [sp, #28]
c0d00eb4:	9106      	str	r1, [sp, #24]
c0d00eb6:	4632      	mov	r2, r6
c0d00eb8:	9e03      	ldr	r6, [sp, #12]
c0d00eba:	463b      	mov	r3, r7
c0d00ebc:	f005 fa94 	bl	c0d063e8 <__aeabi_lmul>
c0d00ec0:	1a28      	subs	r0, r5, r0
    // ----------------------
    // value:  0 | xmrunits | 0

    offset = 20;
    while (xmr) {
        stramount[offset] = '0' + xmr % 10;
c0d00ec2:	9904      	ldr	r1, [sp, #16]
c0d00ec4:	4308      	orrs	r0, r1
c0d00ec6:	7020      	strb	r0, [r4, #0]
c0d00ec8:	19a4      	adds	r4, r4, r6
    // offset: 0 | 1-20     | 21
    // ----------------------
    // value:  0 | xmrunits | 0

    offset = 20;
    while (xmr) {
c0d00eca:	3416      	adds	r4, #22
c0d00ecc:	2009      	movs	r0, #9
c0d00ece:	1b40      	subs	r0, r0, r5
c0d00ed0:	9908      	ldr	r1, [sp, #32]
c0d00ed2:	418f      	sbcs	r7, r1
c0d00ed4:	9d07      	ldr	r5, [sp, #28]
c0d00ed6:	9906      	ldr	r1, [sp, #24]
c0d00ed8:	d3e3      	bcc.n	c0d00ea2 <monero_amount2str+0x3e>
c0d00eda:	ac09      	add	r4, sp, #36	; 0x24
        offset--;
    }
    // offset: 0-7 | 8 | 9-20 |21
    // ----------------------
    // value:  xmr | . | units| 0
    os_memmove(stramount, stramount+1, 8);
c0d00edc:	1c61      	adds	r1, r4, #1
c0d00ede:	2208      	movs	r2, #8
c0d00ee0:	4620      	mov	r0, r4
c0d00ee2:	f002 fd54 	bl	c0d0398e <os_memmove>
c0d00ee6:	202e      	movs	r0, #46	; 0x2e
    stramount[8] = '.';
c0d00ee8:	7220      	strb	r0, [r4, #8]
c0d00eea:	4630      	mov	r0, r6
c0d00eec:	a909      	add	r1, sp, #36	; 0x24
    offset = 0;
    while((stramount[offset]=='0') && (stramount[offset] != '.')) {
c0d00eee:	1809      	adds	r1, r1, r0
c0d00ef0:	7dca      	ldrb	r2, [r1, #23]
c0d00ef2:	1c40      	adds	r0, r0, #1
c0d00ef4:	2a30      	cmp	r2, #48	; 0x30
c0d00ef6:	d0f9      	beq.n	c0d00eec <monero_amount2str+0x88>
c0d00ef8:	9b05      	ldr	r3, [sp, #20]
c0d00efa:	43d9      	mvns	r1, r3
        offset++;
    }
    if (stramount[offset] == '.') {
c0d00efc:	2a2e      	cmp	r2, #46	; 0x2e
c0d00efe:	d000      	beq.n	c0d00f02 <monero_amount2str+0x9e>
c0d00f00:	4619      	mov	r1, r3
        offset--;
    }
    len = 20;
    while((stramount[len]=='0') && (stramount[len] != '.')) {
c0d00f02:	424a      	negs	r2, r1
c0d00f04:	1a14      	subs	r4, r2, r0
c0d00f06:	aa09      	add	r2, sp, #36	; 0x24
c0d00f08:	3214      	adds	r2, #20
c0d00f0a:	1993      	adds	r3, r2, r6
c0d00f0c:	3316      	adds	r3, #22
c0d00f0e:	1e64      	subs	r4, r4, #1
c0d00f10:	7812      	ldrb	r2, [r2, #0]
c0d00f12:	2a30      	cmp	r2, #48	; 0x30
c0d00f14:	461a      	mov	r2, r3
c0d00f16:	d0f8      	beq.n	c0d00f0a <monero_amount2str+0xa6>
        len--;
    }
    len = len-offset+1;
    ov = 0;
    if (len>(str_len-1)) {
c0d00f18:	9a01      	ldr	r2, [sp, #4]
c0d00f1a:	1e55      	subs	r5, r2, #1
c0d00f1c:	42ac      	cmp	r4, r5
c0d00f1e:	462a      	mov	r2, r5
c0d00f20:	d800      	bhi.n	c0d00f24 <monero_amount2str+0xc0>
c0d00f22:	4622      	mov	r2, r4
c0d00f24:	ab09      	add	r3, sp, #36	; 0x24
        len = str_len-1;
        ov = 1;
    }
    os_memmove(str, stramount+offset, len);
c0d00f26:	1859      	adds	r1, r3, r1
c0d00f28:	1809      	adds	r1, r1, r0
c0d00f2a:	3116      	adds	r1, #22
c0d00f2c:	9802      	ldr	r0, [sp, #8]
c0d00f2e:	f002 fd2e 	bl	c0d0398e <os_memmove>
c0d00f32:	2001      	movs	r0, #1
c0d00f34:	2100      	movs	r1, #0
    while((stramount[len]=='0') && (stramount[len] != '.')) {
        len--;
    }
    len = len-offset+1;
    ov = 0;
    if (len>(str_len-1)) {
c0d00f36:	42ac      	cmp	r4, r5
c0d00f38:	d805      	bhi.n	c0d00f46 <monero_amount2str+0xe2>
c0d00f3a:	4608      	mov	r0, r1
c0d00f3c:	e003      	b.n	c0d00f46 <monero_amount2str+0xe2>

    os_memset(stramount,'0',sizeof(stramount));
    stramount[21] = 0;
    //special case
    if (xmr == 0) {
        str[0] = '0';
c0d00f3e:	9804      	ldr	r0, [sp, #16]
c0d00f40:	9902      	ldr	r1, [sp, #8]
c0d00f42:	7008      	strb	r0, [r1, #0]
c0d00f44:	2001      	movs	r0, #1
        len = str_len-1;
        ov = 1;
    }
    os_memmove(str, stramount+offset, len);
    return ov;
}
c0d00f46:	b00f      	add	sp, #60	; 0x3c
c0d00f48:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00f4a <monero_bamount2uint64>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
uint64_t monero_bamount2uint64(unsigned char *binary) {
c0d00f4a:	b5b0      	push	{r4, r5, r7, lr}
c0d00f4c:	2400      	movs	r4, #0
c0d00f4e:	2307      	movs	r3, #7
c0d00f50:	4621      	mov	r1, r4
    uint64_t xmr;
    int i;
    xmr = 0;
    for (i=7; i>=0; i--) {
        xmr = xmr*256 + binary[i];
c0d00f52:	5cc2      	ldrb	r2, [r0, r3]
c0d00f54:	0225      	lsls	r5, r4, #8
c0d00f56:	18aa      	adds	r2, r5, r2
c0d00f58:	0e24      	lsrs	r4, r4, #24
c0d00f5a:	0209      	lsls	r1, r1, #8
c0d00f5c:	1909      	adds	r1, r1, r4
/* ----------------------------------------------------------------------- */
uint64_t monero_bamount2uint64(unsigned char *binary) {
    uint64_t xmr;
    int i;
    xmr = 0;
    for (i=7; i>=0; i--) {
c0d00f5e:	1e5c      	subs	r4, r3, #1
c0d00f60:	2b00      	cmp	r3, #0
c0d00f62:	4623      	mov	r3, r4
c0d00f64:	4614      	mov	r4, r2
c0d00f66:	d1f4      	bne.n	c0d00f52 <monero_bamount2uint64+0x8>
        xmr = xmr*256 + binary[i];
    }
    return xmr;
c0d00f68:	4610      	mov	r0, r2
c0d00f6a:	bdb0      	pop	{r4, r5, r7, pc}

c0d00f6c <monero_vamount2uint64>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
uint64_t monero_vamount2uint64(unsigned char *binary) {
c0d00f6c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d00f6e:	b081      	sub	sp, #4
c0d00f70:	4601      	mov	r1, r0
    uint64_t xmr,x;
   int shift = 0;
   xmr = 0;
   while((*binary)&0x80) {
c0d00f72:	7800      	ldrb	r0, [r0, #0]
c0d00f74:	0602      	lsls	r2, r0, #24
c0d00f76:	2600      	movs	r6, #0
c0d00f78:	2a00      	cmp	r2, #0
c0d00f7a:	d402      	bmi.n	c0d00f82 <monero_vamount2uint64+0x16>
c0d00f7c:	4637      	mov	r7, r6
c0d00f7e:	4634      	mov	r4, r6
c0d00f80:	e014      	b.n	c0d00fac <monero_vamount2uint64+0x40>
       if ( (unsigned int)shift > (8*sizeof(unsigned long long int)-7)) {
c0d00f82:	1c4d      	adds	r5, r1, #1
c0d00f84:	2700      	movs	r7, #0
c0d00f86:	463c      	mov	r4, r7
c0d00f88:	463e      	mov	r6, r7
c0d00f8a:	9700      	str	r7, [sp, #0]
c0d00f8c:	2c39      	cmp	r4, #57	; 0x39
c0d00f8e:	d817      	bhi.n	c0d00fc0 <monero_vamount2uint64+0x54>
c0d00f90:	217f      	movs	r1, #127	; 0x7f
        return 0;
       }
       x = *(binary)&0x7f;
c0d00f92:	4008      	ands	r0, r1
c0d00f94:	2100      	movs	r1, #0
       xmr = xmr + (x<<shift);
c0d00f96:	4622      	mov	r2, r4
c0d00f98:	f005 f9fa 	bl	c0d06390 <__aeabi_llsl>
c0d00f9c:	1986      	adds	r6, r0, r6
c0d00f9e:	414f      	adcs	r7, r1
/* ----------------------------------------------------------------------- */
uint64_t monero_vamount2uint64(unsigned char *binary) {
    uint64_t xmr,x;
   int shift = 0;
   xmr = 0;
   while((*binary)&0x80) {
c0d00fa0:	1c69      	adds	r1, r5, #1
        return 0;
       }
       x = *(binary)&0x7f;
       xmr = xmr + (x<<shift);
       binary++;
       shift += 7;
c0d00fa2:	1de4      	adds	r4, r4, #7
/* ----------------------------------------------------------------------- */
uint64_t monero_vamount2uint64(unsigned char *binary) {
    uint64_t xmr,x;
   int shift = 0;
   xmr = 0;
   while((*binary)&0x80) {
c0d00fa4:	7828      	ldrb	r0, [r5, #0]
c0d00fa6:	0602      	lsls	r2, r0, #24
c0d00fa8:	460d      	mov	r5, r1
c0d00faa:	d4ef      	bmi.n	c0d00f8c <monero_vamount2uint64+0x20>
c0d00fac:	227f      	movs	r2, #127	; 0x7f
       x = *(binary)&0x7f;
       xmr = xmr + (x<<shift);
       binary++;
       shift += 7;
   }
   x = *(binary)&0x7f;
c0d00fae:	4002      	ands	r2, r0
c0d00fb0:	2100      	movs	r1, #0
   xmr = xmr + (x<<shift);
c0d00fb2:	4610      	mov	r0, r2
c0d00fb4:	4622      	mov	r2, r4
c0d00fb6:	f005 f9eb 	bl	c0d06390 <__aeabi_llsl>
c0d00fba:	1980      	adds	r0, r0, r6
c0d00fbc:	4179      	adcs	r1, r7
c0d00fbe:	e001      	b.n	c0d00fc4 <monero_vamount2uint64+0x58>
c0d00fc0:	9800      	ldr	r0, [sp, #0]
c0d00fc2:	4601      	mov	r1, r0
   return xmr;
}
c0d00fc4:	b001      	add	sp, #4
c0d00fc6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d00fc8 <monero_vamount2str>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_vamount2str(unsigned char *binary,  char *str, unsigned int str_len) {
c0d00fc8:	b5b0      	push	{r4, r5, r7, lr}
c0d00fca:	4614      	mov	r4, r2
c0d00fcc:	460d      	mov	r5, r1
   return monero_amount2str(monero_vamount2uint64(binary), str,str_len);
c0d00fce:	f7ff ffcd 	bl	c0d00f6c <monero_vamount2uint64>
c0d00fd2:	462a      	mov	r2, r5
c0d00fd4:	4623      	mov	r3, r4
c0d00fd6:	f7ff ff45 	bl	c0d00e64 <monero_amount2str>
c0d00fda:	bdb0      	pop	{r4, r5, r7, pc}

c0d00fdc <check_potocol>:
#include "monero_api.h"
#include "monero_vars.h"



void check_potocol()  {
c0d00fdc:	b580      	push	{r7, lr}
  /* the first command enforce the protocol version until application quits */
  switch(G_monero_vstate.io_protocol_version) {
c0d00fde:	4909      	ldr	r1, [pc, #36]	; (c0d01004 <check_potocol+0x28>)
c0d00fe0:	7888      	ldrb	r0, [r1, #2]
c0d00fe2:	2202      	movs	r2, #2
c0d00fe4:	4302      	orrs	r2, r0
c0d00fe6:	2a02      	cmp	r2, #2
c0d00fe8:	d107      	bne.n	c0d00ffa <check_potocol+0x1e>
   case 0x00: /* the first one: PCSC epoch */
   case 0x02: /* protocol V2 */
    if (G_monero_vstate.protocol == 0xff) {
c0d00fea:	784a      	ldrb	r2, [r1, #1]
c0d00fec:	2aff      	cmp	r2, #255	; 0xff
c0d00fee:	d002      	beq.n	c0d00ff6 <check_potocol+0x1a>
      G_monero_vstate.protocol = G_monero_vstate.io_protocol_version;
    }
    if (G_monero_vstate.protocol == G_monero_vstate.io_protocol_version) {
c0d00ff0:	4282      	cmp	r2, r0
c0d00ff2:	d102      	bne.n	c0d00ffa <check_potocol+0x1e>

   default:
    THROW(SW_CLA_NOT_SUPPORTED);
    return ;
  }
}
c0d00ff4:	bd80      	pop	{r7, pc}
  /* the first command enforce the protocol version until application quits */
  switch(G_monero_vstate.io_protocol_version) {
   case 0x00: /* the first one: PCSC epoch */
   case 0x02: /* protocol V2 */
    if (G_monero_vstate.protocol == 0xff) {
      G_monero_vstate.protocol = G_monero_vstate.io_protocol_version;
c0d00ff6:	7048      	strb	r0, [r1, #1]

   default:
    THROW(SW_CLA_NOT_SUPPORTED);
    return ;
  }
}
c0d00ff8:	bd80      	pop	{r7, pc}
c0d00ffa:	2037      	movs	r0, #55	; 0x37
c0d00ffc:	0240      	lsls	r0, r0, #9
    }
    //unknown protocol or hot protocol switch is not allowed
    //FALL THROUGH

   default:
    THROW(SW_CLA_NOT_SUPPORTED);
c0d00ffe:	f002 fd95 	bl	c0d03b2c <os_longjmp>
c0d01002:	46c0      	nop			; (mov r8, r8)
c0d01004:	20001930 	.word	0x20001930

c0d01008 <check_ins_access>:
    return ;
  }
}

void check_ins_access() {
c0d01008:	b5b0      	push	{r4, r5, r7, lr}
c0d0100a:	203d      	movs	r0, #61	; 0x3d
c0d0100c:	00c4      	lsls	r4, r0, #3

  if (G_monero_vstate.key_set != 1) {
c0d0100e:	4d1f      	ldr	r5, [pc, #124]	; (c0d0108c <check_ins_access+0x84>)
c0d01010:	5d28      	ldrb	r0, [r5, r4]
c0d01012:	07c0      	lsls	r0, r0, #31
c0d01014:	d036      	beq.n	c0d01084 <check_ins_access+0x7c>
    THROW(SW_CONDITIONS_NOT_SATISFIED);
    return;
  }

  switch (G_monero_vstate.io_ins) {
c0d01016:	78e8      	ldrb	r0, [r5, #3]
c0d01018:	283f      	cmp	r0, #63	; 0x3f
c0d0101a:	dd11      	ble.n	c0d01040 <check_ins_access+0x38>
c0d0101c:	4602      	mov	r2, r0
c0d0101e:	3a70      	subs	r2, #112	; 0x70
c0d01020:	2a10      	cmp	r2, #16
c0d01022:	d826      	bhi.n	c0d01072 <check_ins_access+0x6a>
c0d01024:	2101      	movs	r1, #1
c0d01026:	4091      	lsls	r1, r2
c0d01028:	4a1b      	ldr	r2, [pc, #108]	; (c0d01098 <check_ins_access+0x90>)
c0d0102a:	4211      	tst	r1, r2
c0d0102c:	d014      	beq.n	c0d01058 <check_ins_access+0x50>
  case INS_GEN_TXOUT_KEYS:
  case INS_BLIND:
  case INS_VALIDATE:
  case INS_MLSAG:
  case INS_GEN_COMMITMENT_MASK:
    if ((os_global_pin_is_validated() != PIN_VERIFIED) ||
c0d0102e:	f003 fd8b 	bl	c0d04b48 <os_global_pin_is_validated>
c0d01032:	491a      	ldr	r1, [pc, #104]	; (c0d0109c <check_ins_access+0x94>)
c0d01034:	4288      	cmp	r0, r1
c0d01036:	d125      	bne.n	c0d01084 <check_ins_access+0x7c>
        (G_monero_vstate.tx_in_progress != 1)) {
c0d01038:	5d28      	ldrb	r0, [r5, r4]
  case INS_GEN_TXOUT_KEYS:
  case INS_BLIND:
  case INS_VALIDATE:
  case INS_MLSAG:
  case INS_GEN_COMMITMENT_MASK:
    if ((os_global_pin_is_validated() != PIN_VERIFIED) ||
c0d0103a:	0780      	lsls	r0, r0, #30
c0d0103c:	d421      	bmi.n	c0d01082 <check_ins_access+0x7a>
c0d0103e:	e021      	b.n	c0d01084 <check_ins_access+0x7c>
c0d01040:	4601      	mov	r1, r0
c0d01042:	3920      	subs	r1, #32
c0d01044:	291e      	cmp	r1, #30
c0d01046:	d804      	bhi.n	c0d01052 <check_ins_access+0x4a>
c0d01048:	2201      	movs	r2, #1
c0d0104a:	408a      	lsls	r2, r1
c0d0104c:	4910      	ldr	r1, [pc, #64]	; (c0d01090 <check_ins_access+0x88>)
c0d0104e:	420a      	tst	r2, r1
c0d01050:	d117      	bne.n	c0d01082 <check_ins_access+0x7a>
  if (G_monero_vstate.key_set != 1) {
    THROW(SW_CONDITIONS_NOT_SATISFIED);
    return;
  }

  switch (G_monero_vstate.io_ins) {
c0d01052:	2802      	cmp	r0, #2
c0d01054:	d015      	beq.n	c0d01082 <check_ins_access+0x7a>
c0d01056:	e015      	b.n	c0d01084 <check_ins_access+0x7c>
c0d01058:	2205      	movs	r2, #5
c0d0105a:	4211      	tst	r1, r2
c0d0105c:	d005      	beq.n	c0d0106a <check_ins_access+0x62>
  case INS_STEALTH:
    return;

  case INS_OPEN_TX:
  case INS_SET_SIGNATURE_MODE:
    if (os_global_pin_is_validated() != PIN_VERIFIED) {
c0d0105e:	f003 fd73 	bl	c0d04b48 <os_global_pin_is_validated>
c0d01062:	490e      	ldr	r1, [pc, #56]	; (c0d0109c <check_ins_access+0x94>)
c0d01064:	4288      	cmp	r0, r1
c0d01066:	d00c      	beq.n	c0d01082 <check_ins_access+0x7a>
c0d01068:	e00c      	b.n	c0d01084 <check_ins_access+0x7c>
c0d0106a:	2211      	movs	r2, #17
c0d0106c:	0192      	lsls	r2, r2, #6
c0d0106e:	4211      	tst	r1, r2
c0d01070:	d107      	bne.n	c0d01082 <check_ins_access+0x7a>
c0d01072:	3840      	subs	r0, #64	; 0x40
c0d01074:	280c      	cmp	r0, #12
c0d01076:	d805      	bhi.n	c0d01084 <check_ins_access+0x7c>
c0d01078:	2101      	movs	r1, #1
c0d0107a:	4081      	lsls	r1, r0
c0d0107c:	4805      	ldr	r0, [pc, #20]	; (c0d01094 <check_ins_access+0x8c>)
c0d0107e:	4201      	tst	r1, r0
c0d01080:	d000      	beq.n	c0d01084 <check_ins_access+0x7c>
  }

  THROW(SW_CONDITIONS_NOT_SATISFIED);
  return;

}
c0d01082:	bdb0      	pop	{r4, r5, r7, pc}
c0d01084:	4806      	ldr	r0, [pc, #24]	; (c0d010a0 <check_ins_access+0x98>)
c0d01086:	f002 fd51 	bl	c0d03b2c <os_longjmp>
c0d0108a:	46c0      	nop			; (mov r8, r8)
c0d0108c:	20001930 	.word	0x20001930
c0d01090:	55550155 	.word	0x55550155
c0d01094:	00001555 	.word	0x00001555
c0d01098:	00015980 	.word	0x00015980
c0d0109c:	b0105011 	.word	0xb0105011
c0d010a0:	00006985 	.word	0x00006985

c0d010a4 <monero_dispatch>:

int monero_dispatch() {
c0d010a4:	b510      	push	{r4, lr}

  int sw;

  check_potocol();
c0d010a6:	f7ff ff99 	bl	c0d00fdc <check_potocol>
  check_ins_access();
c0d010aa:	f7ff ffad 	bl	c0d01008 <check_ins_access>
c0d010ae:	204f      	movs	r0, #79	; 0x4f
c0d010b0:	0084      	lsls	r4, r0, #2

  G_monero_vstate.options = monero_io_fetch_u8();
c0d010b2:	f000 faf9 	bl	c0d016a8 <monero_io_fetch_u8>
c0d010b6:	497a      	ldr	r1, [pc, #488]	; (c0d012a0 <monero_dispatch+0x1fc>)
c0d010b8:	5108      	str	r0, [r1, r4]

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010ba:	78c8      	ldrb	r0, [r1, #3]
c0d010bc:	2841      	cmp	r0, #65	; 0x41
c0d010be:	dd0b      	ble.n	c0d010d8 <monero_dispatch+0x34>
c0d010c0:	2875      	cmp	r0, #117	; 0x75
c0d010c2:	dc15      	bgt.n	c0d010f0 <monero_dispatch+0x4c>
c0d010c4:	2849      	cmp	r0, #73	; 0x49
c0d010c6:	dc2b      	bgt.n	c0d01120 <monero_dispatch+0x7c>
c0d010c8:	2845      	cmp	r0, #69	; 0x45
c0d010ca:	dc4b      	bgt.n	c0d01164 <monero_dispatch+0xc0>
c0d010cc:	2842      	cmp	r0, #66	; 0x42
c0d010ce:	d000      	beq.n	c0d010d2 <monero_dispatch+0x2e>
c0d010d0:	e08f      	b.n	c0d011f2 <monero_dispatch+0x14e>
    break;
  case INS_GENERATE_KEYPAIR:
    sw = monero_apdu_generate_keypair();
    break;
  case INS_SECRET_SCAL_MUL_KEY:
    sw = monero_apdu_scal_mul_key();
c0d010d2:	f000 fd97 	bl	c0d01c04 <monero_apdu_scal_mul_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d010d6:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010d8:	2831      	cmp	r0, #49	; 0x31
c0d010da:	dd18      	ble.n	c0d0110e <monero_dispatch+0x6a>
c0d010dc:	2839      	cmp	r0, #57	; 0x39
c0d010de:	dc2d      	bgt.n	c0d0113c <monero_dispatch+0x98>
c0d010e0:	2835      	cmp	r0, #53	; 0x35
c0d010e2:	dc5b      	bgt.n	c0d0119c <monero_dispatch+0xf8>
c0d010e4:	2832      	cmp	r0, #50	; 0x32
c0d010e6:	d000      	beq.n	c0d010ea <monero_dispatch+0x46>
c0d010e8:	e0b2      	b.n	c0d01250 <monero_dispatch+0x1ac>
    break;
  case INS_SECRET_KEY_TO_PUBLIC_KEY:
    sw = monero_apdu_secret_key_to_public_key();
    break;
  case INS_GEN_KEY_DERIVATION:
    sw = monero_apdu_generate_key_derivation();
c0d010ea:	f000 fdf1 	bl	c0d01cd0 <monero_apdu_generate_key_derivation>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d010ee:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d010f0:	287a      	cmp	r0, #122	; 0x7a
c0d010f2:	dc1c      	bgt.n	c0d0112e <monero_dispatch+0x8a>
c0d010f4:	2877      	cmp	r0, #119	; 0x77
c0d010f6:	dc3a      	bgt.n	c0d0116e <monero_dispatch+0xca>
c0d010f8:	2876      	cmp	r0, #118	; 0x76
c0d010fa:	d17f      	bne.n	c0d011fc <monero_dispatch+0x158>
    sw = monero_apdu_set_signature_mode();
    break;

    /* --- STEATH PAYMENT --- */
  case INS_STEALTH:
    if ((G_monero_vstate.io_p1 != 0) ||
c0d010fc:	7908      	ldrb	r0, [r1, #4]
        (G_monero_vstate.io_p2 != 0)) {
c0d010fe:	7949      	ldrb	r1, [r1, #5]
    sw = monero_apdu_set_signature_mode();
    break;

    /* --- STEATH PAYMENT --- */
  case INS_STEALTH:
    if ((G_monero_vstate.io_p1 != 0) ||
c0d01100:	4301      	orrs	r1, r0
c0d01102:	2900      	cmp	r1, #0
c0d01104:	d000      	beq.n	c0d01108 <monero_dispatch+0x64>
c0d01106:	e0c7      	b.n	c0d01298 <monero_dispatch+0x1f4>
        (G_monero_vstate.io_p2 != 0)) {
      THROW(SW_WRONG_P1P2);
    }
    sw = monero_apdu_stealth();
c0d01108:	f001 ff40 	bl	c0d02f8c <monero_apdu_stealth>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0110c:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0110e:	2823      	cmp	r0, #35	; 0x23
c0d01110:	dd1c      	ble.n	c0d0114c <monero_dispatch+0xa8>
c0d01112:	2827      	cmp	r0, #39	; 0x27
c0d01114:	dc21      	bgt.n	c0d0115a <monero_dispatch+0xb6>
c0d01116:	2824      	cmp	r0, #36	; 0x24
c0d01118:	d15c      	bne.n	c0d011d4 <monero_dispatch+0x130>
   /* --- PROVISIONING--- */
  case INS_VERIFY_KEY:
    sw = monero_apdu_verify_key();
    break;
  case INS_GET_CHACHA8_PREKEY:
    sw = monero_apdu_get_chacha8_prekey();
c0d0111a:	f000 fd05 	bl	c0d01b28 <monero_apdu_get_chacha8_prekey>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0111e:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01120:	286f      	cmp	r0, #111	; 0x6f
c0d01122:	dc29      	bgt.n	c0d01178 <monero_dispatch+0xd4>
c0d01124:	284a      	cmp	r0, #74	; 0x4a
c0d01126:	d16e      	bne.n	c0d01206 <monero_dispatch+0x162>
    break;
  case INS_GET_SUBADDRESS:
    sw = monero_apdu_get_subaddress();
    break;
  case INS_GET_SUBADDRESS_SPEND_PUBLIC_KEY:
     sw = monero_apdu_get_subaddress_spend_public_key();
c0d01128:	f000 feac 	bl	c0d01e84 <monero_apdu_get_subaddress_spend_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0112c:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0112e:	287d      	cmp	r0, #125	; 0x7d
c0d01130:	dc27      	bgt.n	c0d01182 <monero_dispatch+0xde>
c0d01132:	287b      	cmp	r0, #123	; 0x7b
c0d01134:	d16c      	bne.n	c0d01210 <monero_dispatch+0x16c>
    sw = monero_apdu_get_subaddress_secret_key();
    break;

    /*--- TX OUT KEYS --- */
  case INS_GEN_TXOUT_KEYS:
    sw = monero_apu_generate_txout_keys();
c0d01136:	f000 fed9 	bl	c0d01eec <monero_apu_generate_txout_keys>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0113a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0113c:	283d      	cmp	r0, #61	; 0x3d
c0d0113e:	dc32      	bgt.n	c0d011a6 <monero_dispatch+0x102>
c0d01140:	283a      	cmp	r0, #58	; 0x3a
c0d01142:	d000      	beq.n	c0d01146 <monero_dispatch+0xa2>
c0d01144:	e089      	b.n	c0d0125a <monero_dispatch+0x1b6>
    break;
  case INS_DERIVE_SECRET_KEY:
    sw = monero_apdu_derive_secret_key();
    break;
  case INS_GEN_KEY_IMAGE:
    sw = monero_apdu_generate_key_image();
c0d01146:	f000 fe3f 	bl	c0d01dc8 <monero_apdu_generate_key_image>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0114a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0114c:	2802      	cmp	r0, #2
c0d0114e:	d02f      	beq.n	c0d011b0 <monero_dispatch+0x10c>
c0d01150:	2820      	cmp	r0, #32
c0d01152:	d144      	bne.n	c0d011de <monero_dispatch+0x13a>
   /* --- KEYS --- */
  case INS_PUT_KEY:
    sw = monero_apdu_put_key();
    break;
  case INS_GET_KEY:
    sw = monero_apdu_get_key();
c0d01154:	f000 fc7c 	bl	c0d01a50 <monero_apdu_get_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01158:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0115a:	2828      	cmp	r0, #40	; 0x28
c0d0115c:	d144      	bne.n	c0d011e8 <monero_dispatch+0x144>
    break;
  case INS_GET_KEY:
    sw = monero_apdu_get_key();
    break;
  case INS_MANAGE_SEEDWORDS:
    sw = monero_apdu_manage_seedwords();
c0d0115e:	f000 fb05 	bl	c0d0176c <monero_apdu_manage_seedwords>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01162:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01164:	2846      	cmp	r0, #70	; 0x46
c0d01166:	d15f      	bne.n	c0d01228 <monero_dispatch+0x184>
    sw = monero_apdu_scal_mul_base();
    break;

  /* --- ADRESSES --- */
  case INS_DERIVE_SUBADDRESS_PUBLIC_KEY:
    sw = monero_apdu_derive_subaddress_public_key();
c0d01168:	f000 fe4c 	bl	c0d01e04 <monero_apdu_derive_subaddress_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0116c:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0116e:	2878      	cmp	r0, #120	; 0x78
c0d01170:	d15f      	bne.n	c0d01232 <monero_dispatch+0x18e>
    sw = monero_apdu_gen_commitment_mask();
    break;

    /* --- BLIND --- */
  case INS_BLIND:
    sw = monero_apdu_blind();
c0d01172:	f7fe ff6f 	bl	c0d00054 <monero_apdu_blind>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01176:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01178:	2870      	cmp	r0, #112	; 0x70
c0d0117a:	d15f      	bne.n	c0d0123c <monero_dispatch+0x198>

  switch (G_monero_vstate.io_ins) {

    /* --- START TX --- */
  case INS_OPEN_TX:
    sw = monero_apdu_open_tx();
c0d0117c:	f001 fccc 	bl	c0d02b18 <monero_apdu_open_tx>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01180:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01182:	287e      	cmp	r0, #126	; 0x7e
c0d01184:	d15f      	bne.n	c0d01246 <monero_dispatch+0x1a2>
    }
    break;

  /* --- MLSAG --- */
  case INS_MLSAG:
    if (G_monero_vstate.io_p1 == 1) {
c0d01186:	7908      	ldrb	r0, [r1, #4]
c0d01188:	2803      	cmp	r0, #3
c0d0118a:	d078      	beq.n	c0d0127e <monero_dispatch+0x1da>
c0d0118c:	2802      	cmp	r0, #2
c0d0118e:	d073      	beq.n	c0d01278 <monero_dispatch+0x1d4>
c0d01190:	2801      	cmp	r0, #1
c0d01192:	d000      	beq.n	c0d01196 <monero_dispatch+0xf2>
c0d01194:	e080      	b.n	c0d01298 <monero_dispatch+0x1f4>
      sw = monero_apdu_mlsag_prepare();
c0d01196:	f001 faaf 	bl	c0d026f8 <monero_apdu_mlsag_prepare>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0119a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0119c:	2836      	cmp	r0, #54	; 0x36
c0d0119e:	d161      	bne.n	c0d01264 <monero_dispatch+0x1c0>
    break;
  case INS_DERIVATION_TO_SCALAR:
    sw = monero_apdu_derivation_to_scalar();
    break;
  case INS_DERIVE_PUBLIC_KEY:
    sw = monero_apdu_derive_public_key();
c0d011a0:	f000 fdcf 	bl	c0d01d42 <monero_apdu_derive_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011a4:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011a6:	283e      	cmp	r0, #62	; 0x3e
c0d011a8:	d161      	bne.n	c0d0126e <monero_dispatch+0x1ca>
    break;
  case INS_SECRET_KEY_ADD:
    sw = monero_apdu_sc_add();
    break;
  case INS_SECRET_KEY_SUB:
    sw = monero_apdu_sc_sub();
c0d011aa:	f000 fd0d 	bl	c0d01bc8 <monero_apdu_sc_sub>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011ae:	bd10      	pop	{r4, pc}
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
    monero_init();
c0d011b0:	f000 f878 	bl	c0d012a4 <monero_init>
c0d011b4:	2000      	movs	r0, #0
    monero_io_discard(0);
c0d011b6:	f000 f95d 	bl	c0d01474 <monero_io_discard>
c0d011ba:	2001      	movs	r0, #1
    monero_io_insert_u8(MONERO_VERSION_MAJOR);
c0d011bc:	f000 f9da 	bl	c0d01574 <monero_io_insert_u8>
c0d011c0:	2402      	movs	r4, #2
    monero_io_insert_u8(MONERO_VERSION_MINOR);
c0d011c2:	4620      	mov	r0, r4
c0d011c4:	f000 f9d6 	bl	c0d01574 <monero_io_insert_u8>
    monero_io_insert_u8(MONERO_VERSION_MICRO);
c0d011c8:	4620      	mov	r0, r4
c0d011ca:	f000 f9d3 	bl	c0d01574 <monero_io_insert_u8>
c0d011ce:	2009      	movs	r0, #9
c0d011d0:	0300      	lsls	r0, r0, #12
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011d2:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011d4:	2826      	cmp	r0, #38	; 0x26
c0d011d6:	d15b      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    sw = monero_apdu_manage_seedwords();
    break;

   /* --- PROVISIONING--- */
  case INS_VERIFY_KEY:
    sw = monero_apdu_verify_key();
c0d011d8:	f000 fc6e 	bl	c0d01ab8 <monero_apdu_verify_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011dc:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011de:	2822      	cmp	r0, #34	; 0x22
c0d011e0:	d156      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;


   /* --- KEYS --- */
  case INS_PUT_KEY:
    sw = monero_apdu_put_key();
c0d011e2:	f000 fbd1 	bl	c0d01988 <monero_apdu_put_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011e6:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011e8:	2830      	cmp	r0, #48	; 0x30
c0d011ea:	d151      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_GET_CHACHA8_PREKEY:
    sw = monero_apdu_get_chacha8_prekey();
    break;
  case INS_SECRET_KEY_TO_PUBLIC_KEY:
    sw = monero_apdu_secret_key_to_public_key();
c0d011ec:	f000 fd58 	bl	c0d01ca0 <monero_apdu_secret_key_to_public_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011f0:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011f2:	2844      	cmp	r0, #68	; 0x44
c0d011f4:	d14c      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_SECRET_SCAL_MUL_KEY:
    sw = monero_apdu_scal_mul_key();
    break;
  case INS_SECRET_SCAL_MUL_BASE:
    sw = monero_apdu_scal_mul_base();
c0d011f6:	f000 fd23 	bl	c0d01c40 <monero_apdu_scal_mul_base>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d011fa:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d011fc:	2877      	cmp	r0, #119	; 0x77
c0d011fe:	d147      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    sw = monero_apu_generate_txout_keys();
    break;

    /*--- COMMITMENT MASK --- */
  case INS_GEN_COMMITMENT_MASK:
    sw = monero_apdu_gen_commitment_mask();
c0d01200:	f7fe ffda 	bl	c0d001b8 <monero_apdu_gen_commitment_mask>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01204:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01206:	284c      	cmp	r0, #76	; 0x4c
c0d01208:	d142      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_GET_SUBADDRESS_SPEND_PUBLIC_KEY:
     sw = monero_apdu_get_subaddress_spend_public_key();
    break;
  case INS_GET_SUBADDRESS_SECRET_KEY:
    sw = monero_apdu_get_subaddress_secret_key();
c0d0120a:	f000 fe52 	bl	c0d01eb2 <monero_apdu_get_subaddress_secret_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0120e:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01210:	287c      	cmp	r0, #124	; 0x7c
c0d01212:	d13d      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    sw = monero_apdu_unblind();
    break;

    /* --- VALIDATE/PREHASH --- */
  case INS_VALIDATE:
    if (G_monero_vstate.io_p1 == 1) {
c0d01214:	7908      	ldrb	r0, [r1, #4]
c0d01216:	2803      	cmp	r0, #3
c0d01218:	d037      	beq.n	c0d0128a <monero_dispatch+0x1e6>
c0d0121a:	2802      	cmp	r0, #2
c0d0121c:	d032      	beq.n	c0d01284 <monero_dispatch+0x1e0>
c0d0121e:	2801      	cmp	r0, #1
c0d01220:	d13a      	bne.n	c0d01298 <monero_dispatch+0x1f4>
      sw = monero_apdu_mlsag_prehash_init();
c0d01222:	f001 fcdf 	bl	c0d02be4 <monero_apdu_mlsag_prehash_init>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01226:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01228:	2848      	cmp	r0, #72	; 0x48
c0d0122a:	d131      	bne.n	c0d01290 <monero_dispatch+0x1ec>
  /* --- ADRESSES --- */
  case INS_DERIVE_SUBADDRESS_PUBLIC_KEY:
    sw = monero_apdu_derive_subaddress_public_key();
    break;
  case INS_GET_SUBADDRESS:
    sw = monero_apdu_get_subaddress();
c0d0122c:	f000 fe0c 	bl	c0d01e48 <monero_apdu_get_subaddress>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01230:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01232:	287a      	cmp	r0, #122	; 0x7a
c0d01234:	d12c      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    /* --- BLIND --- */
  case INS_BLIND:
    sw = monero_apdu_blind();
    break;
  case INS_UNBLIND:
    sw = monero_apdu_unblind();
c0d01236:	f7fe ff91 	bl	c0d0015c <monero_apdu_unblind>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0123a:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0123c:	2872      	cmp	r0, #114	; 0x72
c0d0123e:	d127      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    sw = monero_apdu_close_tx();
    break;

     /* --- SIG MODE --- */
  case INS_SET_SIGNATURE_MODE:
    sw = monero_apdu_set_signature_mode();
c0d01240:	f001 fcb4 	bl	c0d02bac <monero_apdu_set_signature_mode>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01244:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01246:	2880      	cmp	r0, #128	; 0x80
c0d01248:	d122      	bne.n	c0d01290 <monero_dispatch+0x1ec>
  case INS_OPEN_TX:
    sw = monero_apdu_open_tx();
    break;

  case INS_CLOSE_TX:
    sw = monero_apdu_close_tx();
c0d0124a:	f001 fc97 	bl	c0d02b7c <monero_apdu_close_tx>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0124e:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01250:	2834      	cmp	r0, #52	; 0x34
c0d01252:	d11d      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_GEN_KEY_DERIVATION:
    sw = monero_apdu_generate_key_derivation();
    break;
  case INS_DERIVATION_TO_SCALAR:
    sw = monero_apdu_derivation_to_scalar();
c0d01254:	f000 fd59 	bl	c0d01d0a <monero_apdu_derivation_to_scalar>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01258:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0125a:	283c      	cmp	r0, #60	; 0x3c
c0d0125c:	d118      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_GEN_KEY_IMAGE:
    sw = monero_apdu_generate_key_image();
    break;
  case INS_SECRET_KEY_ADD:
    sw = monero_apdu_sc_add();
c0d0125e:	f000 fc95 	bl	c0d01b8c <monero_apdu_sc_add>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01262:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d01264:	2838      	cmp	r0, #56	; 0x38
c0d01266:	d113      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_DERIVE_PUBLIC_KEY:
    sw = monero_apdu_derive_public_key();
    break;
  case INS_DERIVE_SECRET_KEY:
    sw = monero_apdu_derive_secret_key();
c0d01268:	f000 fd8d 	bl	c0d01d86 <monero_apdu_derive_secret_key>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0126c:	bd10      	pop	{r4, pc}
  check_potocol();
  check_ins_access();

  G_monero_vstate.options = monero_io_fetch_u8();

  if (G_monero_vstate.io_ins == INS_RESET) {
c0d0126e:	2840      	cmp	r0, #64	; 0x40
c0d01270:	d10e      	bne.n	c0d01290 <monero_dispatch+0x1ec>
    break;
  case INS_SECRET_KEY_SUB:
    sw = monero_apdu_sc_sub();
    break;
  case INS_GENERATE_KEYPAIR:
    sw = monero_apdu_generate_keypair();
c0d01272:	f000 fcfd 	bl	c0d01c70 <monero_apdu_generate_keypair>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01276:	bd10      	pop	{r4, pc}
  /* --- MLSAG --- */
  case INS_MLSAG:
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prepare();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_hash();
c0d01278:	f001 faa6 	bl	c0d027c8 <monero_apdu_mlsag_hash>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0127c:	bd10      	pop	{r4, pc}
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prepare();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_hash();
    }  else if (G_monero_vstate.io_p1 == 3) {
      sw = monero_apdu_mlsag_sign();
c0d0127e:	f001 fae5 	bl	c0d0284c <monero_apdu_mlsag_sign>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01282:	bd10      	pop	{r4, pc}
    /* --- VALIDATE/PREHASH --- */
  case INS_VALIDATE:
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prehash_init();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_prehash_update();
c0d01284:	f001 fcfc 	bl	c0d02c80 <monero_apdu_mlsag_prehash_update>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d01288:	bd10      	pop	{r4, pc}
    if (G_monero_vstate.io_p1 == 1) {
      sw = monero_apdu_mlsag_prehash_init();
    }  else if (G_monero_vstate.io_p1 == 2) {
      sw = monero_apdu_mlsag_prehash_update();
    }  else if (G_monero_vstate.io_p1 == 3) {
      sw = monero_apdu_mlsag_prehash_finalize();
c0d0128a:	f001 fe0f 	bl	c0d02eac <monero_apdu_mlsag_prehash_finalize>
    THROW(SW_INS_NOT_SUPPORTED);
    return SW_INS_NOT_SUPPORTED;
    break;
  }
  return sw;
}
c0d0128e:	bd10      	pop	{r4, pc}
c0d01290:	206d      	movs	r0, #109	; 0x6d
c0d01292:	0200      	lsls	r0, r0, #8
    break;

  /* --- KEYS --- */

  default:
    THROW(SW_INS_NOT_SUPPORTED);
c0d01294:	f002 fc4a 	bl	c0d03b2c <os_longjmp>
c0d01298:	206b      	movs	r0, #107	; 0x6b
c0d0129a:	0200      	lsls	r0, r0, #8
c0d0129c:	f002 fc46 	bl	c0d03b2c <os_longjmp>
c0d012a0:	20001930 	.word	0x20001930

c0d012a4 <monero_init>:
};

/* ----------------------------------------------------------------------- */
/* --- Boot                                                            --- */
/* ----------------------------------------------------------------------- */
void monero_init() {
c0d012a4:	b510      	push	{r4, lr}
c0d012a6:	2083      	movs	r0, #131	; 0x83
c0d012a8:	0102      	lsls	r2, r0, #4
  os_memset(&G_monero_vstate, 0, sizeof(monero_v_state_t));
c0d012aa:	4c0d      	ldr	r4, [pc, #52]	; (c0d012e0 <monero_init+0x3c>)
c0d012ac:	2100      	movs	r1, #0
c0d012ae:	4620      	mov	r0, r4
c0d012b0:	f002 fb64 	bl	c0d0397c <os_memset>

  //first init ?
  if (os_memcmp(N_monero_pstate->magic, (void*)C_MAGIC, sizeof(C_MAGIC)) != 0) {
c0d012b4:	480b      	ldr	r0, [pc, #44]	; (c0d012e4 <monero_init+0x40>)
c0d012b6:	f003 fa57 	bl	c0d04768 <pic>
c0d012ba:	490b      	ldr	r1, [pc, #44]	; (c0d012e8 <monero_init+0x44>)
c0d012bc:	4479      	add	r1, pc
c0d012be:	2208      	movs	r2, #8
c0d012c0:	f002 fc20 	bl	c0d03b04 <os_memcmp>
c0d012c4:	2800      	cmp	r0, #0
c0d012c6:	d002      	beq.n	c0d012ce <monero_init+0x2a>
c0d012c8:	2000      	movs	r0, #0
    monero_install(MAINNET);
c0d012ca:	f000 f80f 	bl	c0d012ec <monero_install>
c0d012ce:	203f      	movs	r0, #63	; 0x3f
c0d012d0:	43c0      	mvns	r0, r0
  }

  G_monero_vstate.protocol = 0xff;
c0d012d2:	303f      	adds	r0, #63	; 0x3f
c0d012d4:	7060      	strb	r0, [r4, #1]

  //load key
  monero_init_private_key();
c0d012d6:	f000 f839 	bl	c0d0134c <monero_init_private_key>
c0d012da:	20c0      	movs	r0, #192	; 0xc0
  //ux conf
  monero_init_ux();
  // Let's go!
  G_monero_vstate.state = STATE_IDLE;
c0d012dc:	7020      	strb	r0, [r4, #0]
}
c0d012de:	bd10      	pop	{r4, pc}
c0d012e0:	20001930 	.word	0x20001930
c0d012e4:	c0d07c00 	.word	0xc0d07c00
c0d012e8:	0000574c 	.word	0x0000574c

c0d012ec <monero_install>:
}

/* ----------------------------------------------------------------------- */
/* ---  Install/ReInstall Monero app                                   --- */
/* ----------------------------------------------------------------------- */
void monero_install(unsigned char netId) {
c0d012ec:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d012ee:	b083      	sub	sp, #12
c0d012f0:	ad02      	add	r5, sp, #8
c0d012f2:	7028      	strb	r0, [r5, #0]
  unsigned char c;

  //full reset data
  monero_nvm_write(N_monero_pstate, NULL, sizeof(monero_nv_state_t));
c0d012f4:	4c12      	ldr	r4, [pc, #72]	; (c0d01340 <monero_install+0x54>)
c0d012f6:	4620      	mov	r0, r4
c0d012f8:	f003 fa36 	bl	c0d04768 <pic>
c0d012fc:	2100      	movs	r1, #0
c0d012fe:	4a11      	ldr	r2, [pc, #68]	; (c0d01344 <monero_install+0x58>)
c0d01300:	f003 fa74 	bl	c0d047ec <nvm_write>
c0d01304:	ae01      	add	r6, sp, #4
c0d01306:	2042      	movs	r0, #66	; 0x42

  //set mode key
  c = KEY_MODE_SEED;
c0d01308:	7030      	strb	r0, [r6, #0]
  nvm_write(&N_monero_pstate->key_mode, &c, 1);
c0d0130a:	4620      	mov	r0, r4
c0d0130c:	f003 fa2c 	bl	c0d04768 <pic>
c0d01310:	3009      	adds	r0, #9
c0d01312:	2701      	movs	r7, #1
c0d01314:	4631      	mov	r1, r6
c0d01316:	463a      	mov	r2, r7
c0d01318:	f003 fa68 	bl	c0d047ec <nvm_write>

  //set net id
  monero_nvm_write(&N_monero_pstate->network_id, &netId, 1);
c0d0131c:	4620      	mov	r0, r4
c0d0131e:	f003 fa23 	bl	c0d04768 <pic>
c0d01322:	3008      	adds	r0, #8
c0d01324:	4629      	mov	r1, r5
c0d01326:	463a      	mov	r2, r7
c0d01328:	f003 fa60 	bl	c0d047ec <nvm_write>

  //write magic
  monero_nvm_write(N_monero_pstate->magic, (void*)C_MAGIC, sizeof(C_MAGIC));
c0d0132c:	4620      	mov	r0, r4
c0d0132e:	f003 fa1b 	bl	c0d04768 <pic>
c0d01332:	4905      	ldr	r1, [pc, #20]	; (c0d01348 <monero_install+0x5c>)
c0d01334:	4479      	add	r1, pc
c0d01336:	2208      	movs	r2, #8
c0d01338:	f003 fa58 	bl	c0d047ec <nvm_write>
}
c0d0133c:	b003      	add	sp, #12
c0d0133e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01340:	c0d07c00 	.word	0xc0d07c00
c0d01344:	00000252 	.word	0x00000252
c0d01348:	000056d4 	.word	0x000056d4

c0d0134c <monero_init_private_key>:
 os_memset(G_monero_vstate.B,  0, 32);
 os_memset(&G_monero_vstate.spk, 0, sizeof(G_monero_vstate.spk));
 G_monero_vstate.key_set = 0;
}

void monero_init_private_key() {
c0d0134c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0134e:	b099      	sub	sp, #100	; 0x64
c0d01350:	4840      	ldr	r0, [pc, #256]	; (c0d01454 <monero_init_private_key+0x108>)

  //generate account keys

  // m/44'/10343'/0'/0/0
  path[0] = 0x8000002C;
  path[1] = 0x80002867;
c0d01352:	9015      	str	r0, [sp, #84]	; 0x54
c0d01354:	2000      	movs	r0, #0
  path[2] = 0x80000000;
  path[3] = 0x00000000;
c0d01356:	9017      	str	r0, [sp, #92]	; 0x5c
  path[4] = 0x00000000;
c0d01358:	9018      	str	r0, [sp, #96]	; 0x60
c0d0135a:	2701      	movs	r7, #1
c0d0135c:	07f8      	lsls	r0, r7, #31
  //generate account keys

  // m/44'/10343'/0'/0/0
  path[0] = 0x8000002C;
  path[1] = 0x80002867;
  path[2] = 0x80000000;
c0d0135e:	9016      	str	r0, [sp, #88]	; 0x58
  unsigned char chain[32];

  //generate account keys

  // m/44'/10343'/0'/0/0
  path[0] = 0x8000002C;
c0d01360:	302c      	adds	r0, #44	; 0x2c
c0d01362:	9014      	str	r0, [sp, #80]	; 0x50
c0d01364:	a804      	add	r0, sp, #16
  path[1] = 0x80002867;
  path[2] = 0x80000000;
  path[3] = 0x00000000;
  path[4] = 0x00000000;
  os_perso_derive_node_bip32(CX_CURVE_SECP256K1, path, 5 , seed, chain);
c0d01366:	4669      	mov	r1, sp
c0d01368:	6008      	str	r0, [r1, #0]
c0d0136a:	2021      	movs	r0, #33	; 0x21
c0d0136c:	a914      	add	r1, sp, #80	; 0x50
c0d0136e:	2205      	movs	r2, #5
c0d01370:	ab0c      	add	r3, sp, #48	; 0x30
c0d01372:	f003 fbd1 	bl	c0d04b18 <os_perso_derive_node_bip32>

  switch(N_monero_pstate->key_mode) {
c0d01376:	4838      	ldr	r0, [pc, #224]	; (c0d01458 <monero_init_private_key+0x10c>)
c0d01378:	f003 f9f6 	bl	c0d04768 <pic>
c0d0137c:	7a40      	ldrb	r0, [r0, #9]
c0d0137e:	2821      	cmp	r0, #33	; 0x21
c0d01380:	d028      	beq.n	c0d013d4 <monero_init_private_key+0x88>
c0d01382:	9703      	str	r7, [sp, #12]
c0d01384:	2842      	cmp	r0, #66	; 0x42
c0d01386:	d160      	bne.n	c0d0144a <monero_init_private_key+0xfe>
c0d01388:	2061      	movs	r0, #97	; 0x61
c0d0138a:	0080      	lsls	r0, r0, #2
  case KEY_MODE_SEED:

    monero_keccak_F(seed,32,G_monero_vstate.b);
c0d0138c:	4d33      	ldr	r5, [pc, #204]	; (c0d0145c <monero_init_private_key+0x110>)
c0d0138e:	182c      	adds	r4, r5, r0
c0d01390:	4668      	mov	r0, sp
c0d01392:	6004      	str	r4, [r0, #0]
c0d01394:	2023      	movs	r0, #35	; 0x23
c0d01396:	0100      	lsls	r0, r0, #4
c0d01398:	1829      	adds	r1, r5, r0
c0d0139a:	9102      	str	r1, [sp, #8]
c0d0139c:	2706      	movs	r7, #6
c0d0139e:	aa0c      	add	r2, sp, #48	; 0x30
c0d013a0:	2620      	movs	r6, #32
c0d013a2:	4638      	mov	r0, r7
c0d013a4:	4633      	mov	r3, r6
c0d013a6:	f7fe ff91 	bl	c0d002cc <monero_hash>
    monero_reduce(G_monero_vstate.b,G_monero_vstate.b);
c0d013aa:	4620      	mov	r0, r4
c0d013ac:	4621      	mov	r1, r4
c0d013ae:	f7fe ffeb 	bl	c0d00388 <monero_reduce>
c0d013b2:	2051      	movs	r0, #81	; 0x51
c0d013b4:	0080      	lsls	r0, r0, #2
    monero_keccak_F(G_monero_vstate.b,32,G_monero_vstate.a);
c0d013b6:	182d      	adds	r5, r5, r0
c0d013b8:	4668      	mov	r0, sp
c0d013ba:	6005      	str	r5, [r0, #0]
c0d013bc:	4638      	mov	r0, r7
c0d013be:	9902      	ldr	r1, [sp, #8]
c0d013c0:	4622      	mov	r2, r4
c0d013c2:	4633      	mov	r3, r6
c0d013c4:	f7fe ff82 	bl	c0d002cc <monero_hash>
    monero_reduce(G_monero_vstate.a,G_monero_vstate.a);
c0d013c8:	4628      	mov	r0, r5
c0d013ca:	4629      	mov	r1, r5
c0d013cc:	f7fe ffdc 	bl	c0d00388 <monero_reduce>
c0d013d0:	9f03      	ldr	r7, [sp, #12]
c0d013d2:	e018      	b.n	c0d01406 <monero_init_private_key+0xba>
    break;

  case KEY_MODE_EXTERNAL:
    os_memmove(G_monero_vstate.a,  N_monero_pstate->a, 32);
c0d013d4:	4c20      	ldr	r4, [pc, #128]	; (c0d01458 <monero_init_private_key+0x10c>)
c0d013d6:	4620      	mov	r0, r4
c0d013d8:	f003 f9c6 	bl	c0d04768 <pic>
c0d013dc:	4601      	mov	r1, r0
c0d013de:	2051      	movs	r0, #81	; 0x51
c0d013e0:	0080      	lsls	r0, r0, #2
c0d013e2:	4e1e      	ldr	r6, [pc, #120]	; (c0d0145c <monero_init_private_key+0x110>)
c0d013e4:	1830      	adds	r0, r6, r0
c0d013e6:	310a      	adds	r1, #10
c0d013e8:	2520      	movs	r5, #32
c0d013ea:	462a      	mov	r2, r5
c0d013ec:	f002 facf 	bl	c0d0398e <os_memmove>
    os_memmove(G_monero_vstate.b,  N_monero_pstate->b, 32);
c0d013f0:	4620      	mov	r0, r4
c0d013f2:	f003 f9b9 	bl	c0d04768 <pic>
c0d013f6:	4601      	mov	r1, r0
c0d013f8:	2061      	movs	r0, #97	; 0x61
c0d013fa:	0080      	lsls	r0, r0, #2
c0d013fc:	1830      	adds	r0, r6, r0
c0d013fe:	312a      	adds	r1, #42	; 0x2a
c0d01400:	462a      	mov	r2, r5
c0d01402:	f002 fac4 	bl	c0d0398e <os_memmove>
c0d01406:	2059      	movs	r0, #89	; 0x59
c0d01408:	0080      	lsls	r0, r0, #2
  default :
    THROW(SW_SECURITY_LOAD_KEY);
    return;
  }

  monero_ecmul_G(G_monero_vstate.A, G_monero_vstate.a);
c0d0140a:	4e14      	ldr	r6, [pc, #80]	; (c0d0145c <monero_init_private_key+0x110>)
c0d0140c:	1830      	adds	r0, r6, r0
c0d0140e:	2151      	movs	r1, #81	; 0x51
c0d01410:	0089      	lsls	r1, r1, #2
c0d01412:	1874      	adds	r4, r6, r1
c0d01414:	4621      	mov	r1, r4
c0d01416:	f7ff fa11 	bl	c0d0083c <monero_ecmul_G>
c0d0141a:	2069      	movs	r0, #105	; 0x69
c0d0141c:	0080      	lsls	r0, r0, #2
  monero_ecmul_G(G_monero_vstate.B, G_monero_vstate.b);
c0d0141e:	1830      	adds	r0, r6, r0
c0d01420:	2161      	movs	r1, #97	; 0x61
c0d01422:	0089      	lsls	r1, r1, #2
c0d01424:	1875      	adds	r5, r6, r1
c0d01426:	4629      	mov	r1, r5
c0d01428:	f7ff fa08 	bl	c0d0083c <monero_ecmul_G>
c0d0142c:	2071      	movs	r0, #113	; 0x71
c0d0142e:	0080      	lsls	r0, r0, #2

  //generate key protection
  monero_aes_derive(&G_monero_vstate.spk,chain,G_monero_vstate.a,G_monero_vstate.b);
c0d01430:	1830      	adds	r0, r6, r0
c0d01432:	a904      	add	r1, sp, #16
c0d01434:	4622      	mov	r2, r4
c0d01436:	462b      	mov	r3, r5
c0d01438:	f7fe fed6 	bl	c0d001e8 <monero_aes_derive>
c0d0143c:	203d      	movs	r0, #61	; 0x3d
c0d0143e:	00c0      	lsls	r0, r0, #3


  G_monero_vstate.key_set = 1;
c0d01440:	5c31      	ldrb	r1, [r6, r0]
c0d01442:	4339      	orrs	r1, r7
c0d01444:	5431      	strb	r1, [r6, r0]
}
c0d01446:	b019      	add	sp, #100	; 0x64
c0d01448:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0144a:	2069      	movs	r0, #105	; 0x69
c0d0144c:	0200      	lsls	r0, r0, #8
    os_memmove(G_monero_vstate.a,  N_monero_pstate->a, 32);
    os_memmove(G_monero_vstate.b,  N_monero_pstate->b, 32);
    break;

  default :
    THROW(SW_SECURITY_LOAD_KEY);
c0d0144e:	f002 fb6d 	bl	c0d03b2c <os_longjmp>
c0d01452:	46c0      	nop			; (mov r8, r8)
c0d01454:	80002867 	.word	0x80002867
c0d01458:	c0d07c00 	.word	0xc0d07c00
c0d0145c:	20001930 	.word	0x20001930

c0d01460 <monero_io_inserted>:
  G_monero_vstate.io_mark = G_monero_vstate.io_offset;
}


void monero_io_inserted(unsigned int len) {
  G_monero_vstate.io_offset += len;
c0d01460:	4903      	ldr	r1, [pc, #12]	; (c0d01470 <monero_io_inserted+0x10>)
c0d01462:	894a      	ldrh	r2, [r1, #10]
c0d01464:	1812      	adds	r2, r2, r0
c0d01466:	814a      	strh	r2, [r1, #10]
  G_monero_vstate.io_length += len;
c0d01468:	890a      	ldrh	r2, [r1, #8]
c0d0146a:	1810      	adds	r0, r2, r0
c0d0146c:	8108      	strh	r0, [r1, #8]
}
c0d0146e:	4770      	bx	lr
c0d01470:	20001930 	.word	0x20001930

c0d01474 <monero_io_discard>:

void monero_io_discard(int clear) {
c0d01474:	b580      	push	{r7, lr}
c0d01476:	4601      	mov	r1, r0
  G_monero_vstate.io_length = 0;
c0d01478:	4806      	ldr	r0, [pc, #24]	; (c0d01494 <monero_io_discard+0x20>)
c0d0147a:	2200      	movs	r2, #0
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_mark = 0;
c0d0147c:	8182      	strh	r2, [r0, #12]
  G_monero_vstate.io_offset += len;
  G_monero_vstate.io_length += len;
}

void monero_io_discard(int clear) {
  G_monero_vstate.io_length = 0;
c0d0147e:	6082      	str	r2, [r0, #8]
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_mark = 0;
  if (clear) {
c0d01480:	2900      	cmp	r1, #0
c0d01482:	d005      	beq.n	c0d01490 <monero_io_discard+0x1c>
    monero_io_clear();
  }
}

void monero_io_clear() {
  os_memset(G_monero_vstate.io_buffer, 0 , MONERO_IO_BUFFER_LENGTH);
c0d01484:	300e      	adds	r0, #14
c0d01486:	214b      	movs	r1, #75	; 0x4b
c0d01488:	008a      	lsls	r2, r1, #2
c0d0148a:	2100      	movs	r1, #0
c0d0148c:	f002 fa76 	bl	c0d0397c <os_memset>
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_mark = 0;
  if (clear) {
    monero_io_clear();
  }
}
c0d01490:	bd80      	pop	{r7, pc}
c0d01492:	46c0      	nop			; (mov r8, r8)
c0d01494:	20001930 	.word	0x20001930

c0d01498 <monero_io_hole>:

/* ----------------------------------------------------------------------- */
/* INSERT data to be sent                                                  */
/* ----------------------------------------------------------------------- */

void monero_io_hole(unsigned int sz) {
c0d01498:	b5b0      	push	{r4, r5, r7, lr}
c0d0149a:	4604      	mov	r4, r0
  if ((G_monero_vstate.io_length + sz) > MONERO_IO_BUFFER_LENGTH) {
c0d0149c:	4d0a      	ldr	r5, [pc, #40]	; (c0d014c8 <monero_io_hole+0x30>)
c0d0149e:	8928      	ldrh	r0, [r5, #8]
c0d014a0:	1901      	adds	r1, r0, r4
c0d014a2:	22ff      	movs	r2, #255	; 0xff
c0d014a4:	322e      	adds	r2, #46	; 0x2e
c0d014a6:	4291      	cmp	r1, r2
c0d014a8:	d20a      	bcs.n	c0d014c0 <monero_io_hole+0x28>
    THROW(ERROR_IO_FULL);
    return ;
  }
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset+sz,
c0d014aa:	8969      	ldrh	r1, [r5, #10]
             G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
             G_monero_vstate.io_length-G_monero_vstate.io_offset);
c0d014ac:	1a42      	subs	r2, r0, r1
void monero_io_hole(unsigned int sz) {
  if ((G_monero_vstate.io_length + sz) > MONERO_IO_BUFFER_LENGTH) {
    THROW(ERROR_IO_FULL);
    return ;
  }
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset+sz,
c0d014ae:	1869      	adds	r1, r5, r1
c0d014b0:	310e      	adds	r1, #14
c0d014b2:	1908      	adds	r0, r1, r4
c0d014b4:	f002 fa6b 	bl	c0d0398e <os_memmove>
             G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
             G_monero_vstate.io_length-G_monero_vstate.io_offset);
  G_monero_vstate.io_length += sz;
c0d014b8:	8928      	ldrh	r0, [r5, #8]
c0d014ba:	1900      	adds	r0, r0, r4
c0d014bc:	8128      	strh	r0, [r5, #8]
}
c0d014be:	bdb0      	pop	{r4, r5, r7, pc}
c0d014c0:	2001      	movs	r0, #1
c0d014c2:	0440      	lsls	r0, r0, #17
/* INSERT data to be sent                                                  */
/* ----------------------------------------------------------------------- */

void monero_io_hole(unsigned int sz) {
  if ((G_monero_vstate.io_length + sz) > MONERO_IO_BUFFER_LENGTH) {
    THROW(ERROR_IO_FULL);
c0d014c4:	f002 fb32 	bl	c0d03b2c <os_longjmp>
c0d014c8:	20001930 	.word	0x20001930

c0d014cc <monero_io_insert>:
             G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
             G_monero_vstate.io_length-G_monero_vstate.io_offset);
  G_monero_vstate.io_length += sz;
}

void monero_io_insert(unsigned char const *buff, unsigned int len) {
c0d014cc:	b570      	push	{r4, r5, r6, lr}
c0d014ce:	460c      	mov	r4, r1
c0d014d0:	4605      	mov	r5, r0
  monero_io_hole(len);
c0d014d2:	4608      	mov	r0, r1
c0d014d4:	f7ff ffe0 	bl	c0d01498 <monero_io_hole>
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, buff, len);
c0d014d8:	4e05      	ldr	r6, [pc, #20]	; (c0d014f0 <monero_io_insert+0x24>)
c0d014da:	8970      	ldrh	r0, [r6, #10]
c0d014dc:	1830      	adds	r0, r6, r0
c0d014de:	300e      	adds	r0, #14
c0d014e0:	4629      	mov	r1, r5
c0d014e2:	4622      	mov	r2, r4
c0d014e4:	f002 fa53 	bl	c0d0398e <os_memmove>
  G_monero_vstate.io_offset += len;
c0d014e8:	8970      	ldrh	r0, [r6, #10]
c0d014ea:	1900      	adds	r0, r0, r4
c0d014ec:	8170      	strh	r0, [r6, #10]
}
c0d014ee:	bd70      	pop	{r4, r5, r6, pc}
c0d014f0:	20001930 	.word	0x20001930

c0d014f4 <monero_io_insert_encrypt>:

void monero_io_insert_encrypt(unsigned char* buffer, int len) {
c0d014f4:	b5b0      	push	{r4, r5, r7, lr}
c0d014f6:	460d      	mov	r5, r1
c0d014f8:	4604      	mov	r4, r0
  monero_io_hole(len);
c0d014fa:	4608      	mov	r0, r1
c0d014fc:	f7ff ffcc 	bl	c0d01498 <monero_io_hole>

  //for now, only 32bytes block are allowed
  if (len != 32) {
c0d01500:	2d20      	cmp	r5, #32
c0d01502:	d10b      	bne.n	c0d0151c <monero_io_insert_encrypt+0x28>
#if defined(IODUMMYCRYPT)
  for (int i = 0; i<len; i++) {
       G_monero_vstate.io_buffer[G_monero_vstate.io_offset+i] = buffer[i] ^ 0x55;
    }
#elif defined(IONOCRYPT)
  os_memmove(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, buffer, len);
c0d01504:	4d08      	ldr	r5, [pc, #32]	; (c0d01528 <monero_io_insert_encrypt+0x34>)
c0d01506:	8968      	ldrh	r0, [r5, #10]
c0d01508:	1828      	adds	r0, r5, r0
c0d0150a:	300e      	adds	r0, #14
c0d0150c:	2220      	movs	r2, #32
c0d0150e:	4621      	mov	r1, r4
c0d01510:	f002 fa3d 	bl	c0d0398e <os_memmove>
#else 
  cx_aes(&G_monero_vstate.spk, CX_ENCRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
         buffer, len,
         G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
#endif
  G_monero_vstate.io_offset += len;
c0d01514:	8968      	ldrh	r0, [r5, #10]
c0d01516:	3020      	adds	r0, #32
c0d01518:	8168      	strh	r0, [r5, #10]
}
c0d0151a:	bdb0      	pop	{r4, r5, r7, pc}
c0d0151c:	4801      	ldr	r0, [pc, #4]	; (c0d01524 <monero_io_insert_encrypt+0x30>)
void monero_io_insert_encrypt(unsigned char* buffer, int len) {
  monero_io_hole(len);

  //for now, only 32bytes block are allowed
  if (len != 32) {
    THROW(SW_SECURE_MESSAGING_NOT_SUPPORTED);
c0d0151e:	f002 fb05 	bl	c0d03b2c <os_longjmp>
c0d01522:	46c0      	nop			; (mov r8, r8)
c0d01524:	00006882 	.word	0x00006882
c0d01528:	20001930 	.word	0x20001930

c0d0152c <monero_io_insert_u32>:
         G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
#endif
  G_monero_vstate.io_offset += len;
}

void monero_io_insert_u32(unsigned  int v32) {
c0d0152c:	b510      	push	{r4, lr}
c0d0152e:	4604      	mov	r4, r0
c0d01530:	2004      	movs	r0, #4
  monero_io_hole(4);
c0d01532:	f7ff ffb1 	bl	c0d01498 <monero_io_hole>
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v32>>24;
c0d01536:	4806      	ldr	r0, [pc, #24]	; (c0d01550 <monero_io_insert_u32+0x24>)
c0d01538:	8941      	ldrh	r1, [r0, #10]
c0d0153a:	1842      	adds	r2, r0, r1
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v32>>16;
c0d0153c:	0c23      	lsrs	r3, r4, #16
c0d0153e:	73d3      	strb	r3, [r2, #15]
  G_monero_vstate.io_offset += len;
}

void monero_io_insert_u32(unsigned  int v32) {
  monero_io_hole(4);
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v32>>24;
c0d01540:	0e23      	lsrs	r3, r4, #24
c0d01542:	7393      	strb	r3, [r2, #14]
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v32>>16;
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] = v32>>8;
c0d01544:	0a23      	lsrs	r3, r4, #8
c0d01546:	7413      	strb	r3, [r2, #16]
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] = v32>>0;
c0d01548:	7454      	strb	r4, [r2, #17]
  G_monero_vstate.io_offset += 4;
c0d0154a:	1d09      	adds	r1, r1, #4
c0d0154c:	8141      	strh	r1, [r0, #10]
}
c0d0154e:	bd10      	pop	{r4, pc}
c0d01550:	20001930 	.word	0x20001930

c0d01554 <monero_io_insert_u16>:
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v24>>8;
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] = v24>>0;
  G_monero_vstate.io_offset += 3;
}

void monero_io_insert_u16(unsigned  int v16) {
c0d01554:	b510      	push	{r4, lr}
c0d01556:	4604      	mov	r4, r0
c0d01558:	2002      	movs	r0, #2
  monero_io_hole(2);
c0d0155a:	f7ff ff9d 	bl	c0d01498 <monero_io_hole>
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v16>>8;
c0d0155e:	4804      	ldr	r0, [pc, #16]	; (c0d01570 <monero_io_insert_u16+0x1c>)
c0d01560:	8941      	ldrh	r1, [r0, #10]
c0d01562:	1842      	adds	r2, r0, r1
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v16>>0;
c0d01564:	73d4      	strb	r4, [r2, #15]
  G_monero_vstate.io_offset += 3;
}

void monero_io_insert_u16(unsigned  int v16) {
  monero_io_hole(2);
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v16>>8;
c0d01566:	0a23      	lsrs	r3, r4, #8
c0d01568:	7393      	strb	r3, [r2, #14]
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] = v16>>0;
  G_monero_vstate.io_offset += 2;
c0d0156a:	1c89      	adds	r1, r1, #2
c0d0156c:	8141      	strh	r1, [r0, #10]
}
c0d0156e:	bd10      	pop	{r4, pc}
c0d01570:	20001930 	.word	0x20001930

c0d01574 <monero_io_insert_u8>:

void monero_io_insert_u8(unsigned int v8) {
c0d01574:	b510      	push	{r4, lr}
c0d01576:	4604      	mov	r4, r0
c0d01578:	2001      	movs	r0, #1
  monero_io_hole(1);
c0d0157a:	f7ff ff8d 	bl	c0d01498 <monero_io_hole>
  G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] = v8;
c0d0157e:	4803      	ldr	r0, [pc, #12]	; (c0d0158c <monero_io_insert_u8+0x18>)
c0d01580:	8941      	ldrh	r1, [r0, #10]
c0d01582:	1842      	adds	r2, r0, r1
c0d01584:	7394      	strb	r4, [r2, #14]
  G_monero_vstate.io_offset += 1;
c0d01586:	1c49      	adds	r1, r1, #1
c0d01588:	8141      	strh	r1, [r0, #10]
}
c0d0158a:	bd10      	pop	{r4, pc}
c0d0158c:	20001930 	.word	0x20001930

c0d01590 <monero_io_fetch>:
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
  }
}

int monero_io_fetch(unsigned char* buffer, int len) {
c0d01590:	b5b0      	push	{r4, r5, r7, lr}
c0d01592:	460c      	mov	r4, r1

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d01594:	4d0b      	ldr	r5, [pc, #44]	; (c0d015c4 <monero_io_fetch+0x34>)
c0d01596:	8969      	ldrh	r1, [r5, #10]
c0d01598:	892a      	ldrh	r2, [r5, #8]
c0d0159a:	1a52      	subs	r2, r2, r1
c0d0159c:	42a2      	cmp	r2, r4
c0d0159e:	db0b      	blt.n	c0d015b8 <monero_io_fetch+0x28>
  }
}

int monero_io_fetch(unsigned char* buffer, int len) {
  monero_io_assert_availabe(len);
  if (buffer) {
c0d015a0:	2800      	cmp	r0, #0
c0d015a2:	d005      	beq.n	c0d015b0 <monero_io_fetch+0x20>
    os_memmove(buffer, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
c0d015a4:	1869      	adds	r1, r5, r1
c0d015a6:	310e      	adds	r1, #14
c0d015a8:	4622      	mov	r2, r4
c0d015aa:	f002 f9f0 	bl	c0d0398e <os_memmove>
  }
  G_monero_vstate.io_offset += len;
c0d015ae:	8969      	ldrh	r1, [r5, #10]
c0d015b0:	1908      	adds	r0, r1, r4
c0d015b2:	8168      	strh	r0, [r5, #10]
  return len;
c0d015b4:	4620      	mov	r0, r4
c0d015b6:	bdb0      	pop	{r4, r5, r7, pc}
c0d015b8:	2067      	movs	r0, #103	; 0x67
c0d015ba:	0200      	lsls	r0, r0, #8
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d015bc:	b2e1      	uxtb	r1, r4
c0d015be:	1808      	adds	r0, r1, r0
c0d015c0:	f002 fab4 	bl	c0d03b2c <os_longjmp>
c0d015c4:	20001930 	.word	0x20001930

c0d015c8 <monero_io_fetch_decrypt>:
  }
  G_monero_vstate.io_offset += len;
  return len;
}

int monero_io_fetch_decrypt(unsigned char* buffer, int len) {
c0d015c8:	b510      	push	{r4, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d015ca:	4c0e      	ldr	r4, [pc, #56]	; (c0d01604 <monero_io_fetch_decrypt+0x3c>)
c0d015cc:	8962      	ldrh	r2, [r4, #10]
c0d015ce:	8923      	ldrh	r3, [r4, #8]
c0d015d0:	1a9b      	subs	r3, r3, r2
c0d015d2:	428b      	cmp	r3, r1
c0d015d4:	db0d      	blt.n	c0d015f2 <monero_io_fetch_decrypt+0x2a>

int monero_io_fetch_decrypt(unsigned char* buffer, int len) {
  monero_io_assert_availabe(len);

  //for now, only 32bytes block allowed
  if (len != 32) {
c0d015d6:	2920      	cmp	r1, #32
c0d015d8:	d111      	bne.n	c0d015fe <monero_io_fetch_decrypt+0x36>
    THROW(SW_SECURE_MESSAGING_NOT_SUPPORTED);
    return 0;
  }

  if (buffer) {
c0d015da:	2800      	cmp	r0, #0
c0d015dc:	d005      	beq.n	c0d015ea <monero_io_fetch_decrypt+0x22>
#if defined(IODUMMYCRYPT)
    for (int i = 0; i<len; i++) {
      buffer[i] = G_monero_vstate.io_buffer[G_monero_vstate.io_offset+i] ^ 0x55;
    }
#elif defined(IONOCRYPT)
     os_memmove(buffer, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len);
c0d015de:	18a1      	adds	r1, r4, r2
c0d015e0:	310e      	adds	r1, #14
c0d015e2:	2220      	movs	r2, #32
c0d015e4:	f002 f9d3 	bl	c0d0398e <os_memmove>
    cx_aes(&G_monero_vstate.spk, CX_DECRYPT|CX_CHAIN_CBC|CX_LAST|CX_PAD_NONE,
           G_monero_vstate.io_buffer+G_monero_vstate.io_offset, len,
           buffer, len);
#endif
  }
  G_monero_vstate.io_offset += len;
c0d015e8:	8962      	ldrh	r2, [r4, #10]
c0d015ea:	3220      	adds	r2, #32
c0d015ec:	8162      	strh	r2, [r4, #10]
c0d015ee:	2020      	movs	r0, #32
  return len;
c0d015f0:	bd10      	pop	{r4, pc}
c0d015f2:	2067      	movs	r0, #103	; 0x67
c0d015f4:	0200      	lsls	r0, r0, #8
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d015f6:	b2c9      	uxtb	r1, r1
c0d015f8:	1808      	adds	r0, r1, r0
c0d015fa:	f002 fa97 	bl	c0d03b2c <os_longjmp>
c0d015fe:	4802      	ldr	r0, [pc, #8]	; (c0d01608 <monero_io_fetch_decrypt+0x40>)
int monero_io_fetch_decrypt(unsigned char* buffer, int len) {
  monero_io_assert_availabe(len);

  //for now, only 32bytes block allowed
  if (len != 32) {
    THROW(SW_SECURE_MESSAGING_NOT_SUPPORTED);
c0d01600:	f002 fa94 	bl	c0d03b2c <os_longjmp>
c0d01604:	20001930 	.word	0x20001930
c0d01608:	00006882 	.word	0x00006882

c0d0160c <monero_io_fetch_decrypt_key>:
  }
  G_monero_vstate.io_offset += len;
  return len;
}

int monero_io_fetch_decrypt_key(unsigned char* buffer) {
c0d0160c:	b510      	push	{r4, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d0160e:	4c16      	ldr	r4, [pc, #88]	; (c0d01668 <monero_io_fetch_decrypt_key+0x5c>)
c0d01610:	8961      	ldrh	r1, [r4, #10]
c0d01612:	8922      	ldrh	r2, [r4, #8]
c0d01614:	1a52      	subs	r2, r2, r1
c0d01616:	2a1f      	cmp	r2, #31
c0d01618:	dd22      	ble.n	c0d01660 <monero_io_fetch_decrypt_key+0x54>
  unsigned char* k;
  monero_io_assert_availabe(32);

  k = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;
  //view?
  for (i =0; i <32; i++) {
c0d0161a:	1861      	adds	r1, r4, r1
c0d0161c:	310e      	adds	r1, #14
c0d0161e:	2200      	movs	r2, #0
    if (k[i] != 0x00) break;
c0d01620:	5c8b      	ldrb	r3, [r1, r2]
c0d01622:	2b00      	cmp	r3, #0
c0d01624:	d105      	bne.n	c0d01632 <monero_io_fetch_decrypt_key+0x26>
  unsigned char* k;
  monero_io_assert_availabe(32);

  k = G_monero_vstate.io_buffer+G_monero_vstate.io_offset;
  //view?
  for (i =0; i <32; i++) {
c0d01626:	1c52      	adds	r2, r2, #1
c0d01628:	2a20      	cmp	r2, #32
c0d0162a:	d3f9      	bcc.n	c0d01620 <monero_io_fetch_decrypt_key+0x14>
    if (k[i] != 0x00) break;
  }
  if(i==32) {
c0d0162c:	d101      	bne.n	c0d01632 <monero_io_fetch_decrypt_key+0x26>
c0d0162e:	2151      	movs	r1, #81	; 0x51
c0d01630:	e008      	b.n	c0d01644 <monero_io_fetch_decrypt_key+0x38>
c0d01632:	2200      	movs	r2, #0
    G_monero_vstate.io_offset += 32;
    return 32;
  }
  //spend?
  for (i =0; i <32; i++) {
    if (k [i] != 0xff) break;
c0d01634:	5c8b      	ldrb	r3, [r1, r2]
c0d01636:	2bff      	cmp	r3, #255	; 0xff
c0d01638:	d10d      	bne.n	c0d01656 <monero_io_fetch_decrypt_key+0x4a>
    os_memmove(buffer, G_monero_vstate.a,32);
    G_monero_vstate.io_offset += 32;
    return 32;
  }
  //spend?
  for (i =0; i <32; i++) {
c0d0163a:	1c52      	adds	r2, r2, #1
c0d0163c:	2a20      	cmp	r2, #32
c0d0163e:	d3f9      	bcc.n	c0d01634 <monero_io_fetch_decrypt_key+0x28>
c0d01640:	d109      	bne.n	c0d01656 <monero_io_fetch_decrypt_key+0x4a>
c0d01642:	2161      	movs	r1, #97	; 0x61
c0d01644:	0089      	lsls	r1, r1, #2
c0d01646:	1861      	adds	r1, r4, r1
c0d01648:	2220      	movs	r2, #32
c0d0164a:	f002 f9a0 	bl	c0d0398e <os_memmove>
c0d0164e:	8960      	ldrh	r0, [r4, #10]
c0d01650:	3020      	adds	r0, #32
c0d01652:	8160      	strh	r0, [r4, #10]
c0d01654:	e002      	b.n	c0d0165c <monero_io_fetch_decrypt_key+0x50>
c0d01656:	2120      	movs	r1, #32
  if(i==32) {
    os_memmove(buffer, G_monero_vstate.b,32);
    G_monero_vstate.io_offset += 32;
    return 32;
  }
  return monero_io_fetch_decrypt(buffer, 32);
c0d01658:	f7ff ffb6 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d0165c:	2020      	movs	r0, #32
}
c0d0165e:	bd10      	pop	{r4, pc}
c0d01660:	4802      	ldr	r0, [pc, #8]	; (c0d0166c <monero_io_fetch_decrypt_key+0x60>)
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d01662:	f002 fa63 	bl	c0d03b2c <os_longjmp>
c0d01666:	46c0      	nop			; (mov r8, r8)
c0d01668:	20001930 	.word	0x20001930
c0d0166c:	00006720 	.word	0x00006720

c0d01670 <monero_io_fetch_u32>:
    return 32;
  }
  return monero_io_fetch_decrypt(buffer, 32);
}

unsigned int monero_io_fetch_u32() {
c0d01670:	b5b0      	push	{r4, r5, r7, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d01672:	480b      	ldr	r0, [pc, #44]	; (c0d016a0 <monero_io_fetch_u32+0x30>)
c0d01674:	8941      	ldrh	r1, [r0, #10]
c0d01676:	8902      	ldrh	r2, [r0, #8]
c0d01678:	1a52      	subs	r2, r2, r1
c0d0167a:	2a03      	cmp	r2, #3
c0d0167c:	dd0d      	ble.n	c0d0169a <monero_io_fetch_u32+0x2a>
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d0167e:	1842      	adds	r2, r0, r1
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] << 0) );
c0d01680:	7c53      	ldrb	r3, [r2, #17]
unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
c0d01682:	7c14      	ldrb	r4, [r2, #16]

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
c0d01684:	7bd5      	ldrb	r5, [r2, #15]
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d01686:	7b92      	ldrb	r2, [r2, #14]
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] << 0) );
  G_monero_vstate.io_offset += 4;
c0d01688:	1d09      	adds	r1, r1, #4
c0d0168a:	8141      	strh	r1, [r0, #10]
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d0168c:	0610      	lsls	r0, r2, #24
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
c0d0168e:	0429      	lsls	r1, r5, #16
}

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
c0d01690:	1808      	adds	r0, r1, r0
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
c0d01692:	0221      	lsls	r1, r4, #8

unsigned int monero_io_fetch_u32() {
  unsigned int  v32;
  monero_io_assert_availabe(4);
  v32 =  ( (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+0] << 24) |
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 16) |
c0d01694:	1840      	adds	r0, r0, r1
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+2] << 8) |
c0d01696:	18c0      	adds	r0, r0, r3
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+3] << 0) );
  G_monero_vstate.io_offset += 4;
  return v32;
c0d01698:	bdb0      	pop	{r4, r5, r7, pc}
c0d0169a:	4802      	ldr	r0, [pc, #8]	; (c0d016a4 <monero_io_fetch_u32+0x34>)
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d0169c:	f002 fa46 	bl	c0d03b2c <os_longjmp>
c0d016a0:	20001930 	.word	0x20001930
c0d016a4:	00006704 	.word	0x00006704

c0d016a8 <monero_io_fetch_u8>:
           (G_monero_vstate.io_buffer[G_monero_vstate.io_offset+1] << 0) );
  G_monero_vstate.io_offset += 2;
  return v16;
}

unsigned int monero_io_fetch_u8() {
c0d016a8:	b580      	push	{r7, lr}

/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
c0d016aa:	4906      	ldr	r1, [pc, #24]	; (c0d016c4 <monero_io_fetch_u8+0x1c>)
c0d016ac:	894a      	ldrh	r2, [r1, #10]
c0d016ae:	8908      	ldrh	r0, [r1, #8]
c0d016b0:	4290      	cmp	r0, r2
c0d016b2:	d904      	bls.n	c0d016be <monero_io_fetch_u8+0x16>
}

unsigned int monero_io_fetch_u8() {
  unsigned int  v8;
  monero_io_assert_availabe(1);
  v8 = G_monero_vstate.io_buffer[G_monero_vstate.io_offset] ;
c0d016b4:	1888      	adds	r0, r1, r2
c0d016b6:	7b80      	ldrb	r0, [r0, #14]
  G_monero_vstate.io_offset += 1;
c0d016b8:	1c52      	adds	r2, r2, #1
c0d016ba:	814a      	strh	r2, [r1, #10]
  return v8;
c0d016bc:	bd80      	pop	{r7, pc}
c0d016be:	4802      	ldr	r0, [pc, #8]	; (c0d016c8 <monero_io_fetch_u8+0x20>)
/* ----------------------------------------------------------------------- */
/* FECTH data from received buffer                                         */
/* ----------------------------------------------------------------------- */
void monero_io_assert_availabe(int sz) {
  if ((G_monero_vstate.io_length-G_monero_vstate.io_offset) < sz) {
    THROW(SW_WRONG_LENGTH + (sz&0xFF));
c0d016c0:	f002 fa34 	bl	c0d03b2c <os_longjmp>
c0d016c4:	20001930 	.word	0x20001930
c0d016c8:	00006701 	.word	0x00006701

c0d016cc <monero_io_do>:
/* REAL IO                                                                 */
/* ----------------------------------------------------------------------- */

#define MAX_OUT MONERO_APDU_LENGTH

int monero_io_do(unsigned int io_flags) {
c0d016cc:	b5b0      	push	{r4, r5, r7, lr}
c0d016ce:	4604      	mov	r4, r0

  
  // if IO_ASYNCH_REPLY has been  set,
  //  monero_io_exchange will return when  IO_RETURN_AFTER_TX will set in ui
  if (io_flags & IO_ASYNCH_REPLY) {
c0d016d0:	06c0      	lsls	r0, r0, #27
c0d016d2:	d40f      	bmi.n	c0d016f4 <monero_io_do+0x28>
    monero_io_exchange(CHANNEL_APDU | IO_ASYNCH_REPLY, 0);
  } 
  //else send data now
  else {  
    G_monero_vstate.io_offset = 0;
c0d016d4:	4d19      	ldr	r5, [pc, #100]	; (c0d0173c <monero_io_do+0x70>)
c0d016d6:	2000      	movs	r0, #0
c0d016d8:	8168      	strh	r0, [r5, #10]
    if(G_monero_vstate.io_length > MAX_OUT) {
c0d016da:	892a      	ldrh	r2, [r5, #8]
c0d016dc:	2aff      	cmp	r2, #255	; 0xff
c0d016de:	d229      	bcs.n	c0d01734 <monero_io_do+0x68>
      THROW(SW_FILE_FULL);
      return SW_FILE_FULL;
    }
    os_memmove(G_io_apdu_buffer,  G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.io_length);
c0d016e0:	4629      	mov	r1, r5
c0d016e2:	310e      	adds	r1, #14
c0d016e4:	4816      	ldr	r0, [pc, #88]	; (c0d01740 <monero_io_do+0x74>)
c0d016e6:	f002 f952 	bl	c0d0398e <os_memmove>
c0d016ea:	8929      	ldrh	r1, [r5, #8]

    if (io_flags & IO_RETURN_AFTER_TX) {
c0d016ec:	06a0      	lsls	r0, r4, #26
c0d016ee:	d41c      	bmi.n	c0d0172a <monero_io_do+0x5e>
c0d016f0:	2000      	movs	r0, #0
c0d016f2:	e001      	b.n	c0d016f8 <monero_io_do+0x2c>
c0d016f4:	2010      	movs	r0, #16
c0d016f6:	2100      	movs	r1, #0
c0d016f8:	f002 fd56 	bl	c0d041a8 <io_exchange>
      monero_io_exchange(CHANNEL_APDU,  G_monero_vstate.io_length);
    }
  }

  //--- set up received data  ---
  G_monero_vstate.io_offset = 0;
c0d016fc:	4c0f      	ldr	r4, [pc, #60]	; (c0d0173c <monero_io_do+0x70>)
c0d016fe:	2000      	movs	r0, #0
  G_monero_vstate.io_length = 0;
c0d01700:	60a0      	str	r0, [r4, #8]
  G_monero_vstate.io_protocol_version = G_io_apdu_buffer[0];
  G_monero_vstate.io_ins = G_io_apdu_buffer[1];
  G_monero_vstate.io_p1  = G_io_apdu_buffer[2];
  G_monero_vstate.io_p2  = G_io_apdu_buffer[3];
  G_monero_vstate.io_lc  = 0;
  G_monero_vstate.io_le  = 0;
c0d01702:	71e0      	strb	r0, [r4, #7]
  }

  //--- set up received data  ---
  G_monero_vstate.io_offset = 0;
  G_monero_vstate.io_length = 0;
  G_monero_vstate.io_protocol_version = G_io_apdu_buffer[0];
c0d01704:	490e      	ldr	r1, [pc, #56]	; (c0d01740 <monero_io_do+0x74>)
c0d01706:	7808      	ldrb	r0, [r1, #0]
c0d01708:	70a0      	strb	r0, [r4, #2]
  G_monero_vstate.io_ins = G_io_apdu_buffer[1];
c0d0170a:	7848      	ldrb	r0, [r1, #1]
c0d0170c:	70e0      	strb	r0, [r4, #3]
  G_monero_vstate.io_p1  = G_io_apdu_buffer[2];
c0d0170e:	7888      	ldrb	r0, [r1, #2]
c0d01710:	7120      	strb	r0, [r4, #4]
  G_monero_vstate.io_p2  = G_io_apdu_buffer[3];
c0d01712:	78c8      	ldrb	r0, [r1, #3]
c0d01714:	7160      	strb	r0, [r4, #5]
  G_monero_vstate.io_lc  = 0;
  G_monero_vstate.io_le  = 0;

  G_monero_vstate.io_lc  = G_io_apdu_buffer[4];
c0d01716:	790a      	ldrb	r2, [r1, #4]
c0d01718:	71a2      	strb	r2, [r4, #6]
  os_memmove(G_monero_vstate.io_buffer, G_io_apdu_buffer+5, G_monero_vstate.io_lc);
c0d0171a:	4620      	mov	r0, r4
c0d0171c:	300e      	adds	r0, #14
c0d0171e:	1d49      	adds	r1, r1, #5
c0d01720:	f002 f935 	bl	c0d0398e <os_memmove>
  G_monero_vstate.io_length =  G_monero_vstate.io_lc;
c0d01724:	79a0      	ldrb	r0, [r4, #6]
c0d01726:	8120      	strh	r0, [r4, #8]
c0d01728:	e002      	b.n	c0d01730 <monero_io_do+0x64>
c0d0172a:	2020      	movs	r0, #32
      return SW_FILE_FULL;
    }
    os_memmove(G_io_apdu_buffer,  G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.io_length);

    if (io_flags & IO_RETURN_AFTER_TX) {
      monero_io_exchange(CHANNEL_APDU |IO_RETURN_AFTER_TX, G_monero_vstate.io_length);
c0d0172c:	f002 fd3c 	bl	c0d041a8 <io_exchange>
c0d01730:	2000      	movs	r0, #0
  G_monero_vstate.io_lc  = G_io_apdu_buffer[4];
  os_memmove(G_monero_vstate.io_buffer, G_io_apdu_buffer+5, G_monero_vstate.io_lc);
  G_monero_vstate.io_length =  G_monero_vstate.io_lc;

  return 0;
}
c0d01732:	bdb0      	pop	{r4, r5, r7, pc}
c0d01734:	4803      	ldr	r0, [pc, #12]	; (c0d01744 <monero_io_do+0x78>)
  } 
  //else send data now
  else {  
    G_monero_vstate.io_offset = 0;
    if(G_monero_vstate.io_length > MAX_OUT) {
      THROW(SW_FILE_FULL);
c0d01736:	f002 f9f9 	bl	c0d03b2c <os_longjmp>
c0d0173a:	46c0      	nop			; (mov r8, r8)
c0d0173c:	20001930 	.word	0x20001930
c0d01740:	2000216c 	.word	0x2000216c
c0d01744:	00006a84 	.word	0x00006a84

c0d01748 <monero_clear_words>:
    }
    return( crc32 ^ 0xFFFFFFFF );
}


void monero_clear_words() {
c0d01748:	b570      	push	{r4, r5, r6, lr}
c0d0174a:	2519      	movs	r5, #25
c0d0174c:	264a      	movs	r6, #74	; 0x4a
c0d0174e:	4c06      	ldr	r4, [pc, #24]	; (c0d01768 <monero_clear_words+0x20>)
  for (int i = 0; i<25; i++) {
    monero_nvm_write(N_monero_pstate->words[i], NULL,WORDS_MAX_LENGTH);
c0d01750:	4620      	mov	r0, r4
c0d01752:	f003 f809 	bl	c0d04768 <pic>
c0d01756:	1980      	adds	r0, r0, r6
c0d01758:	2100      	movs	r1, #0
c0d0175a:	2214      	movs	r2, #20
c0d0175c:	f003 f846 	bl	c0d047ec <nvm_write>
    return( crc32 ^ 0xFFFFFFFF );
}


void monero_clear_words() {
  for (int i = 0; i<25; i++) {
c0d01760:	3614      	adds	r6, #20
c0d01762:	1e6d      	subs	r5, r5, #1
c0d01764:	d1f4      	bne.n	c0d01750 <monero_clear_words+0x8>
    monero_nvm_write(N_monero_pstate->words[i], NULL,WORDS_MAX_LENGTH);
  }
}
c0d01766:	bd70      	pop	{r4, r5, r6, pc}
c0d01768:	c0d07c00 	.word	0xc0d07c00

c0d0176c <monero_apdu_manage_seedwords>:
}

#define word_list_length 1626
#define seed G_monero_vstate.b

int monero_apdu_manage_seedwords() {
c0d0176c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0176e:	b087      	sub	sp, #28
  unsigned int w_start, w_end;
  unsigned short wc[4];
  switch (G_monero_vstate.io_p1) {
c0d01770:	4c7e      	ldr	r4, [pc, #504]	; (c0d0196c <monero_apdu_manage_seedwords+0x200>)
c0d01772:	7920      	ldrb	r0, [r4, #4]
c0d01774:	2802      	cmp	r0, #2
c0d01776:	d100      	bne.n	c0d0177a <monero_apdu_manage_seedwords+0xe>
c0d01778:	e0de      	b.n	c0d01938 <monero_apdu_manage_seedwords+0x1cc>
c0d0177a:	2801      	cmp	r0, #1
c0d0177c:	d000      	beq.n	c0d01780 <monero_apdu_manage_seedwords+0x14>
c0d0177e:	e0e0      	b.n	c0d01942 <monero_apdu_manage_seedwords+0x1d6>
    //SETUP
  case 1:
    w_start = monero_io_fetch_u32();
c0d01780:	f7ff ff76 	bl	c0d01670 <monero_io_fetch_u32>
c0d01784:	4606      	mov	r6, r0
    w_end   = w_start+monero_io_fetch_u32();
c0d01786:	f7ff ff73 	bl	c0d01670 <monero_io_fetch_u32>
c0d0178a:	1982      	adds	r2, r0, r6
c0d0178c:	4978      	ldr	r1, [pc, #480]	; (c0d01970 <monero_apdu_manage_seedwords+0x204>)
    if ((w_start >= word_list_length) || (w_end > word_list_length) || (w_start > w_end)) {
c0d0178e:	1c4b      	adds	r3, r1, #1
c0d01790:	9300      	str	r3, [sp, #0]
c0d01792:	9204      	str	r2, [sp, #16]
c0d01794:	4282      	cmp	r2, r0
c0d01796:	d200      	bcs.n	c0d0179a <monero_apdu_manage_seedwords+0x2e>
c0d01798:	e0e3      	b.n	c0d01962 <monero_apdu_manage_seedwords+0x1f6>
c0d0179a:	428e      	cmp	r6, r1
c0d0179c:	d900      	bls.n	c0d017a0 <monero_apdu_manage_seedwords+0x34>
c0d0179e:	e0e0      	b.n	c0d01962 <monero_apdu_manage_seedwords+0x1f6>
c0d017a0:	9804      	ldr	r0, [sp, #16]
c0d017a2:	9900      	ldr	r1, [sp, #0]
c0d017a4:	4288      	cmp	r0, r1
c0d017a6:	d900      	bls.n	c0d017aa <monero_apdu_manage_seedwords+0x3e>
c0d017a8:	e0db      	b.n	c0d01962 <monero_apdu_manage_seedwords+0x1f6>
c0d017aa:	2100      	movs	r1, #0
      THROW(SW_WRONG_DATA);
      return SW_WRONG_DATA;
    }
    for (int i = 0; i<8; i++) {
c0d017ac:	9603      	str	r6, [sp, #12]
c0d017ae:	9101      	str	r1, [sp, #4]
c0d017b0:	2061      	movs	r0, #97	; 0x61
c0d017b2:	0080      	lsls	r0, r0, #2
      unsigned int val = (seed[i*4+0]<<0) | (seed[i*4+1]<<8) | (seed[i*4+2]<<16) | (seed[i*4+3]<<24);
c0d017b4:	1820      	adds	r0, r4, r0
c0d017b6:	0089      	lsls	r1, r1, #2
c0d017b8:	5c42      	ldrb	r2, [r0, r1]
c0d017ba:	1c4b      	adds	r3, r1, #1
c0d017bc:	5cc3      	ldrb	r3, [r0, r3]
c0d017be:	021b      	lsls	r3, r3, #8
c0d017c0:	189a      	adds	r2, r3, r2
c0d017c2:	1c8b      	adds	r3, r1, #2
c0d017c4:	5cc3      	ldrb	r3, [r0, r3]
c0d017c6:	041b      	lsls	r3, r3, #16
c0d017c8:	18d2      	adds	r2, r2, r3
c0d017ca:	1cc9      	adds	r1, r1, #3
c0d017cc:	5c40      	ldrb	r0, [r0, r1]
c0d017ce:	0600      	lsls	r0, r0, #24
c0d017d0:	1815      	adds	r5, r2, r0
      wc[0] = val % word_list_length;
      wc[1] = ((val / word_list_length) +  wc[0]) % word_list_length;
c0d017d2:	9502      	str	r5, [sp, #8]
c0d017d4:	4628      	mov	r0, r5
c0d017d6:	4967      	ldr	r1, [pc, #412]	; (c0d01974 <monero_apdu_manage_seedwords+0x208>)
c0d017d8:	460e      	mov	r6, r1
c0d017da:	f004 fd4d 	bl	c0d06278 <__aeabi_uidiv>
c0d017de:	9900      	ldr	r1, [sp, #0]
c0d017e0:	4341      	muls	r1, r0
c0d017e2:	1a6f      	subs	r7, r5, r1
c0d017e4:	ad05      	add	r5, sp, #20
      THROW(SW_WRONG_DATA);
      return SW_WRONG_DATA;
    }
    for (int i = 0; i<8; i++) {
      unsigned int val = (seed[i*4+0]<<0) | (seed[i*4+1]<<8) | (seed[i*4+2]<<16) | (seed[i*4+3]<<24);
      wc[0] = val % word_list_length;
c0d017e6:	802f      	strh	r7, [r5, #0]
      wc[1] = ((val / word_list_length) +  wc[0]) % word_list_length;
c0d017e8:	19c0      	adds	r0, r0, r7
c0d017ea:	4631      	mov	r1, r6
c0d017ec:	f004 fdca 	bl	c0d06384 <__aeabi_uidivmod>
c0d017f0:	460e      	mov	r6, r1
c0d017f2:	8069      	strh	r1, [r5, #2]
      wc[2] = (((val / word_list_length) / word_list_length) +  wc[1]) % word_list_length;
c0d017f4:	9802      	ldr	r0, [sp, #8]
c0d017f6:	4960      	ldr	r1, [pc, #384]	; (c0d01978 <monero_apdu_manage_seedwords+0x20c>)
c0d017f8:	f004 fd3e 	bl	c0d06278 <__aeabi_uidiv>
c0d017fc:	1830      	adds	r0, r6, r0
c0d017fe:	9e03      	ldr	r6, [sp, #12]
c0d01800:	495c      	ldr	r1, [pc, #368]	; (c0d01974 <monero_apdu_manage_seedwords+0x208>)
c0d01802:	f004 fdbf 	bl	c0d06384 <__aeabi_uidivmod>
c0d01806:	80a9      	strh	r1, [r5, #4]
c0d01808:	2003      	movs	r0, #3
c0d0180a:	9901      	ldr	r1, [sp, #4]
c0d0180c:	4348      	muls	r0, r1
c0d0180e:	9002      	str	r0, [sp, #8]
c0d01810:	2500      	movs	r5, #0
c0d01812:	e002      	b.n	c0d0181a <monero_apdu_manage_seedwords+0xae>
c0d01814:	0068      	lsls	r0, r5, #1
c0d01816:	a905      	add	r1, sp, #20

      for (int wi = 0; wi < 3; wi++) {
        if ((wc[wi] >= w_start) && (wc[wi] < w_end)) {
c0d01818:	5a0f      	ldrh	r7, [r1, r0]
c0d0181a:	b2b9      	uxth	r1, r7
c0d0181c:	428e      	cmp	r6, r1
c0d0181e:	d82c      	bhi.n	c0d0187a <monero_apdu_manage_seedwords+0x10e>
c0d01820:	9804      	ldr	r0, [sp, #16]
c0d01822:	4288      	cmp	r0, r1
c0d01824:	d929      	bls.n	c0d0187a <monero_apdu_manage_seedwords+0x10e>
          monero_set_word(i*3+wi, wc[wi], w_start, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, MONERO_IO_BUFFER_LENGTH-G_monero_vstate.io_offset);
c0d01826:	9802      	ldr	r0, [sp, #8]
c0d01828:	1828      	adds	r0, r5, r0
c0d0182a:	8963      	ldrh	r3, [r4, #10]
c0d0182c:	224b      	movs	r2, #75	; 0x4b
c0d0182e:	0092      	lsls	r2, r2, #2
c0d01830:	1ad2      	subs	r2, r2, r3
c0d01832:	18e7      	adds	r7, r4, r3
c0d01834:	370e      	adds	r7, #14
c0d01836:	4633      	mov	r3, r6
 * word_list
 * len : word_list length
 */

static void  monero_set_word(unsigned int n, unsigned int idx, unsigned int w_start, unsigned char* word_list, int len) {
  while (w_start < idx) {
c0d01838:	428e      	cmp	r6, r1
c0d0183a:	d209      	bcs.n	c0d01850 <monero_apdu_manage_seedwords+0xe4>
    len -= 1 + word_list[0];
c0d0183c:	783e      	ldrb	r6, [r7, #0]
c0d0183e:	1c76      	adds	r6, r6, #1
c0d01840:	1b92      	subs	r2, r2, r6
    if (len < 0) {
c0d01842:	2a00      	cmp	r2, #0
c0d01844:	da00      	bge.n	c0d01848 <monero_apdu_manage_seedwords+0xdc>
c0d01846:	e080      	b.n	c0d0194a <monero_apdu_manage_seedwords+0x1de>
      monero_clear_words();
      THROW(SW_WRONG_DATA+1);
      return;
    }
    word_list += 1 + word_list[0];
c0d01848:	19bf      	adds	r7, r7, r6
    w_start++;
c0d0184a:	1c5b      	adds	r3, r3, #1
 * word_list
 * len : word_list length
 */

static void  monero_set_word(unsigned int n, unsigned int idx, unsigned int w_start, unsigned char* word_list, int len) {
  while (w_start < idx) {
c0d0184c:	428b      	cmp	r3, r1
c0d0184e:	d3f5      	bcc.n	c0d0183c <monero_apdu_manage_seedwords+0xd0>
    }
    word_list += 1 + word_list[0];
    w_start++;
  }

  if ((w_start != idx) || (word_list[0] > (len-1)) || (word_list[0] > 19)) {
c0d01850:	428b      	cmp	r3, r1
c0d01852:	d000      	beq.n	c0d01856 <monero_apdu_manage_seedwords+0xea>
c0d01854:	e080      	b.n	c0d01958 <monero_apdu_manage_seedwords+0x1ec>
c0d01856:	783e      	ldrb	r6, [r7, #0]
c0d01858:	2e13      	cmp	r6, #19
c0d0185a:	d87d      	bhi.n	c0d01958 <monero_apdu_manage_seedwords+0x1ec>
c0d0185c:	42b2      	cmp	r2, r6
c0d0185e:	dd7b      	ble.n	c0d01958 <monero_apdu_manage_seedwords+0x1ec>
c0d01860:	2414      	movs	r4, #20
    THROW(SW_WRONG_DATA+2);
    return;
  }
  len = word_list[0];
  word_list++;
  monero_nvm_write(N_monero_pstate->words[n], word_list, len);
c0d01862:	4344      	muls	r4, r0
c0d01864:	4845      	ldr	r0, [pc, #276]	; (c0d0197c <monero_apdu_manage_seedwords+0x210>)
c0d01866:	f002 ff7f 	bl	c0d04768 <pic>
c0d0186a:	1900      	adds	r0, r0, r4
c0d0186c:	304a      	adds	r0, #74	; 0x4a
  if ((w_start != idx) || (word_list[0] > (len-1)) || (word_list[0] > 19)) {
    THROW(SW_WRONG_DATA+2);
    return;
  }
  len = word_list[0];
  word_list++;
c0d0186e:	1c79      	adds	r1, r7, #1
  monero_nvm_write(N_monero_pstate->words[n], word_list, len);
c0d01870:	4632      	mov	r2, r6
c0d01872:	f002 ffbb 	bl	c0d047ec <nvm_write>
c0d01876:	4c3d      	ldr	r4, [pc, #244]	; (c0d0196c <monero_apdu_manage_seedwords+0x200>)
c0d01878:	9e03      	ldr	r6, [sp, #12]
      unsigned int val = (seed[i*4+0]<<0) | (seed[i*4+1]<<8) | (seed[i*4+2]<<16) | (seed[i*4+3]<<24);
      wc[0] = val % word_list_length;
      wc[1] = ((val / word_list_length) +  wc[0]) % word_list_length;
      wc[2] = (((val / word_list_length) / word_list_length) +  wc[1]) % word_list_length;

      for (int wi = 0; wi < 3; wi++) {
c0d0187a:	1c6d      	adds	r5, r5, #1
c0d0187c:	2d02      	cmp	r5, #2
c0d0187e:	d9c9      	bls.n	c0d01814 <monero_apdu_manage_seedwords+0xa8>
c0d01880:	9901      	ldr	r1, [sp, #4]
    w_end   = w_start+monero_io_fetch_u32();
    if ((w_start >= word_list_length) || (w_end > word_list_length) || (w_start > w_end)) {
      THROW(SW_WRONG_DATA);
      return SW_WRONG_DATA;
    }
    for (int i = 0; i<8; i++) {
c0d01882:	1c49      	adds	r1, r1, #1
c0d01884:	2908      	cmp	r1, #8
c0d01886:	d392      	bcc.n	c0d017ae <monero_apdu_manage_seedwords+0x42>
c0d01888:	2001      	movs	r0, #1
          monero_set_word(i*3+wi, wc[wi], w_start, G_monero_vstate.io_buffer+G_monero_vstate.io_offset, MONERO_IO_BUFFER_LENGTH-G_monero_vstate.io_offset);
        }
      }
    }

    monero_io_discard(1);
c0d0188a:	f7ff fdf3 	bl	c0d01474 <monero_io_discard>
    if (G_monero_vstate.io_p2) {
c0d0188e:	7963      	ldrb	r3, [r4, #5]
c0d01890:	2b00      	cmp	r3, #0
c0d01892:	d056      	beq.n	c0d01942 <monero_apdu_manage_seedwords+0x1d6>
c0d01894:	2700      	movs	r7, #0
c0d01896:	224a      	movs	r2, #74	; 0x4a
c0d01898:	4e38      	ldr	r6, [pc, #224]	; (c0d0197c <monero_apdu_manage_seedwords+0x210>)
      for (int i = 0; i<24; i++) {
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
c0d0189a:	4619      	mov	r1, r3
c0d0189c:	9703      	str	r7, [sp, #12]
c0d0189e:	9704      	str	r7, [sp, #16]
c0d018a0:	0609      	lsls	r1, r1, #24
c0d018a2:	9903      	ldr	r1, [sp, #12]
c0d018a4:	4f31      	ldr	r7, [pc, #196]	; (c0d0196c <monero_apdu_manage_seedwords+0x200>)
c0d018a6:	4614      	mov	r4, r2
c0d018a8:	d010      	beq.n	c0d018cc <monero_apdu_manage_seedwords+0x160>
c0d018aa:	2500      	movs	r5, #0
          G_monero_vstate.io_buffer[i*G_monero_vstate.io_p2+j] = N_monero_pstate->words[i][j];
c0d018ac:	4630      	mov	r0, r6
c0d018ae:	f002 ff5b 	bl	c0d04768 <pic>
c0d018b2:	1900      	adds	r0, r0, r4
c0d018b4:	5d41      	ldrb	r1, [r0, r5]
c0d018b6:	797b      	ldrb	r3, [r7, #5]
c0d018b8:	461a      	mov	r2, r3
c0d018ba:	9804      	ldr	r0, [sp, #16]
c0d018bc:	4342      	muls	r2, r0
c0d018be:	18ba      	adds	r2, r7, r2
c0d018c0:	1952      	adds	r2, r2, r5
c0d018c2:	7391      	strb	r1, [r2, #14]
    }

    monero_io_discard(1);
    if (G_monero_vstate.io_p2) {
      for (int i = 0; i<24; i++) {
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
c0d018c4:	1c6d      	adds	r5, r5, #1
c0d018c6:	429d      	cmp	r5, r3
c0d018c8:	4619      	mov	r1, r3
c0d018ca:	d3ef      	bcc.n	c0d018ac <monero_apdu_manage_seedwords+0x140>
c0d018cc:	4622      	mov	r2, r4
      }
    }

    monero_io_discard(1);
    if (G_monero_vstate.io_p2) {
      for (int i = 0; i<24; i++) {
c0d018ce:	3214      	adds	r2, #20
c0d018d0:	9c04      	ldr	r4, [sp, #16]
c0d018d2:	1c64      	adds	r4, r4, #1
c0d018d4:	2c18      	cmp	r4, #24
c0d018d6:	4627      	mov	r7, r4
c0d018d8:	d1e1      	bne.n	c0d0189e <monero_apdu_manage_seedwords+0x132>
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
          G_monero_vstate.io_buffer[i*G_monero_vstate.io_p2+j] = N_monero_pstate->words[i][j];
        }
      }
      w_start = monero_crc32(0, G_monero_vstate.io_buffer, G_monero_vstate.io_p2*24)%24;
c0d018da:	b2d9      	uxtb	r1, r3
c0d018dc:	2018      	movs	r0, #24
c0d018de:	4348      	muls	r0, r1
c0d018e0:	2400      	movs	r4, #0
    size_t i;

    /** accumulate crc32 for buffer **/
    crc32 = inCrc32 ^ 0xFFFFFFFF;
    byteBuf = (unsigned char*) buf;
    for (i=0; i < bufLen; i++) {
c0d018e2:	2900      	cmp	r1, #0
c0d018e4:	d016      	beq.n	c0d01914 <monero_apdu_manage_seedwords+0x1a8>
c0d018e6:	2100      	movs	r1, #0
c0d018e8:	43c9      	mvns	r1, r1
c0d018ea:	4c20      	ldr	r4, [pc, #128]	; (c0d0196c <monero_apdu_manage_seedwords+0x200>)
c0d018ec:	340e      	adds	r4, #14
c0d018ee:	4a25      	ldr	r2, [pc, #148]	; (c0d01984 <monero_apdu_manage_seedwords+0x218>)
c0d018f0:	447a      	add	r2, pc
        crc32 = (crc32 >> 8) ^ crcTable[ (crc32 ^ byteBuf[i]) & 0xFF ];
c0d018f2:	7823      	ldrb	r3, [r4, #0]
c0d018f4:	4625      	mov	r5, r4
c0d018f6:	b2cc      	uxtb	r4, r1
c0d018f8:	405c      	eors	r4, r3
c0d018fa:	00a3      	lsls	r3, r4, #2
c0d018fc:	462c      	mov	r4, r5
c0d018fe:	58d3      	ldr	r3, [r2, r3]
c0d01900:	0a09      	lsrs	r1, r1, #8
c0d01902:	4059      	eors	r1, r3
    size_t i;

    /** accumulate crc32 for buffer **/
    crc32 = inCrc32 ^ 0xFFFFFFFF;
    byteBuf = (unsigned char*) buf;
    for (i=0; i < bufLen; i++) {
c0d01904:	1c6c      	adds	r4, r5, #1
c0d01906:	1e40      	subs	r0, r0, #1
c0d01908:	d1f3      	bne.n	c0d018f2 <monero_apdu_manage_seedwords+0x186>
        crc32 = (crc32 >> 8) ^ crcTable[ (crc32 ^ byteBuf[i]) & 0xFF ];
    }
    return( crc32 ^ 0xFFFFFFFF );
c0d0190a:	43c8      	mvns	r0, r1
c0d0190c:	2118      	movs	r1, #24
c0d0190e:	f004 fd39 	bl	c0d06384 <__aeabi_uidivmod>
c0d01912:	460c      	mov	r4, r1
        for (int j = 0; j<G_monero_vstate.io_p2; j++) {
          G_monero_vstate.io_buffer[i*G_monero_vstate.io_p2+j] = N_monero_pstate->words[i][j];
        }
      }
      w_start = monero_crc32(0, G_monero_vstate.io_buffer, G_monero_vstate.io_p2*24)%24;
      monero_nvm_write(N_monero_pstate->words[24], N_monero_pstate->words[w_start], WORDS_MAX_LENGTH);
c0d01914:	4d19      	ldr	r5, [pc, #100]	; (c0d0197c <monero_apdu_manage_seedwords+0x210>)
c0d01916:	4628      	mov	r0, r5
c0d01918:	f002 ff26 	bl	c0d04768 <pic>
c0d0191c:	4918      	ldr	r1, [pc, #96]	; (c0d01980 <monero_apdu_manage_seedwords+0x214>)
c0d0191e:	1846      	adds	r6, r0, r1
c0d01920:	2714      	movs	r7, #20
c0d01922:	437c      	muls	r4, r7
c0d01924:	4628      	mov	r0, r5
c0d01926:	f002 ff1f 	bl	c0d04768 <pic>
c0d0192a:	1901      	adds	r1, r0, r4
c0d0192c:	314a      	adds	r1, #74	; 0x4a
c0d0192e:	4630      	mov	r0, r6
c0d01930:	463a      	mov	r2, r7
c0d01932:	f002 ff5b 	bl	c0d047ec <nvm_write>
c0d01936:	e004      	b.n	c0d01942 <monero_apdu_manage_seedwords+0x1d6>
c0d01938:	2000      	movs	r0, #0

    break;

    //CLEAR
  case 2:
    monero_io_discard(0);
c0d0193a:	f7ff fd9b 	bl	c0d01474 <monero_io_discard>
    monero_clear_words();
c0d0193e:	f7ff ff03 	bl	c0d01748 <monero_clear_words>
c0d01942:	2009      	movs	r0, #9
c0d01944:	0300      	lsls	r0, r0, #12
    break;
  }

 return SW_OK;
c0d01946:	b007      	add	sp, #28
c0d01948:	bdf0      	pop	{r4, r5, r6, r7, pc}

static void  monero_set_word(unsigned int n, unsigned int idx, unsigned int w_start, unsigned char* word_list, int len) {
  while (w_start < idx) {
    len -= 1 + word_list[0];
    if (len < 0) {
      monero_clear_words();
c0d0194a:	f7ff fefd 	bl	c0d01748 <monero_clear_words>
c0d0194e:	20d5      	movs	r0, #213	; 0xd5
c0d01950:	01c0      	lsls	r0, r0, #7
      THROW(SW_WRONG_DATA+1);
c0d01952:	1c40      	adds	r0, r0, #1
c0d01954:	f002 f8ea 	bl	c0d03b2c <os_longjmp>
c0d01958:	20d5      	movs	r0, #213	; 0xd5
c0d0195a:	01c0      	lsls	r0, r0, #7
    word_list += 1 + word_list[0];
    w_start++;
  }

  if ((w_start != idx) || (word_list[0] > (len-1)) || (word_list[0] > 19)) {
    THROW(SW_WRONG_DATA+2);
c0d0195c:	1c80      	adds	r0, r0, #2
c0d0195e:	f002 f8e5 	bl	c0d03b2c <os_longjmp>
c0d01962:	20d5      	movs	r0, #213	; 0xd5
c0d01964:	01c0      	lsls	r0, r0, #7
    //SETUP
  case 1:
    w_start = monero_io_fetch_u32();
    w_end   = w_start+monero_io_fetch_u32();
    if ((w_start >= word_list_length) || (w_end > word_list_length) || (w_start > w_end)) {
      THROW(SW_WRONG_DATA);
c0d01966:	f002 f8e1 	bl	c0d03b2c <os_longjmp>
c0d0196a:	46c0      	nop			; (mov r8, r8)
c0d0196c:	20001930 	.word	0x20001930
c0d01970:	00000659 	.word	0x00000659
c0d01974:	0000065a 	.word	0x0000065a
c0d01978:	002857a4 	.word	0x002857a4
c0d0197c:	c0d07c00 	.word	0xc0d07c00
c0d01980:	0000022a 	.word	0x0000022a
c0d01984:	00005120 	.word	0x00005120

c0d01988 <monero_apdu_put_key>:
#undef word_list_length

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_put_key() {
c0d01988:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0198a:	b099      	sub	sp, #100	; 0x64

  unsigned char raw[32];
  unsigned char pub[32];
  unsigned char sec[32];

  if (G_monero_vstate.io_length != (32*2 + 32*2 + 95)) {
c0d0198c:	482e      	ldr	r0, [pc, #184]	; (c0d01a48 <monero_apdu_put_key+0xc0>)
c0d0198e:	8900      	ldrh	r0, [r0, #8]
c0d01990:	28df      	cmp	r0, #223	; 0xdf
c0d01992:	d155      	bne.n	c0d01a40 <monero_apdu_put_key+0xb8>
c0d01994:	ad01      	add	r5, sp, #4
c0d01996:	2420      	movs	r4, #32
    THROW(SW_WRONG_LENGTH);
    return SW_WRONG_LENGTH;
  }

  //view key
  monero_io_fetch(sec, 32);
c0d01998:	4628      	mov	r0, r5
c0d0199a:	4621      	mov	r1, r4
c0d0199c:	f7ff fdf8 	bl	c0d01590 <monero_io_fetch>
c0d019a0:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch(pub, 32);
c0d019a2:	4630      	mov	r0, r6
c0d019a4:	4621      	mov	r1, r4
c0d019a6:	f7ff fdf3 	bl	c0d01590 <monero_io_fetch>
c0d019aa:	af11      	add	r7, sp, #68	; 0x44
  monero_ecmul_G(raw,sec);
c0d019ac:	4638      	mov	r0, r7
c0d019ae:	4629      	mov	r1, r5
c0d019b0:	f7fe ff44 	bl	c0d0083c <monero_ecmul_G>
  if (os_memcmp(pub, raw, 32)) {
c0d019b4:	4630      	mov	r0, r6
c0d019b6:	4639      	mov	r1, r7
c0d019b8:	4622      	mov	r2, r4
c0d019ba:	f002 f8a3 	bl	c0d03b04 <os_memcmp>
c0d019be:	2800      	cmp	r0, #0
c0d019c0:	d13a      	bne.n	c0d01a38 <monero_apdu_put_key+0xb0>
    THROW(SW_WRONG_DATA);
    return SW_WRONG_DATA;
  }
  nvm_write(N_monero_pstate->a, sec, 32);
c0d019c2:	4822      	ldr	r0, [pc, #136]	; (c0d01a4c <monero_apdu_put_key+0xc4>)
c0d019c4:	f002 fed0 	bl	c0d04768 <pic>
c0d019c8:	300a      	adds	r0, #10
c0d019ca:	ad01      	add	r5, sp, #4
c0d019cc:	2420      	movs	r4, #32
c0d019ce:	4629      	mov	r1, r5
c0d019d0:	4622      	mov	r2, r4
c0d019d2:	f002 ff0b 	bl	c0d047ec <nvm_write>

  //spend key
  monero_io_fetch(sec, 32);
c0d019d6:	4628      	mov	r0, r5
c0d019d8:	4621      	mov	r1, r4
c0d019da:	f7ff fdd9 	bl	c0d01590 <monero_io_fetch>
c0d019de:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch(pub, 32);
c0d019e0:	4630      	mov	r0, r6
c0d019e2:	4621      	mov	r1, r4
c0d019e4:	f7ff fdd4 	bl	c0d01590 <monero_io_fetch>
c0d019e8:	af11      	add	r7, sp, #68	; 0x44
  monero_ecmul_G(raw,sec);
c0d019ea:	4638      	mov	r0, r7
c0d019ec:	4629      	mov	r1, r5
c0d019ee:	f7fe ff25 	bl	c0d0083c <monero_ecmul_G>
  if (os_memcmp(pub, raw, 32)) {
c0d019f2:	4630      	mov	r0, r6
c0d019f4:	4639      	mov	r1, r7
c0d019f6:	4622      	mov	r2, r4
c0d019f8:	f002 f884 	bl	c0d03b04 <os_memcmp>
c0d019fc:	2800      	cmp	r0, #0
c0d019fe:	d11b      	bne.n	c0d01a38 <monero_apdu_put_key+0xb0>
    THROW(SW_WRONG_DATA);
    return SW_WRONG_DATA;
  }
  nvm_write(N_monero_pstate->b, sec, 32);
c0d01a00:	4c12      	ldr	r4, [pc, #72]	; (c0d01a4c <monero_apdu_put_key+0xc4>)
c0d01a02:	4620      	mov	r0, r4
c0d01a04:	f002 feb0 	bl	c0d04768 <pic>
c0d01a08:	302a      	adds	r0, #42	; 0x2a
c0d01a0a:	a901      	add	r1, sp, #4
c0d01a0c:	2220      	movs	r2, #32
c0d01a0e:	f002 feed 	bl	c0d047ec <nvm_write>
c0d01a12:	466d      	mov	r5, sp
c0d01a14:	2021      	movs	r0, #33	; 0x21


  //change mode
  unsigned char key_mode = KEY_MODE_EXTERNAL;
c0d01a16:	7028      	strb	r0, [r5, #0]
  nvm_write(&N_monero_pstate->key_mode, &key_mode, 1);
c0d01a18:	4620      	mov	r0, r4
c0d01a1a:	f002 fea5 	bl	c0d04768 <pic>
c0d01a1e:	3009      	adds	r0, #9
c0d01a20:	2401      	movs	r4, #1
c0d01a22:	4629      	mov	r1, r5
c0d01a24:	4622      	mov	r2, r4
c0d01a26:	f002 fee1 	bl	c0d047ec <nvm_write>

  monero_io_discard(1);
c0d01a2a:	4620      	mov	r0, r4
c0d01a2c:	f7ff fd22 	bl	c0d01474 <monero_io_discard>
c0d01a30:	2009      	movs	r0, #9
c0d01a32:	0300      	lsls	r0, r0, #12

  return SW_OK;
c0d01a34:	b019      	add	sp, #100	; 0x64
c0d01a36:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01a38:	20d5      	movs	r0, #213	; 0xd5
c0d01a3a:	01c0      	lsls	r0, r0, #7
c0d01a3c:	f002 f876 	bl	c0d03b2c <os_longjmp>
c0d01a40:	2067      	movs	r0, #103	; 0x67
c0d01a42:	0200      	lsls	r0, r0, #8
  unsigned char raw[32];
  unsigned char pub[32];
  unsigned char sec[32];

  if (G_monero_vstate.io_length != (32*2 + 32*2 + 95)) {
    THROW(SW_WRONG_LENGTH);
c0d01a44:	f002 f872 	bl	c0d03b2c <os_longjmp>
c0d01a48:	20001930 	.word	0x20001930
c0d01a4c:	c0d07c00 	.word	0xc0d07c00

c0d01a50 <monero_apdu_get_key>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_key() {
c0d01a50:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01a52:	b081      	sub	sp, #4
c0d01a54:	2001      	movs	r0, #1

  monero_io_discard(1);
c0d01a56:	f7ff fd0d 	bl	c0d01474 <monero_io_discard>
  switch (G_monero_vstate.io_p1) {
c0d01a5a:	4f16      	ldr	r7, [pc, #88]	; (c0d01ab4 <monero_apdu_get_key+0x64>)
c0d01a5c:	7938      	ldrb	r0, [r7, #4]
c0d01a5e:	2802      	cmp	r0, #2
c0d01a60:	d01e      	beq.n	c0d01aa0 <monero_apdu_get_key+0x50>
c0d01a62:	2801      	cmp	r0, #1
c0d01a64:	d121      	bne.n	c0d01aaa <monero_apdu_get_key+0x5a>
c0d01a66:	2059      	movs	r0, #89	; 0x59
c0d01a68:	0080      	lsls	r0, r0, #2
  //get pub
  case 1:
    //view key
    monero_io_insert(G_monero_vstate.A, 32);
c0d01a6a:	183c      	adds	r4, r7, r0
c0d01a6c:	2520      	movs	r5, #32
c0d01a6e:	4620      	mov	r0, r4
c0d01a70:	4629      	mov	r1, r5
c0d01a72:	f7ff fd2b 	bl	c0d014cc <monero_io_insert>
c0d01a76:	2069      	movs	r0, #105	; 0x69
c0d01a78:	0080      	lsls	r0, r0, #2
    //spend key
    monero_io_insert(G_monero_vstate.B, 32);
c0d01a7a:	183e      	adds	r6, r7, r0
c0d01a7c:	4630      	mov	r0, r6
c0d01a7e:	4629      	mov	r1, r5
c0d01a80:	f7ff fd24 	bl	c0d014cc <monero_io_insert>
    //public base address
    monero_base58_public_key((char*)G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.A, G_monero_vstate.B, 0);
c0d01a84:	8978      	ldrh	r0, [r7, #10]
c0d01a86:	1838      	adds	r0, r7, r0
c0d01a88:	300e      	adds	r0, #14
c0d01a8a:	2300      	movs	r3, #0
c0d01a8c:	4621      	mov	r1, r4
c0d01a8e:	4632      	mov	r2, r6
c0d01a90:	f000 ff1c 	bl	c0d028cc <monero_base58_public_key>
c0d01a94:	205f      	movs	r0, #95	; 0x5f
    monero_io_inserted(95);
c0d01a96:	f7ff fce3 	bl	c0d01460 <monero_io_inserted>
c0d01a9a:	2009      	movs	r0, #9
c0d01a9c:	0300      	lsls	r0, r0, #12
c0d01a9e:	e002      	b.n	c0d01aa6 <monero_apdu_get_key+0x56>
    break;

  //get private
  case 2:
    //view key
    ui_export_viewkey_display();
c0d01aa0:	f001 fc28 	bl	c0d032f4 <ui_export_viewkey_display>
c0d01aa4:	2000      	movs	r0, #0
  default:
    THROW(SW_WRONG_P1P2);
    return SW_WRONG_P1P2;
  }
  return SW_OK;
}
c0d01aa6:	b001      	add	sp, #4
c0d01aa8:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d01aaa:	206b      	movs	r0, #107	; 0x6b
c0d01aac:	0200      	lsls	r0, r0, #8
    break;
    }
    #endif

  default:
    THROW(SW_WRONG_P1P2);
c0d01aae:	f002 f83d 	bl	c0d03b2c <os_longjmp>
c0d01ab2:	46c0      	nop			; (mov r8, r8)
c0d01ab4:	20001930 	.word	0x20001930

c0d01ab8 <monero_apdu_verify_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_verify_key() {
c0d01ab8:	b510      	push	{r4, lr}
c0d01aba:	b098      	sub	sp, #96	; 0x60
c0d01abc:	a808      	add	r0, sp, #32
  unsigned char pub[32];
  unsigned char priv[32];
  unsigned char computed_pub[32];
  unsigned int verified = 0;

  monero_io_fetch_decrypt_key(priv);
c0d01abe:	f7ff fda5 	bl	c0d0160c <monero_io_fetch_decrypt_key>
c0d01ac2:	a810      	add	r0, sp, #64	; 0x40
c0d01ac4:	2120      	movs	r1, #32
  monero_io_fetch(pub, 32);
c0d01ac6:	f7ff fd63 	bl	c0d01590 <monero_io_fetch>
  switch (G_monero_vstate.io_p1) {
c0d01aca:	4816      	ldr	r0, [pc, #88]	; (c0d01b24 <monero_apdu_verify_key+0x6c>)
c0d01acc:	7901      	ldrb	r1, [r0, #4]
c0d01ace:	2902      	cmp	r1, #2
c0d01ad0:	d00a      	beq.n	c0d01ae8 <monero_apdu_verify_key+0x30>
c0d01ad2:	2901      	cmp	r1, #1
c0d01ad4:	d006      	beq.n	c0d01ae4 <monero_apdu_verify_key+0x2c>
c0d01ad6:	2900      	cmp	r1, #0
c0d01ad8:	d120      	bne.n	c0d01b1c <monero_apdu_verify_key+0x64>
c0d01ada:	4668      	mov	r0, sp
c0d01adc:	a908      	add	r1, sp, #32
  case 0:
    monero_secret_key_to_public_key(computed_pub, priv);
c0d01ade:	f7fe ffb1 	bl	c0d00a44 <monero_secret_key_to_public_key>
c0d01ae2:	e008      	b.n	c0d01af6 <monero_apdu_verify_key+0x3e>
c0d01ae4:	2159      	movs	r1, #89	; 0x59
c0d01ae6:	e000      	b.n	c0d01aea <monero_apdu_verify_key+0x32>
c0d01ae8:	2169      	movs	r1, #105	; 0x69
c0d01aea:	0089      	lsls	r1, r1, #2
c0d01aec:	1841      	adds	r1, r0, r1
c0d01aee:	a810      	add	r0, sp, #64	; 0x40
c0d01af0:	2220      	movs	r2, #32
c0d01af2:	f001 ff4c 	bl	c0d0398e <os_memmove>
c0d01af6:	4668      	mov	r0, sp
c0d01af8:	a910      	add	r1, sp, #64	; 0x40
c0d01afa:	2220      	movs	r2, #32
    break;
  default:
    THROW(SW_WRONG_P1P2);
    return SW_WRONG_P1P2;
  }
  if (os_memcmp(computed_pub, pub, 32) ==0 ) {
c0d01afc:	f002 f802 	bl	c0d03b04 <os_memcmp>
c0d01b00:	4604      	mov	r4, r0
c0d01b02:	2001      	movs	r0, #1
    verified = 1;
  }

  monero_io_discard(1);
c0d01b04:	f7ff fcb6 	bl	c0d01474 <monero_io_discard>
c0d01b08:	2000      	movs	r0, #0
    break;
  default:
    THROW(SW_WRONG_P1P2);
    return SW_WRONG_P1P2;
  }
  if (os_memcmp(computed_pub, pub, 32) ==0 ) {
c0d01b0a:	1b00      	subs	r0, r0, r4
c0d01b0c:	4144      	adcs	r4, r0
    verified = 1;
  }

  monero_io_discard(1);
  monero_io_insert_u32(verified);
c0d01b0e:	4620      	mov	r0, r4
c0d01b10:	f7ff fd0c 	bl	c0d0152c <monero_io_insert_u32>
c0d01b14:	2009      	movs	r0, #9
c0d01b16:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01b18:	b018      	add	sp, #96	; 0x60
c0d01b1a:	bd10      	pop	{r4, pc}
c0d01b1c:	206b      	movs	r0, #107	; 0x6b
c0d01b1e:	0200      	lsls	r0, r0, #8
    break;
  case 2:
    os_memmove(pub, G_monero_vstate.B, 32);
    break;
  default:
    THROW(SW_WRONG_P1P2);
c0d01b20:	f002 f804 	bl	c0d03b2c <os_longjmp>
c0d01b24:	20001930 	.word	0x20001930

c0d01b28 <monero_apdu_get_chacha8_prekey>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
#define CHACHA8_KEY_TAIL 0x8c
int monero_apdu_get_chacha8_prekey(/*char  *prekey*/) {
c0d01b28:	b570      	push	{r4, r5, r6, lr}
c0d01b2a:	b09a      	sub	sp, #104	; 0x68
c0d01b2c:	2000      	movs	r0, #0
  unsigned char abt[65];
  unsigned char pre[32];

  monero_io_discard(0);
c0d01b2e:	f7ff fca1 	bl	c0d01474 <monero_io_discard>
c0d01b32:	2051      	movs	r0, #81	; 0x51
c0d01b34:	0080      	lsls	r0, r0, #2
  os_memmove(abt, G_monero_vstate.a, 32);
c0d01b36:	4e14      	ldr	r6, [pc, #80]	; (c0d01b88 <monero_apdu_get_chacha8_prekey+0x60>)
c0d01b38:	1831      	adds	r1, r6, r0
c0d01b3a:	ac09      	add	r4, sp, #36	; 0x24
c0d01b3c:	2520      	movs	r5, #32
c0d01b3e:	4620      	mov	r0, r4
c0d01b40:	462a      	mov	r2, r5
c0d01b42:	f001 ff24 	bl	c0d0398e <os_memmove>
c0d01b46:	2061      	movs	r0, #97	; 0x61
c0d01b48:	0080      	lsls	r0, r0, #2
  os_memmove(abt+32, G_monero_vstate.b, 32);
c0d01b4a:	1831      	adds	r1, r6, r0
c0d01b4c:	4620      	mov	r0, r4
c0d01b4e:	3020      	adds	r0, #32
c0d01b50:	462a      	mov	r2, r5
c0d01b52:	f001 ff1c 	bl	c0d0398e <os_memmove>
c0d01b56:	2040      	movs	r0, #64	; 0x40
c0d01b58:	218c      	movs	r1, #140	; 0x8c
  abt[64] = CHACHA8_KEY_TAIL;
c0d01b5a:	5421      	strb	r1, [r4, r0]
c0d01b5c:	a801      	add	r0, sp, #4
  monero_keccak_F(abt, 65, pre);
c0d01b5e:	4669      	mov	r1, sp
c0d01b60:	6008      	str	r0, [r1, #0]
c0d01b62:	2023      	movs	r0, #35	; 0x23
c0d01b64:	0100      	lsls	r0, r0, #4
c0d01b66:	1831      	adds	r1, r6, r0
c0d01b68:	2006      	movs	r0, #6
c0d01b6a:	2341      	movs	r3, #65	; 0x41
c0d01b6c:	4622      	mov	r2, r4
c0d01b6e:	f7fe fbad 	bl	c0d002cc <monero_hash>
c0d01b72:	2031      	movs	r0, #49	; 0x31
c0d01b74:	0100      	lsls	r0, r0, #4
  monero_io_insert((unsigned char*)G_monero_vstate.keccakF.acc, 200);
c0d01b76:	1830      	adds	r0, r6, r0
c0d01b78:	21c8      	movs	r1, #200	; 0xc8
c0d01b7a:	f7ff fca7 	bl	c0d014cc <monero_io_insert>
c0d01b7e:	2009      	movs	r0, #9
c0d01b80:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01b82:	b01a      	add	sp, #104	; 0x68
c0d01b84:	bd70      	pop	{r4, r5, r6, pc}
c0d01b86:	46c0      	nop			; (mov r8, r8)
c0d01b88:	20001930 	.word	0x20001930

c0d01b8c <monero_apdu_sc_add>:
#undef CHACHA8_KEY_TAIL

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_sc_add(/*unsigned char *r, unsigned char *s1, unsigned char *s2*/) {
c0d01b8c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01b8e:	b099      	sub	sp, #100	; 0x64
c0d01b90:	ad11      	add	r5, sp, #68	; 0x44
c0d01b92:	2420      	movs	r4, #32
  unsigned char s1[32];
  unsigned char s2[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch_decrypt(s1,32);
c0d01b94:	4628      	mov	r0, r5
c0d01b96:	4621      	mov	r1, r4
c0d01b98:	f7ff fd16 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01b9c:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(s2,32);
c0d01b9e:	4630      	mov	r0, r6
c0d01ba0:	4621      	mov	r1, r4
c0d01ba2:	f7ff fd11 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01ba6:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01ba8:	f7ff fc64 	bl	c0d01474 <monero_io_discard>
c0d01bac:	af01      	add	r7, sp, #4
  monero_addm(r,s1,s2);
c0d01bae:	4638      	mov	r0, r7
c0d01bb0:	4629      	mov	r1, r5
c0d01bb2:	4632      	mov	r2, r6
c0d01bb4:	f7fe fecc 	bl	c0d00950 <monero_addm>
  monero_io_insert_encrypt(r,32);
c0d01bb8:	4638      	mov	r0, r7
c0d01bba:	4621      	mov	r1, r4
c0d01bbc:	f7ff fc9a 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01bc0:	2009      	movs	r0, #9
c0d01bc2:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01bc4:	b019      	add	sp, #100	; 0x64
c0d01bc6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01bc8 <monero_apdu_sc_sub>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_sc_sub(/*unsigned char *r, unsigned char *s1, unsigned char *s2*/) {
c0d01bc8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01bca:	b099      	sub	sp, #100	; 0x64
c0d01bcc:	ad11      	add	r5, sp, #68	; 0x44
c0d01bce:	2420      	movs	r4, #32
  unsigned char s1[32];
  unsigned char s2[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch_decrypt(s1,32);
c0d01bd0:	4628      	mov	r0, r5
c0d01bd2:	4621      	mov	r1, r4
c0d01bd4:	f7ff fcf8 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01bd8:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(s2,32);
c0d01bda:	4630      	mov	r0, r6
c0d01bdc:	4621      	mov	r1, r4
c0d01bde:	f7ff fcf3 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01be2:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01be4:	f7ff fc46 	bl	c0d01474 <monero_io_discard>
c0d01be8:	af01      	add	r7, sp, #4
  monero_subm(r,s1,s2);
c0d01bea:	4638      	mov	r0, r7
c0d01bec:	4629      	mov	r1, r5
c0d01bee:	4632      	mov	r2, r6
c0d01bf0:	f7ff f8d4 	bl	c0d00d9c <monero_subm>
  monero_io_insert_encrypt(r,32);
c0d01bf4:	4638      	mov	r0, r7
c0d01bf6:	4621      	mov	r1, r4
c0d01bf8:	f7ff fc7c 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01bfc:	2009      	movs	r0, #9
c0d01bfe:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c00:	b019      	add	sp, #100	; 0x64
c0d01c02:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01c04 <monero_apdu_scal_mul_key>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_scal_mul_key(/*const rct::key &pub, const rct::key &sec, rct::key mulkey*/) {
c0d01c04:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01c06:	b099      	sub	sp, #100	; 0x64
c0d01c08:	ad11      	add	r5, sp, #68	; 0x44
c0d01c0a:	2420      	movs	r4, #32
  unsigned char pub[32];
  unsigned char sec[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch(pub,32);
c0d01c0c:	4628      	mov	r0, r5
c0d01c0e:	4621      	mov	r1, r4
c0d01c10:	f7ff fcbe 	bl	c0d01590 <monero_io_fetch>
c0d01c14:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(sec,32);
c0d01c16:	4630      	mov	r0, r6
c0d01c18:	4621      	mov	r1, r4
c0d01c1a:	f7ff fcd5 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01c1e:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01c20:	f7ff fc28 	bl	c0d01474 <monero_io_discard>
c0d01c24:	af01      	add	r7, sp, #4

  monero_ecmul_k(r,pub,sec);
c0d01c26:	4638      	mov	r0, r7
c0d01c28:	4629      	mov	r1, r5
c0d01c2a:	4632      	mov	r2, r6
c0d01c2c:	f7fe ff1d 	bl	c0d00a6a <monero_ecmul_k>
  monero_io_insert(r, 32);
c0d01c30:	4638      	mov	r0, r7
c0d01c32:	4621      	mov	r1, r4
c0d01c34:	f7ff fc4a 	bl	c0d014cc <monero_io_insert>
c0d01c38:	2009      	movs	r0, #9
c0d01c3a:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c3c:	b019      	add	sp, #100	; 0x64
c0d01c3e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01c40 <monero_apdu_scal_mul_base>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_scal_mul_base(/*const rct::key &sec, rct::key mulkey*/) {
c0d01c40:	b570      	push	{r4, r5, r6, lr}
c0d01c42:	b090      	sub	sp, #64	; 0x40
c0d01c44:	ad08      	add	r5, sp, #32
c0d01c46:	2420      	movs	r4, #32
  unsigned char sec[32];
  unsigned char r[32];
  //fetch
  monero_io_fetch_decrypt(sec,32);
c0d01c48:	4628      	mov	r0, r5
c0d01c4a:	4621      	mov	r1, r4
c0d01c4c:	f7ff fcbc 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01c50:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01c52:	f7ff fc0f 	bl	c0d01474 <monero_io_discard>
c0d01c56:	466e      	mov	r6, sp

  monero_ecmul_G(r,sec);
c0d01c58:	4630      	mov	r0, r6
c0d01c5a:	4629      	mov	r1, r5
c0d01c5c:	f7fe fdee 	bl	c0d0083c <monero_ecmul_G>
  monero_io_insert(r, 32);
c0d01c60:	4630      	mov	r0, r6
c0d01c62:	4621      	mov	r1, r4
c0d01c64:	f7ff fc32 	bl	c0d014cc <monero_io_insert>
c0d01c68:	2009      	movs	r0, #9
c0d01c6a:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c6c:	b010      	add	sp, #64	; 0x40
c0d01c6e:	bd70      	pop	{r4, r5, r6, pc}

c0d01c70 <monero_apdu_generate_keypair>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_keypair(/*crypto::public_key &pub, crypto::secret_key &sec*/) {
c0d01c70:	b570      	push	{r4, r5, r6, lr}
c0d01c72:	b090      	sub	sp, #64	; 0x40
c0d01c74:	2000      	movs	r0, #0
  unsigned char sec[32];
  unsigned char pub[32];

  monero_io_discard(0);
c0d01c76:	f7ff fbfd 	bl	c0d01474 <monero_io_discard>
c0d01c7a:	466c      	mov	r4, sp
c0d01c7c:	ad08      	add	r5, sp, #32
  monero_generate_keypair(pub,sec);
c0d01c7e:	4620      	mov	r0, r4
c0d01c80:	4629      	mov	r1, r5
c0d01c82:	f7fe fdcb 	bl	c0d0081c <monero_generate_keypair>
c0d01c86:	2620      	movs	r6, #32
  monero_io_insert(pub,32);
c0d01c88:	4620      	mov	r0, r4
c0d01c8a:	4631      	mov	r1, r6
c0d01c8c:	f7ff fc1e 	bl	c0d014cc <monero_io_insert>
  monero_io_insert_encrypt(sec,32);
c0d01c90:	4628      	mov	r0, r5
c0d01c92:	4631      	mov	r1, r6
c0d01c94:	f7ff fc2e 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01c98:	2009      	movs	r0, #9
c0d01c9a:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01c9c:	b010      	add	sp, #64	; 0x40
c0d01c9e:	bd70      	pop	{r4, r5, r6, pc}

c0d01ca0 <monero_apdu_secret_key_to_public_key>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_secret_key_to_public_key(/*const crypto::secret_key &sec, crypto::public_key &pub*/) {
c0d01ca0:	b570      	push	{r4, r5, r6, lr}
c0d01ca2:	b090      	sub	sp, #64	; 0x40
c0d01ca4:	ad08      	add	r5, sp, #32
c0d01ca6:	2420      	movs	r4, #32
  unsigned char sec[32];
  unsigned char pub[32];
  //fetch
  monero_io_fetch_decrypt(sec,32);
c0d01ca8:	4628      	mov	r0, r5
c0d01caa:	4621      	mov	r1, r4
c0d01cac:	f7ff fc8c 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01cb0:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01cb2:	f7ff fbdf 	bl	c0d01474 <monero_io_discard>
c0d01cb6:	466e      	mov	r6, sp
  //pub
  monero_ecmul_G(pub,sec);
c0d01cb8:	4630      	mov	r0, r6
c0d01cba:	4629      	mov	r1, r5
c0d01cbc:	f7fe fdbe 	bl	c0d0083c <monero_ecmul_G>
  //pub key
  monero_io_insert(pub,32);
c0d01cc0:	4630      	mov	r0, r6
c0d01cc2:	4621      	mov	r1, r4
c0d01cc4:	f7ff fc02 	bl	c0d014cc <monero_io_insert>
c0d01cc8:	2009      	movs	r0, #9
c0d01cca:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01ccc:	b010      	add	sp, #64	; 0x40
c0d01cce:	bd70      	pop	{r4, r5, r6, pc}

c0d01cd0 <monero_apdu_generate_key_derivation>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_key_derivation(/*const crypto::public_key &pub, const crypto::secret_key &sec, crypto::key_derivation &derivation*/) {
c0d01cd0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01cd2:	b099      	sub	sp, #100	; 0x64
c0d01cd4:	ad11      	add	r5, sp, #68	; 0x44
c0d01cd6:	2420      	movs	r4, #32
  unsigned char pub[32];
  unsigned char sec[32];
  unsigned char drv[32];
  //fetch
  monero_io_fetch(pub,32);
c0d01cd8:	4628      	mov	r0, r5
c0d01cda:	4621      	mov	r1, r4
c0d01cdc:	f7ff fc58 	bl	c0d01590 <monero_io_fetch>
c0d01ce0:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt_key(sec);
c0d01ce2:	4630      	mov	r0, r6
c0d01ce4:	f7ff fc92 	bl	c0d0160c <monero_io_fetch_decrypt_key>
c0d01ce8:	2000      	movs	r0, #0

  monero_io_discard(0);
c0d01cea:	f7ff fbc3 	bl	c0d01474 <monero_io_discard>
c0d01cee:	af01      	add	r7, sp, #4

  //Derive  and keep
  monero_generate_key_derivation(drv, pub, sec);
c0d01cf0:	4638      	mov	r0, r7
c0d01cf2:	4629      	mov	r1, r5
c0d01cf4:	4632      	mov	r2, r6
c0d01cf6:	f7fe fdcf 	bl	c0d00898 <monero_generate_key_derivation>

  monero_io_insert_encrypt(drv,32);
c0d01cfa:	4638      	mov	r0, r7
c0d01cfc:	4621      	mov	r1, r4
c0d01cfe:	f7ff fbf9 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01d02:	2009      	movs	r0, #9
c0d01d04:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01d06:	b019      	add	sp, #100	; 0x64
c0d01d08:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01d0a <monero_apdu_derivation_to_scalar>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derivation_to_scalar(/*const crypto::key_derivation &derivation, const size_t output_index, ec_scalar &res*/) {
c0d01d0a:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01d0c:	b091      	sub	sp, #68	; 0x44
c0d01d0e:	ad09      	add	r5, sp, #36	; 0x24
c0d01d10:	2420      	movs	r4, #32
  unsigned char derivation[32];
  unsigned int  output_index;
  unsigned char res[32];

  //fetch
  monero_io_fetch_decrypt(derivation,32);
c0d01d12:	4628      	mov	r0, r5
c0d01d14:	4621      	mov	r1, r4
c0d01d16:	f7ff fc57 	bl	c0d015c8 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01d1a:	f7ff fca9 	bl	c0d01670 <monero_io_fetch_u32>
c0d01d1e:	4606      	mov	r6, r0
c0d01d20:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01d22:	f7ff fba7 	bl	c0d01474 <monero_io_discard>
c0d01d26:	af01      	add	r7, sp, #4

  //pub
  monero_derivation_to_scalar(res, derivation, output_index);
c0d01d28:	4638      	mov	r0, r7
c0d01d2a:	4629      	mov	r1, r5
c0d01d2c:	4632      	mov	r2, r6
c0d01d2e:	f7fe fdc3 	bl	c0d008b8 <monero_derivation_to_scalar>

  //pub key
  monero_io_insert_encrypt(res,32);
c0d01d32:	4638      	mov	r0, r7
c0d01d34:	4621      	mov	r1, r4
c0d01d36:	f7ff fbdd 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01d3a:	2009      	movs	r0, #9
c0d01d3c:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01d3e:	b011      	add	sp, #68	; 0x44
c0d01d40:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01d42 <monero_apdu_derive_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_public_key(/*const crypto::key_derivation &derivation, const std::size_t output_index, const crypto::public_key &pub, public_key &derived_pub*/) {
c0d01d42:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01d44:	b099      	sub	sp, #100	; 0x64
c0d01d46:	ad11      	add	r5, sp, #68	; 0x44
c0d01d48:	2420      	movs	r4, #32
  unsigned int  output_index;
  unsigned char pub[32];
  unsigned char drvpub[32];

  //fetch
  monero_io_fetch_decrypt(derivation,32);
c0d01d4a:	4628      	mov	r0, r5
c0d01d4c:	4621      	mov	r1, r4
c0d01d4e:	f7ff fc3b 	bl	c0d015c8 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01d52:	f7ff fc8d 	bl	c0d01670 <monero_io_fetch_u32>
c0d01d56:	9000      	str	r0, [sp, #0]
c0d01d58:	af09      	add	r7, sp, #36	; 0x24
  monero_io_fetch(pub, 32);
c0d01d5a:	4638      	mov	r0, r7
c0d01d5c:	4621      	mov	r1, r4
c0d01d5e:	f7ff fc17 	bl	c0d01590 <monero_io_fetch>
c0d01d62:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01d64:	f7ff fb86 	bl	c0d01474 <monero_io_discard>
c0d01d68:	ae01      	add	r6, sp, #4

  //pub
  monero_derive_public_key(drvpub, derivation, output_index, pub);
c0d01d6a:	4630      	mov	r0, r6
c0d01d6c:	4629      	mov	r1, r5
c0d01d6e:	9a00      	ldr	r2, [sp, #0]
c0d01d70:	463b      	mov	r3, r7
c0d01d72:	f7fe fe1f 	bl	c0d009b4 <monero_derive_public_key>

  //pub key
  monero_io_insert(drvpub,32);
c0d01d76:	4630      	mov	r0, r6
c0d01d78:	4621      	mov	r1, r4
c0d01d7a:	f7ff fba7 	bl	c0d014cc <monero_io_insert>
c0d01d7e:	2009      	movs	r0, #9
c0d01d80:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01d82:	b019      	add	sp, #100	; 0x64
c0d01d84:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01d86 <monero_apdu_derive_secret_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_secret_key(/*const crypto::key_derivation &derivation, const std::size_t output_index, const crypto::secret_key &sec, secret_key &derived_sec*/){
c0d01d86:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01d88:	b099      	sub	sp, #100	; 0x64
c0d01d8a:	ad11      	add	r5, sp, #68	; 0x44
c0d01d8c:	2420      	movs	r4, #32
  unsigned int  output_index;
  unsigned char sec[32];
  unsigned char drvsec[32];

  //fetch
  monero_io_fetch_decrypt(derivation,32);
c0d01d8e:	4628      	mov	r0, r5
c0d01d90:	4621      	mov	r1, r4
c0d01d92:	f7ff fc19 	bl	c0d015c8 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01d96:	f7ff fc6b 	bl	c0d01670 <monero_io_fetch_u32>
c0d01d9a:	9000      	str	r0, [sp, #0]
c0d01d9c:	af09      	add	r7, sp, #36	; 0x24
  monero_io_fetch_decrypt_key(sec);
c0d01d9e:	4638      	mov	r0, r7
c0d01da0:	f7ff fc34 	bl	c0d0160c <monero_io_fetch_decrypt_key>
c0d01da4:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01da6:	f7ff fb65 	bl	c0d01474 <monero_io_discard>
c0d01daa:	ae01      	add	r6, sp, #4

  //pub
  monero_derive_secret_key(drvsec, derivation, output_index, sec);
c0d01dac:	4630      	mov	r0, r6
c0d01dae:	4629      	mov	r1, r5
c0d01db0:	9a00      	ldr	r2, [sp, #0]
c0d01db2:	463b      	mov	r3, r7
c0d01db4:	f7fe fdbc 	bl	c0d00930 <monero_derive_secret_key>

  //pub key
  monero_io_insert_encrypt(drvsec,32);
c0d01db8:	4630      	mov	r0, r6
c0d01dba:	4621      	mov	r1, r4
c0d01dbc:	f7ff fb9a 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01dc0:	2009      	movs	r0, #9
c0d01dc2:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01dc4:	b019      	add	sp, #100	; 0x64
c0d01dc6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01dc8 <monero_apdu_generate_key_image>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_generate_key_image(/*const crypto::public_key &pub, const crypto::secret_key &sec, crypto::key_image &image*/){
c0d01dc8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01dca:	b099      	sub	sp, #100	; 0x64
c0d01dcc:	ad11      	add	r5, sp, #68	; 0x44
c0d01dce:	2420      	movs	r4, #32
  unsigned char pub[32];
  unsigned char sec[32];
  unsigned char image[32];

  //fetch
  monero_io_fetch(pub,32);
c0d01dd0:	4628      	mov	r0, r5
c0d01dd2:	4621      	mov	r1, r4
c0d01dd4:	f7ff fbdc 	bl	c0d01590 <monero_io_fetch>
c0d01dd8:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(sec, 32);
c0d01dda:	4630      	mov	r0, r6
c0d01ddc:	4621      	mov	r1, r4
c0d01dde:	f7ff fbf3 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d01de2:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01de4:	f7ff fb46 	bl	c0d01474 <monero_io_discard>
c0d01de8:	af01      	add	r7, sp, #4

  //pub
  monero_generate_key_image(image, pub, sec);
c0d01dea:	4638      	mov	r0, r7
c0d01dec:	4629      	mov	r1, r5
c0d01dee:	4632      	mov	r2, r6
c0d01df0:	f7fe fe2c 	bl	c0d00a4c <monero_generate_key_image>

  //pub key
  monero_io_insert(image,32);
c0d01df4:	4638      	mov	r0, r7
c0d01df6:	4621      	mov	r1, r4
c0d01df8:	f7ff fb68 	bl	c0d014cc <monero_io_insert>
c0d01dfc:	2009      	movs	r0, #9
c0d01dfe:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01e00:	b019      	add	sp, #100	; 0x64
c0d01e02:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01e04 <monero_apdu_derive_subaddress_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_derive_subaddress_public_key(/*const crypto::public_key &pub, const crypto::key_derivation &derivation, const std::size_t output_index, public_key &derived_pub*/) {
c0d01e04:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01e06:	b099      	sub	sp, #100	; 0x64
c0d01e08:	ad11      	add	r5, sp, #68	; 0x44
c0d01e0a:	2420      	movs	r4, #32
  unsigned char derivation[32];
  unsigned int  output_index;
  unsigned char sub_pub[32];

  //fetch
  monero_io_fetch(pub,32);
c0d01e0c:	4628      	mov	r0, r5
c0d01e0e:	4621      	mov	r1, r4
c0d01e10:	f7ff fbbe 	bl	c0d01590 <monero_io_fetch>
c0d01e14:	ae09      	add	r6, sp, #36	; 0x24
  monero_io_fetch_decrypt(derivation, 32);
c0d01e16:	4630      	mov	r0, r6
c0d01e18:	4621      	mov	r1, r4
c0d01e1a:	f7ff fbd5 	bl	c0d015c8 <monero_io_fetch_decrypt>
  output_index = monero_io_fetch_u32();
c0d01e1e:	f7ff fc27 	bl	c0d01670 <monero_io_fetch_u32>
c0d01e22:	9000      	str	r0, [sp, #0]
c0d01e24:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01e26:	f7ff fb25 	bl	c0d01474 <monero_io_discard>
c0d01e2a:	af01      	add	r7, sp, #4

  //pub
  monero_derive_subaddress_public_key(sub_pub, pub, derivation, output_index);
c0d01e2c:	4638      	mov	r0, r7
c0d01e2e:	4629      	mov	r1, r5
c0d01e30:	4632      	mov	r2, r6
c0d01e32:	9b00      	ldr	r3, [sp, #0]
c0d01e34:	f7fe fe4a 	bl	c0d00acc <monero_derive_subaddress_public_key>
  //pub key
  monero_io_insert(sub_pub,32);
c0d01e38:	4638      	mov	r0, r7
c0d01e3a:	4621      	mov	r1, r4
c0d01e3c:	f7ff fb46 	bl	c0d014cc <monero_io_insert>
c0d01e40:	2009      	movs	r0, #9
c0d01e42:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01e44:	b019      	add	sp, #100	; 0x64
c0d01e46:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d01e48 <monero_apdu_get_subaddress>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress(/*const cryptonote::subaddress_index& index, cryptonote::account_public_address &address*/) {
c0d01e48:	b570      	push	{r4, r5, r6, lr}
c0d01e4a:	b092      	sub	sp, #72	; 0x48
c0d01e4c:	ac10      	add	r4, sp, #64	; 0x40
c0d01e4e:	2108      	movs	r1, #8
  unsigned char index[8];
  unsigned char C[32];
  unsigned char D[32];

  //fetch
  monero_io_fetch(index,8);
c0d01e50:	4620      	mov	r0, r4
c0d01e52:	f7ff fb9d 	bl	c0d01590 <monero_io_fetch>
c0d01e56:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01e58:	f7ff fb0c 	bl	c0d01474 <monero_io_discard>
c0d01e5c:	ad08      	add	r5, sp, #32
c0d01e5e:	466e      	mov	r6, sp

  //pub
  monero_get_subaddress(C,D,index);
c0d01e60:	4628      	mov	r0, r5
c0d01e62:	4631      	mov	r1, r6
c0d01e64:	4622      	mov	r2, r4
c0d01e66:	f7fe fedb 	bl	c0d00c20 <monero_get_subaddress>
c0d01e6a:	2420      	movs	r4, #32

  //pub key
  monero_io_insert(C,32);
c0d01e6c:	4628      	mov	r0, r5
c0d01e6e:	4621      	mov	r1, r4
c0d01e70:	f7ff fb2c 	bl	c0d014cc <monero_io_insert>
  monero_io_insert(D,32);
c0d01e74:	4630      	mov	r0, r6
c0d01e76:	4621      	mov	r1, r4
c0d01e78:	f7ff fb28 	bl	c0d014cc <monero_io_insert>
c0d01e7c:	2009      	movs	r0, #9
c0d01e7e:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01e80:	b012      	add	sp, #72	; 0x48
c0d01e82:	bd70      	pop	{r4, r5, r6, pc}

c0d01e84 <monero_apdu_get_subaddress_spend_public_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress_spend_public_key(/*const cryptonote::subaddress_index& index, crypto::public_key D*/) {
c0d01e84:	b5b0      	push	{r4, r5, r7, lr}
c0d01e86:	b08a      	sub	sp, #40	; 0x28
c0d01e88:	ac08      	add	r4, sp, #32
c0d01e8a:	2108      	movs	r1, #8
  unsigned char index[8];
  unsigned char D[32];

  //fetch
  monero_io_fetch(index,8);
c0d01e8c:	4620      	mov	r0, r4
c0d01e8e:	f7ff fb7f 	bl	c0d01590 <monero_io_fetch>
c0d01e92:	2001      	movs	r0, #1
  monero_io_discard(1);
c0d01e94:	f7ff faee 	bl	c0d01474 <monero_io_discard>
c0d01e98:	466d      	mov	r5, sp

  //pub
  monero_get_subaddress_spend_public_key(D, index);
c0d01e9a:	4628      	mov	r0, r5
c0d01e9c:	4621      	mov	r1, r4
c0d01e9e:	f7fe fe6d 	bl	c0d00b7c <monero_get_subaddress_spend_public_key>
c0d01ea2:	2120      	movs	r1, #32

  //pub key
  monero_io_insert(D,32);
c0d01ea4:	4628      	mov	r0, r5
c0d01ea6:	f7ff fb11 	bl	c0d014cc <monero_io_insert>
c0d01eaa:	2009      	movs	r0, #9
c0d01eac:	0300      	lsls	r0, r0, #12

  return SW_OK;
c0d01eae:	b00a      	add	sp, #40	; 0x28
c0d01eb0:	bdb0      	pop	{r4, r5, r7, pc}

c0d01eb2 <monero_apdu_get_subaddress_secret_key>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_get_subaddress_secret_key(/*const crypto::secret_key& sec, const cryptonote::subaddress_index& index, crypto::secret_key &sub_sec*/) {
c0d01eb2:	b570      	push	{r4, r5, r6, lr}
c0d01eb4:	b092      	sub	sp, #72	; 0x48
c0d01eb6:	ac0a      	add	r4, sp, #40	; 0x28
  unsigned char sec[32];
  unsigned char index[8];
  unsigned char sub_sec[32];

  monero_io_fetch_decrypt_key(sec);
c0d01eb8:	4620      	mov	r0, r4
c0d01eba:	f7ff fba7 	bl	c0d0160c <monero_io_fetch_decrypt_key>
c0d01ebe:	ad08      	add	r5, sp, #32
c0d01ec0:	2108      	movs	r1, #8
  monero_io_fetch(index,8);
c0d01ec2:	4628      	mov	r0, r5
c0d01ec4:	f7ff fb64 	bl	c0d01590 <monero_io_fetch>
c0d01ec8:	2000      	movs	r0, #0
  monero_io_discard(0);
c0d01eca:	f7ff fad3 	bl	c0d01474 <monero_io_discard>
c0d01ece:	466e      	mov	r6, sp

  //pub
  monero_get_subaddress_secret_key(sub_sec,sec,index);
c0d01ed0:	4630      	mov	r0, r6
c0d01ed2:	4621      	mov	r1, r4
c0d01ed4:	462a      	mov	r2, r5
c0d01ed6:	f7fe fe69 	bl	c0d00bac <monero_get_subaddress_secret_key>
c0d01eda:	2120      	movs	r1, #32

  //pub key
  monero_io_insert_encrypt(sub_sec,32);
c0d01edc:	4630      	mov	r0, r6
c0d01ede:	f7ff fb09 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01ee2:	2009      	movs	r0, #9
c0d01ee4:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d01ee6:	b012      	add	sp, #72	; 0x48
c0d01ee8:	bd70      	pop	{r4, r5, r6, pc}
	...

c0d01eec <monero_apu_generate_txout_keys>:
      //
      //   hash_update(Aout, Bout, AKout, out_eph_public_key)
      //
      //   return additional_pub, Akout, out_eph_public_key

int monero_apu_generate_txout_keys(/*size_t tx_version, crypto::secret_key tx_sec, crypto::public_key Aout, crypto::public_key Bout, size_t output_index, bool is_change, bool is_subaddress, bool need_additional_key*/) {
c0d01eec:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d01eee:	b0ab      	sub	sp, #172	; 0xac
  unsigned char is_subaddress;
  unsigned char need_additional_key;
  unsigned char derivation[32];


  tx_version = monero_io_fetch_u32();
c0d01ef0:	f7ff fbbe 	bl	c0d01670 <monero_io_fetch_u32>
c0d01ef4:	a823      	add	r0, sp, #140	; 0x8c
  monero_io_fetch_decrypt_key(tx_sec);
c0d01ef6:	f7ff fb89 	bl	c0d0160c <monero_io_fetch_decrypt_key>
c0d01efa:	a81b      	add	r0, sp, #108	; 0x6c
c0d01efc:	2420      	movs	r4, #32
  monero_io_fetch(tx_pub,32);
c0d01efe:	4621      	mov	r1, r4
c0d01f00:	f7ff fb46 	bl	c0d01590 <monero_io_fetch>
c0d01f04:	a813      	add	r0, sp, #76	; 0x4c
  monero_io_fetch(Aout,32);
c0d01f06:	4621      	mov	r1, r4
c0d01f08:	f7ff fb42 	bl	c0d01590 <monero_io_fetch>
c0d01f0c:	a80b      	add	r0, sp, #44	; 0x2c
  monero_io_fetch(Bout,32);
c0d01f0e:	4621      	mov	r1, r4
c0d01f10:	f7ff fb3e 	bl	c0d01590 <monero_io_fetch>
  output_index = monero_io_fetch_u32();
c0d01f14:	f7ff fbac 	bl	c0d01670 <monero_io_fetch_u32>
c0d01f18:	4607      	mov	r7, r0
  is_change = monero_io_fetch_u8();
c0d01f1a:	f7ff fbc5 	bl	c0d016a8 <monero_io_fetch_u8>
c0d01f1e:	a90a      	add	r1, sp, #40	; 0x28
c0d01f20:	7008      	strb	r0, [r1, #0]
  is_subaddress = monero_io_fetch_u8();
c0d01f22:	f7ff fbc1 	bl	c0d016a8 <monero_io_fetch_u8>
c0d01f26:	9001      	str	r0, [sp, #4]
  need_additional_key = monero_io_fetch_u8();
c0d01f28:	f7ff fbbe 	bl	c0d016a8 <monero_io_fetch_u8>
c0d01f2c:	4606      	mov	r6, r0
c0d01f2e:	2001      	movs	r0, #1

  //additional pub key
  monero_io_discard(1);
c0d01f30:	f7ff faa0 	bl	c0d01474 <monero_io_discard>
c0d01f34:	207b      	movs	r0, #123	; 0x7b
c0d01f36:	0080      	lsls	r0, r0, #2

  if (G_monero_vstate.tx_output_cnt>=2) {
c0d01f38:	4d36      	ldr	r5, [pc, #216]	; (c0d02014 <monero_apu_generate_txout_keys+0x128>)
c0d01f3a:	5829      	ldr	r1, [r5, r0]
c0d01f3c:	2902      	cmp	r1, #2
c0d01f3e:	d266      	bcs.n	c0d0200e <monero_apu_generate_txout_keys+0x122>
    THROW(SW_SECURITY_MAXOUTPUT_REACHED);
    return SW_SECURITY_MAXOUTPUT_REACHED;
  }
  G_monero_vstate.tx_output_cnt++;
c0d01f40:	1c49      	adds	r1, r1, #1
c0d01f42:	5029      	str	r1, [r5, r0]
c0d01f44:	2005      	movs	r0, #5
c0d01f46:	0184      	lsls	r4, r0, #6

  //update outkeys hash control
  if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d01f48:	5928      	ldr	r0, [r5, r4]
c0d01f4a:	2801      	cmp	r0, #1
c0d01f4c:	d11a      	bne.n	c0d01f84 <monero_apu_generate_txout_keys+0x98>
c0d01f4e:	78a8      	ldrb	r0, [r5, #2]
c0d01f50:	2802      	cmp	r0, #2
c0d01f52:	d117      	bne.n	c0d01f84 <monero_apu_generate_txout_keys+0x98>
c0d01f54:	2017      	movs	r0, #23
c0d01f56:	0180      	lsls	r0, r0, #6
c0d01f58:	9700      	str	r7, [sp, #0]
    if (G_monero_vstate.io_protocol_version == 2) {
      monero_sha256_outkeys_update(Aout,32);
c0d01f5a:	182f      	adds	r7, r5, r0
c0d01f5c:	a913      	add	r1, sp, #76	; 0x4c
c0d01f5e:	4625      	mov	r5, r4
c0d01f60:	2420      	movs	r4, #32
c0d01f62:	4638      	mov	r0, r7
c0d01f64:	4622      	mov	r2, r4
c0d01f66:	f7fe f999 	bl	c0d0029c <monero_hash_update>
c0d01f6a:	a90b      	add	r1, sp, #44	; 0x2c
      monero_sha256_outkeys_update(Bout,32);
c0d01f6c:	4638      	mov	r0, r7
c0d01f6e:	4622      	mov	r2, r4
c0d01f70:	462c      	mov	r4, r5
c0d01f72:	4d28      	ldr	r5, [pc, #160]	; (c0d02014 <monero_apu_generate_txout_keys+0x128>)
c0d01f74:	f7fe f992 	bl	c0d0029c <monero_hash_update>
c0d01f78:	a90a      	add	r1, sp, #40	; 0x28
c0d01f7a:	2201      	movs	r2, #1
      monero_sha256_outkeys_update(&is_change,1);
c0d01f7c:	4638      	mov	r0, r7
c0d01f7e:	9f00      	ldr	r7, [sp, #0]
c0d01f80:	f7fe f98c 	bl	c0d0029c <monero_hash_update>
    }
  }

  if (need_additional_key) {
c0d01f84:	0630      	lsls	r0, r6, #24
c0d01f86:	d010      	beq.n	c0d01faa <monero_apu_generate_txout_keys+0xbe>
    if (is_subaddress) {
c0d01f88:	9801      	ldr	r0, [sp, #4]
c0d01f8a:	0600      	lsls	r0, r0, #24
c0d01f8c:	d005      	beq.n	c0d01f9a <monero_apu_generate_txout_keys+0xae>
c0d01f8e:	a802      	add	r0, sp, #8
c0d01f90:	a90b      	add	r1, sp, #44	; 0x2c
c0d01f92:	aa23      	add	r2, sp, #140	; 0x8c
      monero_ecmul_k(derivation, Bout, tx_sec);
c0d01f94:	f7fe fd69 	bl	c0d00a6a <monero_ecmul_k>
c0d01f98:	e003      	b.n	c0d01fa2 <monero_apu_generate_txout_keys+0xb6>
c0d01f9a:	a802      	add	r0, sp, #8
c0d01f9c:	a923      	add	r1, sp, #140	; 0x8c
    } else {
      monero_ecmul_G(derivation, tx_sec);
c0d01f9e:	f7fe fc4d 	bl	c0d0083c <monero_ecmul_G>
c0d01fa2:	a802      	add	r0, sp, #8
c0d01fa4:	2120      	movs	r1, #32
    }
    monero_io_insert(derivation,32);
c0d01fa6:	f7ff fa91 	bl	c0d014cc <monero_io_insert>
c0d01faa:	a80a      	add	r0, sp, #40	; 0x28
  }

  //derivation
  if (is_change) {
c0d01fac:	7800      	ldrb	r0, [r0, #0]
c0d01fae:	2800      	cmp	r0, #0
c0d01fb0:	d002      	beq.n	c0d01fb8 <monero_apu_generate_txout_keys+0xcc>
c0d01fb2:	a802      	add	r0, sp, #8
c0d01fb4:	a91b      	add	r1, sp, #108	; 0x6c
c0d01fb6:	e001      	b.n	c0d01fbc <monero_apu_generate_txout_keys+0xd0>
c0d01fb8:	a802      	add	r0, sp, #8
c0d01fba:	a913      	add	r1, sp, #76	; 0x4c
c0d01fbc:	aa23      	add	r2, sp, #140	; 0x8c
c0d01fbe:	f7fe fc6b 	bl	c0d00898 <monero_generate_key_derivation>
c0d01fc2:	a823      	add	r0, sp, #140	; 0x8c
c0d01fc4:	a902      	add	r1, sp, #8
  } else {
    monero_generate_key_derivation(derivation, Aout, tx_sec);
  }

  //compute AKout (amount key)
  monero_derivation_to_scalar(tx_sec, derivation, output_index);
c0d01fc6:	463a      	mov	r2, r7
c0d01fc8:	f7fe fc76 	bl	c0d008b8 <monero_derivation_to_scalar>
  if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d01fcc:	5928      	ldr	r0, [r5, r4]
c0d01fce:	2801      	cmp	r0, #1
c0d01fd0:	d109      	bne.n	c0d01fe6 <monero_apu_generate_txout_keys+0xfa>
c0d01fd2:	78a8      	ldrb	r0, [r5, #2]
c0d01fd4:	2802      	cmp	r0, #2
c0d01fd6:	d106      	bne.n	c0d01fe6 <monero_apu_generate_txout_keys+0xfa>
c0d01fd8:	2017      	movs	r0, #23
c0d01fda:	0180      	lsls	r0, r0, #6
      if (G_monero_vstate.io_protocol_version == 2) {
        monero_sha256_outkeys_update(tx_sec,32);
c0d01fdc:	1828      	adds	r0, r5, r0
c0d01fde:	a923      	add	r1, sp, #140	; 0x8c
c0d01fe0:	2220      	movs	r2, #32
c0d01fe2:	f7fe f95b 	bl	c0d0029c <monero_hash_update>
c0d01fe6:	ac23      	add	r4, sp, #140	; 0x8c
c0d01fe8:	2520      	movs	r5, #32
      }
  }
  monero_io_insert_encrypt(tx_sec,32);
c0d01fea:	4620      	mov	r0, r4
c0d01fec:	4629      	mov	r1, r5
c0d01fee:	f7ff fa81 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d01ff2:	a902      	add	r1, sp, #8
c0d01ff4:	ab0b      	add	r3, sp, #44	; 0x2c

  //compute ephemeral output key
  monero_derive_public_key(tx_sec, derivation, output_index, Bout);
c0d01ff6:	4620      	mov	r0, r4
c0d01ff8:	463a      	mov	r2, r7
c0d01ffa:	f7fe fcdb 	bl	c0d009b4 <monero_derive_public_key>
  monero_io_insert(tx_sec,32);
c0d01ffe:	4620      	mov	r0, r4
c0d02000:	4629      	mov	r1, r5
c0d02002:	f7ff fa63 	bl	c0d014cc <monero_io_insert>
c0d02006:	2009      	movs	r0, #9
c0d02008:	0300      	lsls	r0, r0, #12
  return SW_OK;
c0d0200a:	b02b      	add	sp, #172	; 0xac
c0d0200c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0200e:	4802      	ldr	r0, [pc, #8]	; (c0d02018 <monero_apu_generate_txout_keys+0x12c>)

  //additional pub key
  monero_io_discard(1);

  if (G_monero_vstate.tx_output_cnt>=2) {
    THROW(SW_SECURITY_MAXOUTPUT_REACHED);
c0d02010:	f001 fd8c 	bl	c0d03b2c <os_longjmp>
c0d02014:	20001930 	.word	0x20001930
c0d02018:	00006915 	.word	0x00006915

c0d0201c <monero_main>:

/* ----------------------------------------------------------------------- */
/* ---                            Application Entry                    --- */
/* ----------------------------------------------------------------------- */

void monero_main(void) {
c0d0201c:	b08c      	sub	sp, #48	; 0x30
c0d0201e:	2700      	movs	r7, #0
c0d02020:	463c      	mov	r4, r7
c0d02022:	a80b      	add	r0, sp, #44	; 0x2c
  unsigned int io_flags;
  io_flags = 0;
  for (;;) {
    volatile unsigned short sw = 0;
c0d02024:	8007      	strh	r7, [r0, #0]
c0d02026:	466e      	mov	r6, sp
    BEGIN_TRY {
      TRY {
c0d02028:	4630      	mov	r0, r6
c0d0202a:	f004 fb89 	bl	c0d06740 <setjmp>
c0d0202e:	8530      	strh	r0, [r6, #40]	; 0x28
c0d02030:	b286      	uxth	r6, r0
c0d02032:	2e00      	cmp	r6, #0
c0d02034:	d016      	beq.n	c0d02064 <monero_main+0x48>
c0d02036:	4605      	mov	r5, r0
c0d02038:	4668      	mov	r0, sp
c0d0203a:	2100      	movs	r1, #0
        monero_io_do(io_flags);
        sw = monero_dispatch();
      }
      CATCH_OTHER(e) {
c0d0203c:	8501      	strh	r1, [r0, #40]	; 0x28
c0d0203e:	2001      	movs	r0, #1
        monero_io_discard(1);
c0d02040:	f7ff fa18 	bl	c0d01474 <monero_io_discard>
c0d02044:	200f      	movs	r0, #15
c0d02046:	0304      	lsls	r4, r0, #12
        monero_reset_tx();
        if ( (e & 0xFFFF0000) ||
             ( ((e&0xF000)!=0x6000) && ((e&0xF000)!=0x9000) ) ) {
c0d02048:	402c      	ands	r4, r5
        monero_io_do(io_flags);
        sw = monero_dispatch();
      }
      CATCH_OTHER(e) {
        monero_io_discard(1);
        monero_reset_tx();
c0d0204a:	f000 fd37 	bl	c0d02abc <monero_reset_tx>
c0d0204e:	2003      	movs	r0, #3
c0d02050:	0340      	lsls	r0, r0, #13
        if ( (e & 0xFFFF0000) ||
             ( ((e&0xF000)!=0x6000) && ((e&0xF000)!=0x9000) ) ) {
c0d02052:	4284      	cmp	r4, r0
c0d02054:	d003      	beq.n	c0d0205e <monero_main+0x42>
c0d02056:	2009      	movs	r0, #9
c0d02058:	0300      	lsls	r0, r0, #12
c0d0205a:	4284      	cmp	r4, r0
c0d0205c:	d10d      	bne.n	c0d0207a <monero_main+0x5e>
c0d0205e:	a80b      	add	r0, sp, #44	; 0x2c
          monero_io_insert_u32(e);
          sw = 0x6f42;
        } else {
          sw = e;
c0d02060:	8005      	strh	r5, [r0, #0]
c0d02062:	e010      	b.n	c0d02086 <monero_main+0x6a>
c0d02064:	4668      	mov	r0, sp
  unsigned int io_flags;
  io_flags = 0;
  for (;;) {
    volatile unsigned short sw = 0;
    BEGIN_TRY {
      TRY {
c0d02066:	f001 fbaa 	bl	c0d037be <try_context_set>
        monero_io_do(io_flags);
c0d0206a:	4620      	mov	r0, r4
c0d0206c:	f7ff fb2e 	bl	c0d016cc <monero_io_do>
        sw = monero_dispatch();
c0d02070:	f7ff f818 	bl	c0d010a4 <monero_dispatch>
c0d02074:	a90b      	add	r1, sp, #44	; 0x2c
c0d02076:	8008      	strh	r0, [r1, #0]
c0d02078:	e005      	b.n	c0d02086 <monero_main+0x6a>
      CATCH_OTHER(e) {
        monero_io_discard(1);
        monero_reset_tx();
        if ( (e & 0xFFFF0000) ||
             ( ((e&0xF000)!=0x6000) && ((e&0xF000)!=0x9000) ) ) {
          monero_io_insert_u32(e);
c0d0207a:	4630      	mov	r0, r6
c0d0207c:	f7ff fa56 	bl	c0d0152c <monero_io_insert_u32>
c0d02080:	a80b      	add	r0, sp, #44	; 0x2c
          sw = 0x6f42;
c0d02082:	490d      	ldr	r1, [pc, #52]	; (c0d020b8 <monero_main+0x9c>)
c0d02084:	8001      	strh	r1, [r0, #0]
        } else {
          sw = e;
        }
      }
      FINALLY {
c0d02086:	f001 fd55 	bl	c0d03b34 <try_context_get>
c0d0208a:	4669      	mov	r1, sp
c0d0208c:	4288      	cmp	r0, r1
c0d0208e:	d103      	bne.n	c0d02098 <monero_main+0x7c>
c0d02090:	f001 fd52 	bl	c0d03b38 <try_context_get_previous>
c0d02094:	f001 fb93 	bl	c0d037be <try_context_set>
c0d02098:	a80b      	add	r0, sp, #44	; 0x2c
        if (sw) {
c0d0209a:	8800      	ldrh	r0, [r0, #0]
c0d0209c:	2410      	movs	r4, #16
c0d0209e:	2800      	cmp	r0, #0
c0d020a0:	d004      	beq.n	c0d020ac <monero_main+0x90>
c0d020a2:	a80b      	add	r0, sp, #44	; 0x2c
          monero_io_insert_u16(sw);
c0d020a4:	8800      	ldrh	r0, [r0, #0]
c0d020a6:	f7ff fa55 	bl	c0d01554 <monero_io_insert_u16>
c0d020aa:	2400      	movs	r4, #0
c0d020ac:	4668      	mov	r0, sp
        } else {
          io_flags = IO_ASYNCH_REPLY;
        }
      }
    }
    END_TRY;
c0d020ae:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d020b0:	2800      	cmp	r0, #0
c0d020b2:	d0b6      	beq.n	c0d02022 <monero_main+0x6>
c0d020b4:	f001 fd3a 	bl	c0d03b2c <os_longjmp>
c0d020b8:	00006f42 	.word	0x00006f42

c0d020bc <io_event>:
  }

}


unsigned char io_event(unsigned char channel) {
c0d020bc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d020be:	b085      	sub	sp, #20
  int s_before ;
  int s_after  ;

  s_before =  os_global_pin_is_validated();
c0d020c0:	f002 fd42 	bl	c0d04b48 <os_global_pin_is_validated>
  
  // nothing done with the event, throw an error on the transport layer if
  // needed
  // can't have more than one tag in the reply, not supported yet.
  switch (G_io_seproxyhal_spi_buffer[0]) {
c0d020c4:	4fea      	ldr	r7, [pc, #936]	; (c0d02470 <io_event+0x3b4>)
c0d020c6:	7839      	ldrb	r1, [r7, #0]
c0d020c8:	4dea      	ldr	r5, [pc, #936]	; (c0d02474 <io_event+0x3b8>)
c0d020ca:	290c      	cmp	r1, #12
c0d020cc:	9004      	str	r0, [sp, #16]
c0d020ce:	dc51      	bgt.n	c0d02174 <io_event+0xb8>
c0d020d0:	2905      	cmp	r1, #5
c0d020d2:	d100      	bne.n	c0d020d6 <io_event+0x1a>
c0d020d4:	e099      	b.n	c0d0220a <io_event+0x14e>
c0d020d6:	290c      	cmp	r1, #12
c0d020d8:	d000      	beq.n	c0d020dc <io_event+0x20>
c0d020da:	e122      	b.n	c0d02322 <io_event+0x266>
  case SEPROXYHAL_TAG_FINGER_EVENT:
    UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d020dc:	4ee6      	ldr	r6, [pc, #920]	; (c0d02478 <io_event+0x3bc>)
c0d020de:	2400      	movs	r4, #0
c0d020e0:	61f4      	str	r4, [r6, #28]
c0d020e2:	2001      	movs	r0, #1
c0d020e4:	7630      	strb	r0, [r6, #24]
c0d020e6:	4630      	mov	r0, r6
c0d020e8:	3018      	adds	r0, #24
c0d020ea:	f002 fd59 	bl	c0d04ba0 <os_ux>
c0d020ee:	61f0      	str	r0, [r6, #28]
c0d020f0:	f002 fb38 	bl	c0d04764 <ux_check_status_default>
c0d020f4:	69f0      	ldr	r0, [r6, #28]
c0d020f6:	4de1      	ldr	r5, [pc, #900]	; (c0d0247c <io_event+0x3c0>)
c0d020f8:	42a8      	cmp	r0, r5
c0d020fa:	d100      	bne.n	c0d020fe <io_event+0x42>
c0d020fc:	e233      	b.n	c0d02566 <io_event+0x4aa>
c0d020fe:	2800      	cmp	r0, #0
c0d02100:	d100      	bne.n	c0d02104 <io_event+0x48>
c0d02102:	e230      	b.n	c0d02566 <io_event+0x4aa>
c0d02104:	49fc      	ldr	r1, [pc, #1008]	; (c0d024f8 <io_event+0x43c>)
c0d02106:	4288      	cmp	r0, r1
c0d02108:	d000      	beq.n	c0d0210c <io_event+0x50>
c0d0210a:	e1b9      	b.n	c0d02480 <io_event+0x3c4>
c0d0210c:	f001 fe64 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d02110:	f001 fe68 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d02114:	60b4      	str	r4, [r6, #8]
c0d02116:	6830      	ldr	r0, [r6, #0]
c0d02118:	2800      	cmp	r0, #0
c0d0211a:	d100      	bne.n	c0d0211e <io_event+0x62>
c0d0211c:	e223      	b.n	c0d02566 <io_event+0x4aa>
c0d0211e:	69f0      	ldr	r0, [r6, #28]
c0d02120:	42a8      	cmp	r0, r5
c0d02122:	d100      	bne.n	c0d02126 <io_event+0x6a>
c0d02124:	e21f      	b.n	c0d02566 <io_event+0x4aa>
c0d02126:	2800      	cmp	r0, #0
c0d02128:	d100      	bne.n	c0d0212c <io_event+0x70>
c0d0212a:	e21c      	b.n	c0d02566 <io_event+0x4aa>
c0d0212c:	2000      	movs	r0, #0
c0d0212e:	6871      	ldr	r1, [r6, #4]
c0d02130:	4288      	cmp	r0, r1
c0d02132:	d300      	bcc.n	c0d02136 <io_event+0x7a>
c0d02134:	e217      	b.n	c0d02566 <io_event+0x4aa>
c0d02136:	f002 fd8d 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d0213a:	2800      	cmp	r0, #0
c0d0213c:	d000      	beq.n	c0d02140 <io_event+0x84>
c0d0213e:	e212      	b.n	c0d02566 <io_event+0x4aa>
c0d02140:	68b0      	ldr	r0, [r6, #8]
c0d02142:	68f1      	ldr	r1, [r6, #12]
c0d02144:	2438      	movs	r4, #56	; 0x38
c0d02146:	4360      	muls	r0, r4
c0d02148:	6832      	ldr	r2, [r6, #0]
c0d0214a:	1810      	adds	r0, r2, r0
c0d0214c:	2900      	cmp	r1, #0
c0d0214e:	d002      	beq.n	c0d02156 <io_event+0x9a>
c0d02150:	4788      	blx	r1
c0d02152:	2800      	cmp	r0, #0
c0d02154:	d007      	beq.n	c0d02166 <io_event+0xaa>
c0d02156:	2801      	cmp	r0, #1
c0d02158:	d103      	bne.n	c0d02162 <io_event+0xa6>
c0d0215a:	68b0      	ldr	r0, [r6, #8]
c0d0215c:	4344      	muls	r4, r0
c0d0215e:	6830      	ldr	r0, [r6, #0]
c0d02160:	1900      	adds	r0, r0, r4
c0d02162:	f001 f97f 	bl	c0d03464 <io_seproxyhal_display>
c0d02166:	68b0      	ldr	r0, [r6, #8]
c0d02168:	1c40      	adds	r0, r0, #1
c0d0216a:	60b0      	str	r0, [r6, #8]
c0d0216c:	6831      	ldr	r1, [r6, #0]
c0d0216e:	2900      	cmp	r1, #0
c0d02170:	d1dd      	bne.n	c0d0212e <io_event+0x72>
c0d02172:	e1f8      	b.n	c0d02566 <io_event+0x4aa>
  s_before =  os_global_pin_is_validated();
  
  // nothing done with the event, throw an error on the transport layer if
  // needed
  // can't have more than one tag in the reply, not supported yet.
  switch (G_io_seproxyhal_spi_buffer[0]) {
c0d02174:	290d      	cmp	r1, #13
c0d02176:	d100      	bne.n	c0d0217a <io_event+0xbe>
c0d02178:	e093      	b.n	c0d022a2 <io_event+0x1e6>
c0d0217a:	290e      	cmp	r1, #14
c0d0217c:	d000      	beq.n	c0d02180 <io_event+0xc4>
c0d0217e:	e0d0      	b.n	c0d02322 <io_event+0x266>

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
    break;
  case SEPROXYHAL_TAG_TICKER_EVENT:
    UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, 
c0d02180:	4ede      	ldr	r6, [pc, #888]	; (c0d024fc <io_event+0x440>)
c0d02182:	2400      	movs	r4, #0
c0d02184:	61f4      	str	r4, [r6, #28]
c0d02186:	2001      	movs	r0, #1
c0d02188:	7630      	strb	r0, [r6, #24]
c0d0218a:	4630      	mov	r0, r6
c0d0218c:	3018      	adds	r0, #24
c0d0218e:	f002 fd07 	bl	c0d04ba0 <os_ux>
c0d02192:	61f0      	str	r0, [r6, #28]
c0d02194:	f002 fae6 	bl	c0d04764 <ux_check_status_default>
c0d02198:	69f7      	ldr	r7, [r6, #28]
c0d0219a:	42af      	cmp	r7, r5
c0d0219c:	d000      	beq.n	c0d021a0 <io_event+0xe4>
c0d0219e:	e104      	b.n	c0d023aa <io_event+0x2ee>
c0d021a0:	f001 fe1a 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d021a4:	f001 fe1e 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d021a8:	60b4      	str	r4, [r6, #8]
c0d021aa:	6830      	ldr	r0, [r6, #0]
c0d021ac:	2800      	cmp	r0, #0
c0d021ae:	d100      	bne.n	c0d021b2 <io_event+0xf6>
c0d021b0:	e1d9      	b.n	c0d02566 <io_event+0x4aa>
c0d021b2:	69f0      	ldr	r0, [r6, #28]
c0d021b4:	49d2      	ldr	r1, [pc, #840]	; (c0d02500 <io_event+0x444>)
c0d021b6:	4288      	cmp	r0, r1
c0d021b8:	d100      	bne.n	c0d021bc <io_event+0x100>
c0d021ba:	e1d4      	b.n	c0d02566 <io_event+0x4aa>
c0d021bc:	2800      	cmp	r0, #0
c0d021be:	d100      	bne.n	c0d021c2 <io_event+0x106>
c0d021c0:	e1d1      	b.n	c0d02566 <io_event+0x4aa>
c0d021c2:	2000      	movs	r0, #0
c0d021c4:	6871      	ldr	r1, [r6, #4]
c0d021c6:	4288      	cmp	r0, r1
c0d021c8:	d300      	bcc.n	c0d021cc <io_event+0x110>
c0d021ca:	e1cc      	b.n	c0d02566 <io_event+0x4aa>
c0d021cc:	f002 fd42 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d021d0:	2800      	cmp	r0, #0
c0d021d2:	d000      	beq.n	c0d021d6 <io_event+0x11a>
c0d021d4:	e1c7      	b.n	c0d02566 <io_event+0x4aa>
c0d021d6:	68b0      	ldr	r0, [r6, #8]
c0d021d8:	68f1      	ldr	r1, [r6, #12]
c0d021da:	2438      	movs	r4, #56	; 0x38
c0d021dc:	4360      	muls	r0, r4
c0d021de:	6832      	ldr	r2, [r6, #0]
c0d021e0:	1810      	adds	r0, r2, r0
c0d021e2:	2900      	cmp	r1, #0
c0d021e4:	d002      	beq.n	c0d021ec <io_event+0x130>
c0d021e6:	4788      	blx	r1
c0d021e8:	2800      	cmp	r0, #0
c0d021ea:	d007      	beq.n	c0d021fc <io_event+0x140>
c0d021ec:	2801      	cmp	r0, #1
c0d021ee:	d103      	bne.n	c0d021f8 <io_event+0x13c>
c0d021f0:	68b0      	ldr	r0, [r6, #8]
c0d021f2:	4344      	muls	r4, r0
c0d021f4:	6830      	ldr	r0, [r6, #0]
c0d021f6:	1900      	adds	r0, r0, r4
c0d021f8:	f001 f934 	bl	c0d03464 <io_seproxyhal_display>
c0d021fc:	68b0      	ldr	r0, [r6, #8]
c0d021fe:	1c40      	adds	r0, r0, #1
c0d02200:	60b0      	str	r0, [r6, #8]
c0d02202:	6831      	ldr	r1, [r6, #0]
c0d02204:	2900      	cmp	r1, #0
c0d02206:	d1dd      	bne.n	c0d021c4 <io_event+0x108>
c0d02208:	e1ad      	b.n	c0d02566 <io_event+0x4aa>
  case SEPROXYHAL_TAG_FINGER_EVENT:
    UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
    break;
  // power off if long push, else pass to the application callback if any
  case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
    UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d0220a:	4ebc      	ldr	r6, [pc, #752]	; (c0d024fc <io_event+0x440>)
c0d0220c:	2400      	movs	r4, #0
c0d0220e:	61f4      	str	r4, [r6, #28]
c0d02210:	2001      	movs	r0, #1
c0d02212:	7630      	strb	r0, [r6, #24]
c0d02214:	4630      	mov	r0, r6
c0d02216:	3018      	adds	r0, #24
c0d02218:	f002 fcc2 	bl	c0d04ba0 <os_ux>
c0d0221c:	61f0      	str	r0, [r6, #28]
c0d0221e:	f002 faa1 	bl	c0d04764 <ux_check_status_default>
c0d02222:	69f0      	ldr	r0, [r6, #28]
c0d02224:	4db6      	ldr	r5, [pc, #728]	; (c0d02500 <io_event+0x444>)
c0d02226:	42a8      	cmp	r0, r5
c0d02228:	d100      	bne.n	c0d0222c <io_event+0x170>
c0d0222a:	e19c      	b.n	c0d02566 <io_event+0x4aa>
c0d0222c:	2800      	cmp	r0, #0
c0d0222e:	d100      	bne.n	c0d02232 <io_event+0x176>
c0d02230:	e199      	b.n	c0d02566 <io_event+0x4aa>
c0d02232:	49b1      	ldr	r1, [pc, #708]	; (c0d024f8 <io_event+0x43c>)
c0d02234:	4288      	cmp	r0, r1
c0d02236:	d000      	beq.n	c0d0223a <io_event+0x17e>
c0d02238:	e164      	b.n	c0d02504 <io_event+0x448>
c0d0223a:	f001 fdcd 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d0223e:	f001 fdd1 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d02242:	60b4      	str	r4, [r6, #8]
c0d02244:	6830      	ldr	r0, [r6, #0]
c0d02246:	2800      	cmp	r0, #0
c0d02248:	d100      	bne.n	c0d0224c <io_event+0x190>
c0d0224a:	e18c      	b.n	c0d02566 <io_event+0x4aa>
c0d0224c:	69f0      	ldr	r0, [r6, #28]
c0d0224e:	42a8      	cmp	r0, r5
c0d02250:	d100      	bne.n	c0d02254 <io_event+0x198>
c0d02252:	e188      	b.n	c0d02566 <io_event+0x4aa>
c0d02254:	2800      	cmp	r0, #0
c0d02256:	d100      	bne.n	c0d0225a <io_event+0x19e>
c0d02258:	e185      	b.n	c0d02566 <io_event+0x4aa>
c0d0225a:	2000      	movs	r0, #0
c0d0225c:	6871      	ldr	r1, [r6, #4]
c0d0225e:	4288      	cmp	r0, r1
c0d02260:	d300      	bcc.n	c0d02264 <io_event+0x1a8>
c0d02262:	e180      	b.n	c0d02566 <io_event+0x4aa>
c0d02264:	f002 fcf6 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d02268:	2800      	cmp	r0, #0
c0d0226a:	d000      	beq.n	c0d0226e <io_event+0x1b2>
c0d0226c:	e17b      	b.n	c0d02566 <io_event+0x4aa>
c0d0226e:	68b0      	ldr	r0, [r6, #8]
c0d02270:	68f1      	ldr	r1, [r6, #12]
c0d02272:	2438      	movs	r4, #56	; 0x38
c0d02274:	4360      	muls	r0, r4
c0d02276:	6832      	ldr	r2, [r6, #0]
c0d02278:	1810      	adds	r0, r2, r0
c0d0227a:	2900      	cmp	r1, #0
c0d0227c:	d002      	beq.n	c0d02284 <io_event+0x1c8>
c0d0227e:	4788      	blx	r1
c0d02280:	2800      	cmp	r0, #0
c0d02282:	d007      	beq.n	c0d02294 <io_event+0x1d8>
c0d02284:	2801      	cmp	r0, #1
c0d02286:	d103      	bne.n	c0d02290 <io_event+0x1d4>
c0d02288:	68b0      	ldr	r0, [r6, #8]
c0d0228a:	4344      	muls	r4, r0
c0d0228c:	6830      	ldr	r0, [r6, #0]
c0d0228e:	1900      	adds	r0, r0, r4
c0d02290:	f001 f8e8 	bl	c0d03464 <io_seproxyhal_display>
c0d02294:	68b0      	ldr	r0, [r6, #8]
c0d02296:	1c40      	adds	r0, r0, #1
c0d02298:	60b0      	str	r0, [r6, #8]
c0d0229a:	6831      	ldr	r1, [r6, #0]
c0d0229c:	2900      	cmp	r1, #0
c0d0229e:	d1dd      	bne.n	c0d0225c <io_event+0x1a0>
c0d022a0:	e161      	b.n	c0d02566 <io_event+0x4aa>
  default:
    UX_DEFAULT_EVENT();
    break;

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
c0d022a2:	4ef0      	ldr	r6, [pc, #960]	; (c0d02664 <io_event+0x5a8>)
c0d022a4:	2400      	movs	r4, #0
c0d022a6:	61f4      	str	r4, [r6, #28]
c0d022a8:	2001      	movs	r0, #1
c0d022aa:	7630      	strb	r0, [r6, #24]
c0d022ac:	4630      	mov	r0, r6
c0d022ae:	3018      	adds	r0, #24
c0d022b0:	f002 fc76 	bl	c0d04ba0 <os_ux>
c0d022b4:	61f0      	str	r0, [r6, #28]
c0d022b6:	f002 fa55 	bl	c0d04764 <ux_check_status_default>
c0d022ba:	69f0      	ldr	r0, [r6, #28]
c0d022bc:	4dea      	ldr	r5, [pc, #936]	; (c0d02668 <io_event+0x5ac>)
c0d022be:	42a8      	cmp	r0, r5
c0d022c0:	d100      	bne.n	c0d022c4 <io_event+0x208>
c0d022c2:	e150      	b.n	c0d02566 <io_event+0x4aa>
c0d022c4:	49e6      	ldr	r1, [pc, #920]	; (c0d02660 <io_event+0x5a4>)
c0d022c6:	4288      	cmp	r0, r1
c0d022c8:	d100      	bne.n	c0d022cc <io_event+0x210>
c0d022ca:	e160      	b.n	c0d0258e <io_event+0x4d2>
c0d022cc:	2800      	cmp	r0, #0
c0d022ce:	d100      	bne.n	c0d022d2 <io_event+0x216>
c0d022d0:	e149      	b.n	c0d02566 <io_event+0x4aa>
c0d022d2:	6830      	ldr	r0, [r6, #0]
c0d022d4:	2800      	cmp	r0, #0
c0d022d6:	d100      	bne.n	c0d022da <io_event+0x21e>
c0d022d8:	e13f      	b.n	c0d0255a <io_event+0x49e>
c0d022da:	68b0      	ldr	r0, [r6, #8]
c0d022dc:	6871      	ldr	r1, [r6, #4]
c0d022de:	4288      	cmp	r0, r1
c0d022e0:	d300      	bcc.n	c0d022e4 <io_event+0x228>
c0d022e2:	e13a      	b.n	c0d0255a <io_event+0x49e>
c0d022e4:	f002 fcb6 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d022e8:	2800      	cmp	r0, #0
c0d022ea:	d000      	beq.n	c0d022ee <io_event+0x232>
c0d022ec:	e135      	b.n	c0d0255a <io_event+0x49e>
c0d022ee:	68b0      	ldr	r0, [r6, #8]
c0d022f0:	68f1      	ldr	r1, [r6, #12]
c0d022f2:	2438      	movs	r4, #56	; 0x38
c0d022f4:	4360      	muls	r0, r4
c0d022f6:	6832      	ldr	r2, [r6, #0]
c0d022f8:	1810      	adds	r0, r2, r0
c0d022fa:	2900      	cmp	r1, #0
c0d022fc:	d002      	beq.n	c0d02304 <io_event+0x248>
c0d022fe:	4788      	blx	r1
c0d02300:	2800      	cmp	r0, #0
c0d02302:	d007      	beq.n	c0d02314 <io_event+0x258>
c0d02304:	2801      	cmp	r0, #1
c0d02306:	d103      	bne.n	c0d02310 <io_event+0x254>
c0d02308:	68b0      	ldr	r0, [r6, #8]
c0d0230a:	4344      	muls	r4, r0
c0d0230c:	6830      	ldr	r0, [r6, #0]
c0d0230e:	1900      	adds	r0, r0, r4
c0d02310:	f001 f8a8 	bl	c0d03464 <io_seproxyhal_display>
c0d02314:	68b0      	ldr	r0, [r6, #8]
c0d02316:	1c40      	adds	r0, r0, #1
c0d02318:	60b0      	str	r0, [r6, #8]
c0d0231a:	6831      	ldr	r1, [r6, #0]
c0d0231c:	2900      	cmp	r1, #0
c0d0231e:	d1dd      	bne.n	c0d022dc <io_event+0x220>
c0d02320:	e11b      	b.n	c0d0255a <io_event+0x49e>
    break;


  // other events are propagated to the UX just in case
  default:
    UX_DEFAULT_EVENT();
c0d02322:	4ed0      	ldr	r6, [pc, #832]	; (c0d02664 <io_event+0x5a8>)
c0d02324:	2400      	movs	r4, #0
c0d02326:	61f4      	str	r4, [r6, #28]
c0d02328:	2001      	movs	r0, #1
c0d0232a:	7630      	strb	r0, [r6, #24]
c0d0232c:	4630      	mov	r0, r6
c0d0232e:	3018      	adds	r0, #24
c0d02330:	f002 fc36 	bl	c0d04ba0 <os_ux>
c0d02334:	61f0      	str	r0, [r6, #28]
c0d02336:	f002 fa15 	bl	c0d04764 <ux_check_status_default>
c0d0233a:	69f0      	ldr	r0, [r6, #28]
c0d0233c:	42a8      	cmp	r0, r5
c0d0233e:	d16f      	bne.n	c0d02420 <io_event+0x364>
c0d02340:	f001 fd4a 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d02344:	f001 fd4e 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d02348:	60b4      	str	r4, [r6, #8]
c0d0234a:	6830      	ldr	r0, [r6, #0]
c0d0234c:	2800      	cmp	r0, #0
c0d0234e:	d100      	bne.n	c0d02352 <io_event+0x296>
c0d02350:	e109      	b.n	c0d02566 <io_event+0x4aa>
c0d02352:	69f0      	ldr	r0, [r6, #28]
c0d02354:	49c4      	ldr	r1, [pc, #784]	; (c0d02668 <io_event+0x5ac>)
c0d02356:	4288      	cmp	r0, r1
c0d02358:	d100      	bne.n	c0d0235c <io_event+0x2a0>
c0d0235a:	e104      	b.n	c0d02566 <io_event+0x4aa>
c0d0235c:	2800      	cmp	r0, #0
c0d0235e:	d100      	bne.n	c0d02362 <io_event+0x2a6>
c0d02360:	e101      	b.n	c0d02566 <io_event+0x4aa>
c0d02362:	2000      	movs	r0, #0
c0d02364:	6871      	ldr	r1, [r6, #4]
c0d02366:	4288      	cmp	r0, r1
c0d02368:	d300      	bcc.n	c0d0236c <io_event+0x2b0>
c0d0236a:	e0fc      	b.n	c0d02566 <io_event+0x4aa>
c0d0236c:	f002 fc72 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d02370:	2800      	cmp	r0, #0
c0d02372:	d000      	beq.n	c0d02376 <io_event+0x2ba>
c0d02374:	e0f7      	b.n	c0d02566 <io_event+0x4aa>
c0d02376:	68b0      	ldr	r0, [r6, #8]
c0d02378:	68f1      	ldr	r1, [r6, #12]
c0d0237a:	2438      	movs	r4, #56	; 0x38
c0d0237c:	4360      	muls	r0, r4
c0d0237e:	6832      	ldr	r2, [r6, #0]
c0d02380:	1810      	adds	r0, r2, r0
c0d02382:	2900      	cmp	r1, #0
c0d02384:	d002      	beq.n	c0d0238c <io_event+0x2d0>
c0d02386:	4788      	blx	r1
c0d02388:	2800      	cmp	r0, #0
c0d0238a:	d007      	beq.n	c0d0239c <io_event+0x2e0>
c0d0238c:	2801      	cmp	r0, #1
c0d0238e:	d103      	bne.n	c0d02398 <io_event+0x2dc>
c0d02390:	68b0      	ldr	r0, [r6, #8]
c0d02392:	4344      	muls	r4, r0
c0d02394:	6830      	ldr	r0, [r6, #0]
c0d02396:	1900      	adds	r0, r0, r4
c0d02398:	f001 f864 	bl	c0d03464 <io_seproxyhal_display>
c0d0239c:	68b0      	ldr	r0, [r6, #8]
c0d0239e:	1c40      	adds	r0, r0, #1
c0d023a0:	60b0      	str	r0, [r6, #8]
c0d023a2:	6831      	ldr	r1, [r6, #0]
c0d023a4:	2900      	cmp	r1, #0
c0d023a6:	d1dd      	bne.n	c0d02364 <io_event+0x2a8>
c0d023a8:	e0dd      	b.n	c0d02566 <io_event+0x4aa>

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
    break;
  case SEPROXYHAL_TAG_TICKER_EVENT:
    UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, 
c0d023aa:	6970      	ldr	r0, [r6, #20]
c0d023ac:	2800      	cmp	r0, #0
c0d023ae:	d008      	beq.n	c0d023c2 <io_event+0x306>
c0d023b0:	2164      	movs	r1, #100	; 0x64
c0d023b2:	2864      	cmp	r0, #100	; 0x64
c0d023b4:	4602      	mov	r2, r0
c0d023b6:	d300      	bcc.n	c0d023ba <io_event+0x2fe>
c0d023b8:	460a      	mov	r2, r1
c0d023ba:	1a80      	subs	r0, r0, r2
c0d023bc:	6170      	str	r0, [r6, #20]
c0d023be:	d100      	bne.n	c0d023c2 <io_event+0x306>
c0d023c0:	e114      	b.n	c0d025ec <io_event+0x530>
c0d023c2:	48a9      	ldr	r0, [pc, #676]	; (c0d02668 <io_event+0x5ac>)
c0d023c4:	4287      	cmp	r7, r0
c0d023c6:	d100      	bne.n	c0d023ca <io_event+0x30e>
c0d023c8:	e0cd      	b.n	c0d02566 <io_event+0x4aa>
c0d023ca:	2f00      	cmp	r7, #0
c0d023cc:	d100      	bne.n	c0d023d0 <io_event+0x314>
c0d023ce:	e0ca      	b.n	c0d02566 <io_event+0x4aa>
c0d023d0:	6830      	ldr	r0, [r6, #0]
c0d023d2:	2800      	cmp	r0, #0
c0d023d4:	d100      	bne.n	c0d023d8 <io_event+0x31c>
c0d023d6:	e0c0      	b.n	c0d0255a <io_event+0x49e>
c0d023d8:	68b0      	ldr	r0, [r6, #8]
c0d023da:	6871      	ldr	r1, [r6, #4]
c0d023dc:	4288      	cmp	r0, r1
c0d023de:	d300      	bcc.n	c0d023e2 <io_event+0x326>
c0d023e0:	e0bb      	b.n	c0d0255a <io_event+0x49e>
c0d023e2:	f002 fc37 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d023e6:	2800      	cmp	r0, #0
c0d023e8:	d000      	beq.n	c0d023ec <io_event+0x330>
c0d023ea:	e0b6      	b.n	c0d0255a <io_event+0x49e>
c0d023ec:	68b0      	ldr	r0, [r6, #8]
c0d023ee:	68f1      	ldr	r1, [r6, #12]
c0d023f0:	2438      	movs	r4, #56	; 0x38
c0d023f2:	4360      	muls	r0, r4
c0d023f4:	6832      	ldr	r2, [r6, #0]
c0d023f6:	1810      	adds	r0, r2, r0
c0d023f8:	2900      	cmp	r1, #0
c0d023fa:	d002      	beq.n	c0d02402 <io_event+0x346>
c0d023fc:	4788      	blx	r1
c0d023fe:	2800      	cmp	r0, #0
c0d02400:	d007      	beq.n	c0d02412 <io_event+0x356>
c0d02402:	2801      	cmp	r0, #1
c0d02404:	d103      	bne.n	c0d0240e <io_event+0x352>
c0d02406:	68b0      	ldr	r0, [r6, #8]
c0d02408:	4344      	muls	r4, r0
c0d0240a:	6830      	ldr	r0, [r6, #0]
c0d0240c:	1900      	adds	r0, r0, r4
c0d0240e:	f001 f829 	bl	c0d03464 <io_seproxyhal_display>
c0d02412:	68b0      	ldr	r0, [r6, #8]
c0d02414:	1c40      	adds	r0, r0, #1
c0d02416:	60b0      	str	r0, [r6, #8]
c0d02418:	6831      	ldr	r1, [r6, #0]
c0d0241a:	2900      	cmp	r1, #0
c0d0241c:	d1dd      	bne.n	c0d023da <io_event+0x31e>
c0d0241e:	e09c      	b.n	c0d0255a <io_event+0x49e>
    break;


  // other events are propagated to the UX just in case
  default:
    UX_DEFAULT_EVENT();
c0d02420:	6830      	ldr	r0, [r6, #0]
c0d02422:	2800      	cmp	r0, #0
c0d02424:	d100      	bne.n	c0d02428 <io_event+0x36c>
c0d02426:	e098      	b.n	c0d0255a <io_event+0x49e>
c0d02428:	68b0      	ldr	r0, [r6, #8]
c0d0242a:	6871      	ldr	r1, [r6, #4]
c0d0242c:	4288      	cmp	r0, r1
c0d0242e:	d300      	bcc.n	c0d02432 <io_event+0x376>
c0d02430:	e093      	b.n	c0d0255a <io_event+0x49e>
c0d02432:	f002 fc0f 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d02436:	2800      	cmp	r0, #0
c0d02438:	d000      	beq.n	c0d0243c <io_event+0x380>
c0d0243a:	e08e      	b.n	c0d0255a <io_event+0x49e>
c0d0243c:	68b0      	ldr	r0, [r6, #8]
c0d0243e:	68f1      	ldr	r1, [r6, #12]
c0d02440:	2438      	movs	r4, #56	; 0x38
c0d02442:	4360      	muls	r0, r4
c0d02444:	6832      	ldr	r2, [r6, #0]
c0d02446:	1810      	adds	r0, r2, r0
c0d02448:	2900      	cmp	r1, #0
c0d0244a:	d002      	beq.n	c0d02452 <io_event+0x396>
c0d0244c:	4788      	blx	r1
c0d0244e:	2800      	cmp	r0, #0
c0d02450:	d007      	beq.n	c0d02462 <io_event+0x3a6>
c0d02452:	2801      	cmp	r0, #1
c0d02454:	d103      	bne.n	c0d0245e <io_event+0x3a2>
c0d02456:	68b0      	ldr	r0, [r6, #8]
c0d02458:	4344      	muls	r4, r0
c0d0245a:	6830      	ldr	r0, [r6, #0]
c0d0245c:	1900      	adds	r0, r0, r4
c0d0245e:	f001 f801 	bl	c0d03464 <io_seproxyhal_display>
c0d02462:	68b0      	ldr	r0, [r6, #8]
c0d02464:	1c40      	adds	r0, r0, #1
c0d02466:	60b0      	str	r0, [r6, #8]
c0d02468:	6831      	ldr	r1, [r6, #0]
c0d0246a:	2900      	cmp	r1, #0
c0d0246c:	d1dd      	bne.n	c0d0242a <io_event+0x36e>
c0d0246e:	e074      	b.n	c0d0255a <io_event+0x49e>
c0d02470:	20001800 	.word	0x20001800
c0d02474:	b0105055 	.word	0xb0105055
c0d02478:	20001880 	.word	0x20001880
c0d0247c:	b0105044 	.word	0xb0105044
  // nothing done with the event, throw an error on the transport layer if
  // needed
  // can't have more than one tag in the reply, not supported yet.
  switch (G_io_seproxyhal_spi_buffer[0]) {
  case SEPROXYHAL_TAG_FINGER_EVENT:
    UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0d02480:	88b0      	ldrh	r0, [r6, #4]
c0d02482:	9003      	str	r0, [sp, #12]
c0d02484:	6830      	ldr	r0, [r6, #0]
c0d02486:	9002      	str	r0, [sp, #8]
c0d02488:	79fb      	ldrb	r3, [r7, #7]
c0d0248a:	79bc      	ldrb	r4, [r7, #6]
c0d0248c:	797a      	ldrb	r2, [r7, #5]
c0d0248e:	793d      	ldrb	r5, [r7, #4]
c0d02490:	78ff      	ldrb	r7, [r7, #3]
c0d02492:	68f1      	ldr	r1, [r6, #12]
c0d02494:	4668      	mov	r0, sp
c0d02496:	6007      	str	r7, [r0, #0]
c0d02498:	6041      	str	r1, [r0, #4]
c0d0249a:	0228      	lsls	r0, r5, #8
c0d0249c:	1880      	adds	r0, r0, r2
c0d0249e:	b282      	uxth	r2, r0
c0d024a0:	0220      	lsls	r0, r4, #8
c0d024a2:	18c0      	adds	r0, r0, r3
c0d024a4:	b283      	uxth	r3, r0
c0d024a6:	9802      	ldr	r0, [sp, #8]
c0d024a8:	9903      	ldr	r1, [sp, #12]
c0d024aa:	f001 fd13 	bl	c0d03ed4 <io_seproxyhal_touch_element_callback>
c0d024ae:	6830      	ldr	r0, [r6, #0]
c0d024b0:	2800      	cmp	r0, #0
c0d024b2:	d052      	beq.n	c0d0255a <io_event+0x49e>
c0d024b4:	68b0      	ldr	r0, [r6, #8]
c0d024b6:	6871      	ldr	r1, [r6, #4]
c0d024b8:	4288      	cmp	r0, r1
c0d024ba:	d24e      	bcs.n	c0d0255a <io_event+0x49e>
c0d024bc:	f002 fbca 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d024c0:	2800      	cmp	r0, #0
c0d024c2:	d14a      	bne.n	c0d0255a <io_event+0x49e>
c0d024c4:	68b0      	ldr	r0, [r6, #8]
c0d024c6:	68f1      	ldr	r1, [r6, #12]
c0d024c8:	2438      	movs	r4, #56	; 0x38
c0d024ca:	4360      	muls	r0, r4
c0d024cc:	6832      	ldr	r2, [r6, #0]
c0d024ce:	1810      	adds	r0, r2, r0
c0d024d0:	2900      	cmp	r1, #0
c0d024d2:	d002      	beq.n	c0d024da <io_event+0x41e>
c0d024d4:	4788      	blx	r1
c0d024d6:	2800      	cmp	r0, #0
c0d024d8:	d007      	beq.n	c0d024ea <io_event+0x42e>
c0d024da:	2801      	cmp	r0, #1
c0d024dc:	d103      	bne.n	c0d024e6 <io_event+0x42a>
c0d024de:	68b0      	ldr	r0, [r6, #8]
c0d024e0:	4344      	muls	r4, r0
c0d024e2:	6830      	ldr	r0, [r6, #0]
c0d024e4:	1900      	adds	r0, r0, r4
c0d024e6:	f000 ffbd 	bl	c0d03464 <io_seproxyhal_display>
c0d024ea:	68b0      	ldr	r0, [r6, #8]
c0d024ec:	1c40      	adds	r0, r0, #1
c0d024ee:	60b0      	str	r0, [r6, #8]
c0d024f0:	6831      	ldr	r1, [r6, #0]
c0d024f2:	2900      	cmp	r1, #0
c0d024f4:	d1df      	bne.n	c0d024b6 <io_event+0x3fa>
c0d024f6:	e030      	b.n	c0d0255a <io_event+0x49e>
c0d024f8:	b0105055 	.word	0xb0105055
c0d024fc:	20001880 	.word	0x20001880
c0d02500:	b0105044 	.word	0xb0105044
    break;
  // power off if long push, else pass to the application callback if any
  case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT: // for Nano S
    UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0d02504:	6930      	ldr	r0, [r6, #16]
c0d02506:	2800      	cmp	r0, #0
c0d02508:	d003      	beq.n	c0d02512 <io_event+0x456>
c0d0250a:	78f9      	ldrb	r1, [r7, #3]
c0d0250c:	0849      	lsrs	r1, r1, #1
c0d0250e:	f001 fdef 	bl	c0d040f0 <io_seproxyhal_button_push>
c0d02512:	6830      	ldr	r0, [r6, #0]
c0d02514:	2800      	cmp	r0, #0
c0d02516:	d020      	beq.n	c0d0255a <io_event+0x49e>
c0d02518:	68b0      	ldr	r0, [r6, #8]
c0d0251a:	6871      	ldr	r1, [r6, #4]
c0d0251c:	4288      	cmp	r0, r1
c0d0251e:	d21c      	bcs.n	c0d0255a <io_event+0x49e>
c0d02520:	f002 fb98 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d02524:	2800      	cmp	r0, #0
c0d02526:	d118      	bne.n	c0d0255a <io_event+0x49e>
c0d02528:	68b0      	ldr	r0, [r6, #8]
c0d0252a:	68f1      	ldr	r1, [r6, #12]
c0d0252c:	2438      	movs	r4, #56	; 0x38
c0d0252e:	4360      	muls	r0, r4
c0d02530:	6832      	ldr	r2, [r6, #0]
c0d02532:	1810      	adds	r0, r2, r0
c0d02534:	2900      	cmp	r1, #0
c0d02536:	d002      	beq.n	c0d0253e <io_event+0x482>
c0d02538:	4788      	blx	r1
c0d0253a:	2800      	cmp	r0, #0
c0d0253c:	d007      	beq.n	c0d0254e <io_event+0x492>
c0d0253e:	2801      	cmp	r0, #1
c0d02540:	d103      	bne.n	c0d0254a <io_event+0x48e>
c0d02542:	68b0      	ldr	r0, [r6, #8]
c0d02544:	4344      	muls	r4, r0
c0d02546:	6830      	ldr	r0, [r6, #0]
c0d02548:	1900      	adds	r0, r0, r4
c0d0254a:	f000 ff8b 	bl	c0d03464 <io_seproxyhal_display>
c0d0254e:	68b0      	ldr	r0, [r6, #8]
c0d02550:	1c40      	adds	r0, r0, #1
c0d02552:	60b0      	str	r0, [r6, #8]
c0d02554:	6831      	ldr	r1, [r6, #0]
c0d02556:	2900      	cmp	r1, #0
c0d02558:	d1df      	bne.n	c0d0251a <io_event+0x45e>
c0d0255a:	6870      	ldr	r0, [r6, #4]
c0d0255c:	68b1      	ldr	r1, [r6, #8]
c0d0255e:	4281      	cmp	r1, r0
c0d02560:	d301      	bcc.n	c0d02566 <io_event+0x4aa>
c0d02562:	f002 fb77 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
    });
    break;
  }

  // close the event if not done previously (by a display or whatever)
  if (!io_seproxyhal_spi_is_status_sent()) {
c0d02566:	f002 fb75 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d0256a:	2800      	cmp	r0, #0
c0d0256c:	d101      	bne.n	c0d02572 <io_event+0x4b6>
    io_seproxyhal_general_status();
c0d0256e:	f001 fae9 	bl	c0d03b44 <io_seproxyhal_general_status>
c0d02572:	4c3b      	ldr	r4, [pc, #236]	; (c0d02660 <io_event+0x5a4>)
  }

  s_after =  os_global_pin_is_validated();
  
  if (s_before!=s_after) {
    if (s_after == PIN_VERIFIED) {
c0d02574:	3c44      	subs	r4, #68	; 0x44
  // close the event if not done previously (by a display or whatever)
  if (!io_seproxyhal_spi_is_status_sent()) {
    io_seproxyhal_general_status();
  }

  s_after =  os_global_pin_is_validated();
c0d02576:	f002 fae7 	bl	c0d04b48 <os_global_pin_is_validated>
  
  if (s_before!=s_after) {
c0d0257a:	9904      	ldr	r1, [sp, #16]
c0d0257c:	4281      	cmp	r1, r0
c0d0257e:	d003      	beq.n	c0d02588 <io_event+0x4cc>
c0d02580:	42a0      	cmp	r0, r4
c0d02582:	d101      	bne.n	c0d02588 <io_event+0x4cc>
    if (s_after == PIN_VERIFIED) {
      monero_init_private_key();
c0d02584:	f7fe fee2 	bl	c0d0134c <monero_init_private_key>
c0d02588:	2001      	movs	r0, #1
      //monero_wipe_private_key();
    }
  }
  
  // command has been processed, DO NOT reset the current APDU transport
  return 1;
c0d0258a:	b005      	add	sp, #20
c0d0258c:	bdf0      	pop	{r4, r5, r6, r7, pc}
  default:
    UX_DEFAULT_EVENT();
    break;

  case SEPROXYHAL_TAG_DISPLAY_PROCESSED_EVENT:
    UX_DISPLAYED_EVENT({});
c0d0258e:	f001 fc23 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d02592:	f001 fc27 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d02596:	60b4      	str	r4, [r6, #8]
c0d02598:	6830      	ldr	r0, [r6, #0]
c0d0259a:	2800      	cmp	r0, #0
c0d0259c:	d0e3      	beq.n	c0d02566 <io_event+0x4aa>
c0d0259e:	69f0      	ldr	r0, [r6, #28]
c0d025a0:	42a8      	cmp	r0, r5
c0d025a2:	d0e0      	beq.n	c0d02566 <io_event+0x4aa>
c0d025a4:	2800      	cmp	r0, #0
c0d025a6:	d0de      	beq.n	c0d02566 <io_event+0x4aa>
c0d025a8:	2000      	movs	r0, #0
c0d025aa:	6871      	ldr	r1, [r6, #4]
c0d025ac:	4288      	cmp	r0, r1
c0d025ae:	d2da      	bcs.n	c0d02566 <io_event+0x4aa>
c0d025b0:	f002 fb50 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d025b4:	2800      	cmp	r0, #0
c0d025b6:	d1d6      	bne.n	c0d02566 <io_event+0x4aa>
c0d025b8:	68b0      	ldr	r0, [r6, #8]
c0d025ba:	68f1      	ldr	r1, [r6, #12]
c0d025bc:	2438      	movs	r4, #56	; 0x38
c0d025be:	4360      	muls	r0, r4
c0d025c0:	6832      	ldr	r2, [r6, #0]
c0d025c2:	1810      	adds	r0, r2, r0
c0d025c4:	2900      	cmp	r1, #0
c0d025c6:	d002      	beq.n	c0d025ce <io_event+0x512>
c0d025c8:	4788      	blx	r1
c0d025ca:	2800      	cmp	r0, #0
c0d025cc:	d007      	beq.n	c0d025de <io_event+0x522>
c0d025ce:	2801      	cmp	r0, #1
c0d025d0:	d103      	bne.n	c0d025da <io_event+0x51e>
c0d025d2:	68b0      	ldr	r0, [r6, #8]
c0d025d4:	4344      	muls	r4, r0
c0d025d6:	6830      	ldr	r0, [r6, #0]
c0d025d8:	1900      	adds	r0, r0, r4
c0d025da:	f000 ff43 	bl	c0d03464 <io_seproxyhal_display>
c0d025de:	68b0      	ldr	r0, [r6, #8]
c0d025e0:	1c40      	adds	r0, r0, #1
c0d025e2:	60b0      	str	r0, [r6, #8]
c0d025e4:	6831      	ldr	r1, [r6, #0]
c0d025e6:	2900      	cmp	r1, #0
c0d025e8:	d1df      	bne.n	c0d025aa <io_event+0x4ee>
c0d025ea:	e7bc      	b.n	c0d02566 <io_event+0x4aa>
c0d025ec:	4d1e      	ldr	r5, [pc, #120]	; (c0d02668 <io_event+0x5ac>)
    break;
  case SEPROXYHAL_TAG_TICKER_EVENT:
    UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, 
c0d025ee:	42af      	cmp	r7, r5
c0d025f0:	d0b9      	beq.n	c0d02566 <io_event+0x4aa>
c0d025f2:	2f00      	cmp	r7, #0
c0d025f4:	d0b7      	beq.n	c0d02566 <io_event+0x4aa>
c0d025f6:	f001 fbef 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d025fa:	f001 fbf3 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d025fe:	60b4      	str	r4, [r6, #8]
c0d02600:	6830      	ldr	r0, [r6, #0]
c0d02602:	2800      	cmp	r0, #0
c0d02604:	d100      	bne.n	c0d02608 <io_event+0x54c>
c0d02606:	e6dc      	b.n	c0d023c2 <io_event+0x306>
c0d02608:	69f0      	ldr	r0, [r6, #28]
c0d0260a:	42a8      	cmp	r0, r5
c0d0260c:	d100      	bne.n	c0d02610 <io_event+0x554>
c0d0260e:	e6d8      	b.n	c0d023c2 <io_event+0x306>
c0d02610:	2800      	cmp	r0, #0
c0d02612:	d100      	bne.n	c0d02616 <io_event+0x55a>
c0d02614:	e6d5      	b.n	c0d023c2 <io_event+0x306>
c0d02616:	2000      	movs	r0, #0
c0d02618:	6871      	ldr	r1, [r6, #4]
c0d0261a:	4288      	cmp	r0, r1
c0d0261c:	d300      	bcc.n	c0d02620 <io_event+0x564>
c0d0261e:	e6d0      	b.n	c0d023c2 <io_event+0x306>
c0d02620:	f002 fb18 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d02624:	2800      	cmp	r0, #0
c0d02626:	d000      	beq.n	c0d0262a <io_event+0x56e>
c0d02628:	e6cb      	b.n	c0d023c2 <io_event+0x306>
c0d0262a:	68b0      	ldr	r0, [r6, #8]
c0d0262c:	68f1      	ldr	r1, [r6, #12]
c0d0262e:	2438      	movs	r4, #56	; 0x38
c0d02630:	4360      	muls	r0, r4
c0d02632:	6832      	ldr	r2, [r6, #0]
c0d02634:	1810      	adds	r0, r2, r0
c0d02636:	2900      	cmp	r1, #0
c0d02638:	d002      	beq.n	c0d02640 <io_event+0x584>
c0d0263a:	4788      	blx	r1
c0d0263c:	2800      	cmp	r0, #0
c0d0263e:	d007      	beq.n	c0d02650 <io_event+0x594>
c0d02640:	2801      	cmp	r0, #1
c0d02642:	d103      	bne.n	c0d0264c <io_event+0x590>
c0d02644:	68b0      	ldr	r0, [r6, #8]
c0d02646:	4344      	muls	r4, r0
c0d02648:	6830      	ldr	r0, [r6, #0]
c0d0264a:	1900      	adds	r0, r0, r4
c0d0264c:	f000 ff0a 	bl	c0d03464 <io_seproxyhal_display>
c0d02650:	68b0      	ldr	r0, [r6, #8]
c0d02652:	1c40      	adds	r0, r0, #1
c0d02654:	60b0      	str	r0, [r6, #8]
c0d02656:	6831      	ldr	r1, [r6, #0]
c0d02658:	2900      	cmp	r1, #0
c0d0265a:	d1dd      	bne.n	c0d02618 <io_event+0x55c>
c0d0265c:	e6b1      	b.n	c0d023c2 <io_event+0x306>
c0d0265e:	46c0      	nop			; (mov r8, r8)
c0d02660:	b0105055 	.word	0xb0105055
c0d02664:	20001880 	.word	0x20001880
c0d02668:	b0105044 	.word	0xb0105044

c0d0266c <io_exchange_al>:
  
  // command has been processed, DO NOT reset the current APDU transport
  return 1;
}

unsigned short io_exchange_al(unsigned char channel, unsigned short tx_len) {
c0d0266c:	b5b0      	push	{r4, r5, r7, lr}
c0d0266e:	4605      	mov	r5, r0
c0d02670:	2007      	movs	r0, #7
  switch (channel & ~(IO_FLAGS)) {
c0d02672:	4028      	ands	r0, r5
c0d02674:	2400      	movs	r4, #0
c0d02676:	2801      	cmp	r0, #1
c0d02678:	d014      	beq.n	c0d026a4 <io_exchange_al+0x38>
c0d0267a:	2802      	cmp	r0, #2
c0d0267c:	d114      	bne.n	c0d026a8 <io_exchange_al+0x3c>
  case CHANNEL_KEYBOARD:
    break;

    // multiplexed io exchange over a SPI channel and TLV encapsulated protocol
  case CHANNEL_SPI:
    if (tx_len) {
c0d0267e:	2900      	cmp	r1, #0
c0d02680:	d009      	beq.n	c0d02696 <io_exchange_al+0x2a>
      io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d02682:	480b      	ldr	r0, [pc, #44]	; (c0d026b0 <io_exchange_al+0x44>)
c0d02684:	f002 fad0 	bl	c0d04c28 <io_seproxyhal_spi_send>

      if (channel & IO_RESET_AFTER_REPLIED) {
c0d02688:	b268      	sxtb	r0, r5
c0d0268a:	2800      	cmp	r0, #0
c0d0268c:	da0a      	bge.n	c0d026a4 <io_exchange_al+0x38>
        reset();
c0d0268e:	f002 f899 	bl	c0d047c4 <reset>
c0d02692:	2400      	movs	r4, #0
c0d02694:	e006      	b.n	c0d026a4 <io_exchange_al+0x38>
c0d02696:	21ff      	movs	r1, #255	; 0xff
c0d02698:	3152      	adds	r1, #82	; 0x52
      }
      return 0; // nothing received from the master so far (it's a tx
      // transaction)
    } else {
      return io_seproxyhal_spi_recv(G_io_apdu_buffer,
c0d0269a:	4805      	ldr	r0, [pc, #20]	; (c0d026b0 <io_exchange_al+0x44>)
c0d0269c:	2200      	movs	r2, #0
c0d0269e:	f002 faef 	bl	c0d04c80 <io_seproxyhal_spi_recv>
c0d026a2:	4604      	mov	r4, r0
  default:
    THROW(INVALID_PARAMETER);
    return 0;
  }
  return 0;
}
c0d026a4:	4620      	mov	r0, r4
c0d026a6:	bdb0      	pop	{r4, r5, r7, pc}
c0d026a8:	2002      	movs	r0, #2
      return io_seproxyhal_spi_recv(G_io_apdu_buffer,
                                    sizeof(G_io_apdu_buffer), 0);
    }

  default:
    THROW(INVALID_PARAMETER);
c0d026aa:	f001 fa3f 	bl	c0d03b2c <os_longjmp>
c0d026ae:	46c0      	nop			; (mov r8, r8)
c0d026b0:	2000216c 	.word	0x2000216c

c0d026b4 <app_exit>:
    return 0;
  }
  return 0;
}

void app_exit(void) {
c0d026b4:	b510      	push	{r4, lr}
c0d026b6:	b08c      	sub	sp, #48	; 0x30
c0d026b8:	ac01      	add	r4, sp, #4
  BEGIN_TRY_L(exit) {
    TRY_L(exit) {
c0d026ba:	4620      	mov	r0, r4
c0d026bc:	f004 f840 	bl	c0d06740 <setjmp>
c0d026c0:	8520      	strh	r0, [r4, #40]	; 0x28
c0d026c2:	0400      	lsls	r0, r0, #16
c0d026c4:	d106      	bne.n	c0d026d4 <app_exit+0x20>
c0d026c6:	a801      	add	r0, sp, #4
c0d026c8:	f001 f879 	bl	c0d037be <try_context_set>
c0d026cc:	2000      	movs	r0, #0
c0d026ce:	43c0      	mvns	r0, r0
      os_sched_exit(-1);
c0d026d0:	f002 fa50 	bl	c0d04b74 <os_sched_exit>
    }
    FINALLY_L(exit) {
c0d026d4:	f001 fa2e 	bl	c0d03b34 <try_context_get>
c0d026d8:	a901      	add	r1, sp, #4
c0d026da:	4288      	cmp	r0, r1
c0d026dc:	d103      	bne.n	c0d026e6 <app_exit+0x32>
c0d026de:	f001 fa2b 	bl	c0d03b38 <try_context_get_previous>
c0d026e2:	f001 f86c 	bl	c0d037be <try_context_set>
c0d026e6:	a801      	add	r0, sp, #4
    }
  }
  END_TRY_L(exit);
c0d026e8:	8d00      	ldrh	r0, [r0, #40]	; 0x28
c0d026ea:	2800      	cmp	r0, #0
c0d026ec:	d101      	bne.n	c0d026f2 <app_exit+0x3e>
}
c0d026ee:	b00c      	add	sp, #48	; 0x30
c0d026f0:	bd10      	pop	{r4, pc}
      os_sched_exit(-1);
    }
    FINALLY_L(exit) {
    }
  }
  END_TRY_L(exit);
c0d026f2:	f001 fa1b 	bl	c0d03b2c <os_longjmp>
	...

c0d026f8 <monero_apdu_mlsag_prepare>:
#include "monero_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prepare() {
c0d026f8:	b570      	push	{r4, r5, r6, lr}
c0d026fa:	b0a0      	sub	sp, #128	; 0x80
    unsigned char xin[32];
    unsigned char alpha[32];
    unsigned char mul[32];


    if (G_monero_vstate.io_length>1) {        
c0d026fc:	4c31      	ldr	r4, [pc, #196]	; (c0d027c4 <monero_apdu_mlsag_prepare+0xcc>)
c0d026fe:	8920      	ldrh	r0, [r4, #8]
c0d02700:	2802      	cmp	r0, #2
c0d02702:	d30e      	bcc.n	c0d02722 <monero_apdu_mlsag_prepare+0x2a>
c0d02704:	a818      	add	r0, sp, #96	; 0x60
c0d02706:	2120      	movs	r1, #32
        monero_io_fetch(Hi,32);
c0d02708:	f7fe ff42 	bl	c0d01590 <monero_io_fetch>
c0d0270c:	204f      	movs	r0, #79	; 0x4f
c0d0270e:	0080      	lsls	r0, r0, #2
        if(G_monero_vstate.options &0x40) {
c0d02710:	5c20      	ldrb	r0, [r4, r0]
c0d02712:	0640      	lsls	r0, r0, #25
c0d02714:	d41e      	bmi.n	c0d02754 <monero_apdu_mlsag_prepare+0x5c>
c0d02716:	a810      	add	r0, sp, #64	; 0x40
c0d02718:	2420      	movs	r4, #32
            monero_io_fetch(xin,32);
        } else { 
           monero_io_fetch_decrypt(xin,32); 
c0d0271a:	4621      	mov	r1, r4
c0d0271c:	f7fe ff54 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d02720:	e01d      	b.n	c0d0275e <monero_apdu_mlsag_prepare+0x66>
c0d02722:	2001      	movs	r0, #1
        options = 1;
    }  else {
        options = 0;
    }

    monero_io_discard(1);
c0d02724:	f7fe fea6 	bl	c0d01474 <monero_io_discard>
c0d02728:	ad08      	add	r5, sp, #32
c0d0272a:	2420      	movs	r4, #32
    
    //ai
    monero_rng(alpha, 32);
c0d0272c:	4628      	mov	r0, r5
c0d0272e:	4621      	mov	r1, r4
c0d02730:	f7fd fdec 	bl	c0d0030c <monero_rng>
    monero_reduce(alpha, alpha);
c0d02734:	4628      	mov	r0, r5
c0d02736:	4629      	mov	r1, r5
c0d02738:	f7fd fe26 	bl	c0d00388 <monero_reduce>
    monero_io_insert_encrypt(alpha, 32);
c0d0273c:	4628      	mov	r0, r5
c0d0273e:	4621      	mov	r1, r4
c0d02740:	f7fe fed8 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d02744:	466e      	mov	r6, sp

    //ai.G
    monero_ecmul_G(mul, alpha);
c0d02746:	4630      	mov	r0, r6
c0d02748:	4629      	mov	r1, r5
c0d0274a:	f7fe f877 	bl	c0d0083c <monero_ecmul_G>
    monero_io_insert(mul,32);
c0d0274e:	4630      	mov	r0, r6
c0d02750:	4621      	mov	r1, r4
c0d02752:	e030      	b.n	c0d027b6 <monero_apdu_mlsag_prepare+0xbe>
c0d02754:	a810      	add	r0, sp, #64	; 0x40
c0d02756:	2420      	movs	r4, #32


    if (G_monero_vstate.io_length>1) {        
        monero_io_fetch(Hi,32);
        if(G_monero_vstate.options &0x40) {
            monero_io_fetch(xin,32);
c0d02758:	4621      	mov	r1, r4
c0d0275a:	f7fe ff19 	bl	c0d01590 <monero_io_fetch>
c0d0275e:	2001      	movs	r0, #1
        options = 1;
    }  else {
        options = 0;
    }

    monero_io_discard(1);
c0d02760:	f7fe fe88 	bl	c0d01474 <monero_io_discard>
c0d02764:	ad08      	add	r5, sp, #32
    
    //ai
    monero_rng(alpha, 32);
c0d02766:	4628      	mov	r0, r5
c0d02768:	4621      	mov	r1, r4
c0d0276a:	f7fd fdcf 	bl	c0d0030c <monero_rng>
    monero_reduce(alpha, alpha);
c0d0276e:	4628      	mov	r0, r5
c0d02770:	4629      	mov	r1, r5
c0d02772:	f7fd fe09 	bl	c0d00388 <monero_reduce>
    monero_io_insert_encrypt(alpha, 32);
c0d02776:	4628      	mov	r0, r5
c0d02778:	4621      	mov	r1, r4
c0d0277a:	f7fe febb 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d0277e:	466e      	mov	r6, sp

    //ai.G
    monero_ecmul_G(mul, alpha);
c0d02780:	4630      	mov	r0, r6
c0d02782:	4629      	mov	r1, r5
c0d02784:	f7fe f85a 	bl	c0d0083c <monero_ecmul_G>
    monero_io_insert(mul,32);
c0d02788:	4630      	mov	r0, r6
c0d0278a:	4621      	mov	r1, r4
c0d0278c:	f7fe fe9e 	bl	c0d014cc <monero_io_insert>
c0d02790:	466c      	mov	r4, sp
c0d02792:	ad18      	add	r5, sp, #96	; 0x60
c0d02794:	aa08      	add	r2, sp, #32
       
    if (options) {
        //ai.Hi
        monero_ecmul_k(mul, Hi, alpha);
c0d02796:	4620      	mov	r0, r4
c0d02798:	4629      	mov	r1, r5
c0d0279a:	f7fe f966 	bl	c0d00a6a <monero_ecmul_k>
c0d0279e:	2620      	movs	r6, #32
        monero_io_insert(mul,32);
c0d027a0:	4620      	mov	r0, r4
c0d027a2:	4631      	mov	r1, r6
c0d027a4:	f7fe fe92 	bl	c0d014cc <monero_io_insert>
c0d027a8:	aa10      	add	r2, sp, #64	; 0x40
        //IIi = xin.Hi
        monero_ecmul_k(mul, Hi, xin);
c0d027aa:	4620      	mov	r0, r4
c0d027ac:	4629      	mov	r1, r5
c0d027ae:	f7fe f95c 	bl	c0d00a6a <monero_ecmul_k>
        monero_io_insert(mul,32);
c0d027b2:	4620      	mov	r0, r4
c0d027b4:	4631      	mov	r1, r6
c0d027b6:	f7fe fe89 	bl	c0d014cc <monero_io_insert>
c0d027ba:	2009      	movs	r0, #9
c0d027bc:	0300      	lsls	r0, r0, #12
    }

    return SW_OK;
c0d027be:	b020      	add	sp, #128	; 0x80
c0d027c0:	bd70      	pop	{r4, r5, r6, pc}
c0d027c2:	46c0      	nop			; (mov r8, r8)
c0d027c4:	20001930 	.word	0x20001930

c0d027c8 <monero_apdu_mlsag_hash>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_hash() {
c0d027c8:	b570      	push	{r4, r5, r6, lr}
c0d027ca:	b090      	sub	sp, #64	; 0x40
    unsigned char msg[32];
    unsigned char c[32];
    if (G_monero_vstate.io_p2 == 1) {
c0d027cc:	4e1e      	ldr	r6, [pc, #120]	; (c0d02848 <monero_apdu_mlsag_hash+0x80>)
c0d027ce:	7970      	ldrb	r0, [r6, #5]
c0d027d0:	2801      	cmp	r0, #1
c0d027d2:	d10c      	bne.n	c0d027ee <monero_apdu_mlsag_hash+0x26>
c0d027d4:	207b      	movs	r0, #123	; 0x7b
c0d027d6:	00c0      	lsls	r0, r0, #3
        monero_keccak_init_H();
c0d027d8:	1830      	adds	r0, r6, r0
c0d027da:	f7fd fd59 	bl	c0d00290 <monero_hash_init_keccak>
c0d027de:	200b      	movs	r0, #11
c0d027e0:	01c0      	lsls	r0, r0, #7
        os_memmove(msg, G_monero_vstate.H, 32);
c0d027e2:	1831      	adds	r1, r6, r0
c0d027e4:	a808      	add	r0, sp, #32
c0d027e6:	2220      	movs	r2, #32
c0d027e8:	f001 f8d1 	bl	c0d0398e <os_memmove>
c0d027ec:	e003      	b.n	c0d027f6 <monero_apdu_mlsag_hash+0x2e>
c0d027ee:	a808      	add	r0, sp, #32
c0d027f0:	2120      	movs	r1, #32
    } else {
        monero_io_fetch(msg, 32);
c0d027f2:	f7fe fecd 	bl	c0d01590 <monero_io_fetch>
c0d027f6:	2001      	movs	r0, #1
    }
    monero_io_discard(1);
c0d027f8:	f7fe fe3c 	bl	c0d01474 <monero_io_discard>
c0d027fc:	207b      	movs	r0, #123	; 0x7b
c0d027fe:	00c0      	lsls	r0, r0, #3

    monero_keccak_update_H(msg, 32);
c0d02800:	1835      	adds	r5, r6, r0
c0d02802:	a908      	add	r1, sp, #32
c0d02804:	2220      	movs	r2, #32
c0d02806:	4628      	mov	r0, r5
c0d02808:	f7fd fd48 	bl	c0d0029c <monero_hash_update>
c0d0280c:	204f      	movs	r0, #79	; 0x4f
c0d0280e:	0080      	lsls	r0, r0, #2
    if ((G_monero_vstate.options&0x80) == 0 ) {
c0d02810:	5c30      	ldrb	r0, [r6, r0]
c0d02812:	0600      	lsls	r0, r0, #24
c0d02814:	d414      	bmi.n	c0d02840 <monero_apdu_mlsag_hash+0x78>
c0d02816:	466c      	mov	r4, sp
        monero_keccak_final_H(c);
c0d02818:	4628      	mov	r0, r5
c0d0281a:	4621      	mov	r1, r4
c0d0281c:	f7fd fd4a 	bl	c0d002b4 <monero_hash_final>
        monero_reduce(c,c);
c0d02820:	4620      	mov	r0, r4
c0d02822:	4621      	mov	r1, r4
c0d02824:	f7fd fdb0 	bl	c0d00388 <monero_reduce>
c0d02828:	2520      	movs	r5, #32
        monero_io_insert(c,32);
c0d0282a:	4620      	mov	r0, r4
c0d0282c:	4629      	mov	r1, r5
c0d0282e:	f7fe fe4d 	bl	c0d014cc <monero_io_insert>
c0d02832:	202d      	movs	r0, #45	; 0x2d
c0d02834:	0140      	lsls	r0, r0, #5
        os_memmove(G_monero_vstate.c, c, 32);
c0d02836:	1830      	adds	r0, r6, r0
c0d02838:	4621      	mov	r1, r4
c0d0283a:	462a      	mov	r2, r5
c0d0283c:	f001 f8a7 	bl	c0d0398e <os_memmove>
c0d02840:	2009      	movs	r0, #9
c0d02842:	0300      	lsls	r0, r0, #12
    }  
    return SW_OK;
c0d02844:	b010      	add	sp, #64	; 0x40
c0d02846:	bd70      	pop	{r4, r5, r6, pc}
c0d02848:	20001930 	.word	0x20001930

c0d0284c <monero_apdu_mlsag_sign>:
}

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_sign() {
c0d0284c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0284e:	b0a1      	sub	sp, #132	; 0x84
c0d02850:	2005      	movs	r0, #5
c0d02852:	0186      	lsls	r6, r0, #6
    unsigned char xin[32];
    unsigned char alpha[32];
    unsigned char ss[32];
    unsigned char ss2[32];
    
    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_FAKE) {
c0d02854:	4f1c      	ldr	r7, [pc, #112]	; (c0d028c8 <monero_apdu_mlsag_sign+0x7c>)
c0d02856:	59b8      	ldr	r0, [r7, r6]
c0d02858:	2801      	cmp	r0, #1
c0d0285a:	d00b      	beq.n	c0d02874 <monero_apdu_mlsag_sign+0x28>
c0d0285c:	2802      	cmp	r0, #2
c0d0285e:	d12e      	bne.n	c0d028be <monero_apdu_mlsag_sign+0x72>
c0d02860:	a819      	add	r0, sp, #100	; 0x64
c0d02862:	2420      	movs	r4, #32
        monero_io_fetch(xin,32);
c0d02864:	4621      	mov	r1, r4
c0d02866:	f7fe fe93 	bl	c0d01590 <monero_io_fetch>
c0d0286a:	a811      	add	r0, sp, #68	; 0x44
        monero_io_fetch(alpha,32);
c0d0286c:	4621      	mov	r1, r4
c0d0286e:	f7fe fe8f 	bl	c0d01590 <monero_io_fetch>
c0d02872:	e008      	b.n	c0d02886 <monero_apdu_mlsag_sign+0x3a>
c0d02874:	a819      	add	r0, sp, #100	; 0x64
c0d02876:	2420      	movs	r4, #32
    } else if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
        monero_io_fetch_decrypt(xin,32); 
c0d02878:	4621      	mov	r1, r4
c0d0287a:	f7fe fea5 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d0287e:	a811      	add	r0, sp, #68	; 0x44
        monero_io_fetch_decrypt(alpha,32);
c0d02880:	4621      	mov	r1, r4
c0d02882:	f7fe fea1 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d02886:	2001      	movs	r0, #1
    } else {
        THROW(SW_WRONG_DATA);
    }
    monero_io_discard(1);
c0d02888:	f7fe fdf4 	bl	c0d01474 <monero_io_discard>
c0d0288c:	202d      	movs	r0, #45	; 0x2d
c0d0288e:	0140      	lsls	r0, r0, #5

    monero_multm(ss, G_monero_vstate.c, xin);
c0d02890:	1839      	adds	r1, r7, r0
c0d02892:	ac09      	add	r4, sp, #36	; 0x24
c0d02894:	aa19      	add	r2, sp, #100	; 0x64
c0d02896:	4620      	mov	r0, r4
c0d02898:	f7fe fab2 	bl	c0d00e00 <monero_multm>
c0d0289c:	ad01      	add	r5, sp, #4
c0d0289e:	a911      	add	r1, sp, #68	; 0x44
    monero_subm(ss2, alpha, ss);
c0d028a0:	4628      	mov	r0, r5
c0d028a2:	4622      	mov	r2, r4
c0d028a4:	f7fe fa7a 	bl	c0d00d9c <monero_subm>
c0d028a8:	2120      	movs	r1, #32

    monero_io_insert(ss2,32);
c0d028aa:	4628      	mov	r0, r5
c0d028ac:	f7fe fe0e 	bl	c0d014cc <monero_io_insert>
    monero_io_insert_u32(G_monero_vstate.sig_mode);
c0d028b0:	59b8      	ldr	r0, [r7, r6]
c0d028b2:	f7fe fe3b 	bl	c0d0152c <monero_io_insert_u32>
c0d028b6:	2009      	movs	r0, #9
c0d028b8:	0300      	lsls	r0, r0, #12
    return SW_OK;
c0d028ba:	b021      	add	sp, #132	; 0x84
c0d028bc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d028be:	20d5      	movs	r0, #213	; 0xd5
c0d028c0:	01c0      	lsls	r0, r0, #7
        monero_io_fetch(alpha,32);
    } else if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
        monero_io_fetch_decrypt(xin,32); 
        monero_io_fetch_decrypt(alpha,32);
    } else {
        THROW(SW_WRONG_DATA);
c0d028c2:	f001 f933 	bl	c0d03b2c <os_longjmp>
c0d028c6:	46c0      	nop			; (mov r8, r8)
c0d028c8:	20001930 	.word	0x20001930

c0d028cc <monero_base58_public_key>:
        res[i] = alphabet[remainder];
        --i;
    }
}

int monero_base58_public_key(char* str_b58, unsigned char *view, unsigned char *spend, unsigned char is_subbadress) {
c0d028cc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d028ce:	b099      	sub	sp, #100	; 0x64
c0d028d0:	461c      	mov	r4, r3
c0d028d2:	9204      	str	r2, [sp, #16]
c0d028d4:	9105      	str	r1, [sp, #20]
c0d028d6:	9006      	str	r0, [sp, #24]
    unsigned char data[72];
    unsigned int offset;
    unsigned int prefix;

    //data[0] = N_monero_pstate->network_id;
    switch(N_monero_pstate->network_id) {
c0d028d8:	4832      	ldr	r0, [pc, #200]	; (c0d029a4 <monero_base58_public_key+0xd8>)
c0d028da:	f001 ff45 	bl	c0d04768 <pic>
c0d028de:	7a00      	ldrb	r0, [r0, #8]
c0d028e0:	2800      	cmp	r0, #0
c0d028e2:	d007      	beq.n	c0d028f4 <monero_base58_public_key+0x28>
c0d028e4:	2802      	cmp	r0, #2
c0d028e6:	d005      	beq.n	c0d028f4 <monero_base58_public_key+0x28>
c0d028e8:	2801      	cmp	r0, #1
c0d028ea:	d10a      	bne.n	c0d02902 <monero_base58_public_key+0x36>
        case TESTNET:
            prefix = is_subbadress ? TESTNET_CRYPTONOTE_PUBLIC_SUBADDRESS_BASE58_PREFIX : TESTNET_CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX;
c0d028ec:	2c00      	cmp	r4, #0
c0d028ee:	d007      	beq.n	c0d02900 <monero_base58_public_key+0x34>
c0d028f0:	4930      	ldr	r1, [pc, #192]	; (c0d029b4 <monero_base58_public_key+0xe8>)
c0d028f2:	e006      	b.n	c0d02902 <monero_base58_public_key+0x36>
c0d028f4:	2c00      	cmp	r4, #0
c0d028f6:	d001      	beq.n	c0d028fc <monero_base58_public_key+0x30>
c0d028f8:	492c      	ldr	r1, [pc, #176]	; (c0d029ac <monero_base58_public_key+0xe0>)
c0d028fa:	e002      	b.n	c0d02902 <monero_base58_public_key+0x36>
c0d028fc:	492a      	ldr	r1, [pc, #168]	; (c0d029a8 <monero_base58_public_key+0xdc>)
c0d028fe:	e000      	b.n	c0d02902 <monero_base58_public_key+0x36>
c0d02900:	492b      	ldr	r1, [pc, #172]	; (c0d029b0 <monero_base58_public_key+0xe4>)
c0d02902:	ae07      	add	r6, sp, #28
            break;
        case MAINNET:
            prefix = is_subbadress ? MAINNET_CRYPTONOTE_PUBLIC_SUBADDRESS_BASE58_PREFIX : MAINNET_CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX;
            break;
    }
    offset = monero_encode_varint(data, prefix);
c0d02904:	4630      	mov	r0, r6
c0d02906:	f7fd fd05 	bl	c0d00314 <monero_encode_varint>
c0d0290a:	4605      	mov	r5, r0
    
    os_memmove(data+offset,spend,32);
c0d0290c:	1834      	adds	r4, r6, r0
c0d0290e:	2720      	movs	r7, #32
c0d02910:	4620      	mov	r0, r4
c0d02912:	9904      	ldr	r1, [sp, #16]
c0d02914:	463a      	mov	r2, r7
c0d02916:	f001 f83a 	bl	c0d0398e <os_memmove>
    os_memmove(data+offset+32,view,32);
c0d0291a:	4620      	mov	r0, r4
c0d0291c:	3020      	adds	r0, #32
c0d0291e:	9905      	ldr	r1, [sp, #20]
c0d02920:	463a      	mov	r2, r7
c0d02922:	f001 f834 	bl	c0d0398e <os_memmove>
c0d02926:	200b      	movs	r0, #11
c0d02928:	9003      	str	r0, [sp, #12]
c0d0292a:	01c0      	lsls	r0, r0, #7
    monero_keccak_F(data, offset+64, G_monero_vstate.H);
c0d0292c:	4922      	ldr	r1, [pc, #136]	; (c0d029b8 <monero_base58_public_key+0xec>)
c0d0292e:	180f      	adds	r7, r1, r0
c0d02930:	4668      	mov	r0, sp
c0d02932:	6007      	str	r7, [r0, #0]
c0d02934:	2023      	movs	r0, #35	; 0x23
c0d02936:	0100      	lsls	r0, r0, #4
c0d02938:	1809      	adds	r1, r1, r0
c0d0293a:	462b      	mov	r3, r5
c0d0293c:	3340      	adds	r3, #64	; 0x40
c0d0293e:	2006      	movs	r0, #6
c0d02940:	4632      	mov	r2, r6
c0d02942:	f7fd fcc3 	bl	c0d002cc <monero_hash>
    os_memmove(data+offset+32+32, G_monero_vstate.H, 4);
c0d02946:	3440      	adds	r4, #64	; 0x40
c0d02948:	2204      	movs	r2, #4
c0d0294a:	4620      	mov	r0, r4
c0d0294c:	4639      	mov	r1, r7
c0d0294e:	f001 f81e 	bl	c0d0398e <os_memmove>

    unsigned int full_block_count = (offset+32+32+4) / FULL_BLOCK_SIZE;
c0d02952:	3544      	adds	r5, #68	; 0x44
c0d02954:	2107      	movs	r1, #7
    unsigned int last_block_size  = (offset+32+32+4) % FULL_BLOCK_SIZE;
c0d02956:	4628      	mov	r0, r5
c0d02958:	9102      	str	r1, [sp, #8]
c0d0295a:	4008      	ands	r0, r1
c0d0295c:	9004      	str	r0, [sp, #16]
    os_memmove(data+offset,spend,32);
    os_memmove(data+offset+32,view,32);
    monero_keccak_F(data, offset+64, G_monero_vstate.H);
    os_memmove(data+offset+32+32, G_monero_vstate.H, 4);

    unsigned int full_block_count = (offset+32+32+4) / FULL_BLOCK_SIZE;
c0d0295e:	08e8      	lsrs	r0, r5, #3
    unsigned int last_block_size  = (offset+32+32+4) % FULL_BLOCK_SIZE;
    for (size_t i = 0; i < full_block_count; ++i) {
c0d02960:	9005      	str	r0, [sp, #20]
c0d02962:	d00c      	beq.n	c0d0297e <monero_base58_public_key+0xb2>
c0d02964:	ac07      	add	r4, sp, #28
c0d02966:	9e05      	ldr	r6, [sp, #20]
c0d02968:	9f06      	ldr	r7, [sp, #24]
c0d0296a:	2108      	movs	r1, #8
        encode_block(data + i * FULL_BLOCK_SIZE, FULL_BLOCK_SIZE, &str_b58[i * FULL_ENCODED_BLOCK_SIZE]);
c0d0296c:	4620      	mov	r0, r4
c0d0296e:	463a      	mov	r2, r7
c0d02970:	f000 f824 	bl	c0d029bc <encode_block>
    monero_keccak_F(data, offset+64, G_monero_vstate.H);
    os_memmove(data+offset+32+32, G_monero_vstate.H, 4);

    unsigned int full_block_count = (offset+32+32+4) / FULL_BLOCK_SIZE;
    unsigned int last_block_size  = (offset+32+32+4) % FULL_BLOCK_SIZE;
    for (size_t i = 0; i < full_block_count; ++i) {
c0d02974:	3408      	adds	r4, #8
c0d02976:	1e76      	subs	r6, r6, #1
c0d02978:	370b      	adds	r7, #11
c0d0297a:	2e00      	cmp	r6, #0
c0d0297c:	d1f5      	bne.n	c0d0296a <monero_base58_public_key+0x9e>
c0d0297e:	9b04      	ldr	r3, [sp, #16]
        encode_block(data + i * FULL_BLOCK_SIZE, FULL_BLOCK_SIZE, &str_b58[i * FULL_ENCODED_BLOCK_SIZE]);
    }

    if (0 < last_block_size) {
c0d02980:	2b00      	cmp	r3, #0
c0d02982:	d00b      	beq.n	c0d0299c <monero_base58_public_key+0xd0>
        encode_block(data + full_block_count * FULL_BLOCK_SIZE, last_block_size, &str_b58[full_block_count * FULL_ENCODED_BLOCK_SIZE]);
c0d02984:	9802      	ldr	r0, [sp, #8]
c0d02986:	4385      	bics	r5, r0
c0d02988:	a807      	add	r0, sp, #28
c0d0298a:	1940      	adds	r0, r0, r5
c0d0298c:	9a03      	ldr	r2, [sp, #12]
c0d0298e:	9905      	ldr	r1, [sp, #20]
c0d02990:	434a      	muls	r2, r1
c0d02992:	9906      	ldr	r1, [sp, #24]
c0d02994:	188a      	adds	r2, r1, r2
c0d02996:	4619      	mov	r1, r3
c0d02998:	f000 f810 	bl	c0d029bc <encode_block>
c0d0299c:	2000      	movs	r0, #0
    }

    return 0;
c0d0299e:	b019      	add	sp, #100	; 0x64
c0d029a0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d029a2:	46c0      	nop			; (mov r8, r8)
c0d029a4:	c0d07c00 	.word	0xc0d07c00
c0d029a8:	00002867 	.word	0x00002867
c0d029ac:	00002c68 	.word	0x00002c68
c0d029b0:	00005b1d 	.word	0x00005b1d
c0d029b4:	0000641c 	.word	0x0000641c
c0d029b8:	20001930 	.word	0x20001930

c0d029bc <encode_block>:
    }

    return res;
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
c0d029bc:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d029be:	b085      	sub	sp, #20
c0d029c0:	2309      	movs	r3, #9
#define  ADDR_CHECKSUM_SIZE                4


static uint64_t uint_8be_to_64(const unsigned char* data, size_t size) {
    uint64_t res = 0;
    switch (9 - size) {
c0d029c2:	1a5c      	subs	r4, r3, r1
c0d029c4:	2600      	movs	r6, #0
c0d029c6:	4633      	mov	r3, r6
c0d029c8:	2c04      	cmp	r4, #4
c0d029ca:	dc06      	bgt.n	c0d029da <encode_block+0x1e>
c0d029cc:	2c02      	cmp	r4, #2
c0d029ce:	dc0b      	bgt.n	c0d029e8 <encode_block+0x2c>
c0d029d0:	2c01      	cmp	r4, #1
c0d029d2:	d013      	beq.n	c0d029fc <encode_block+0x40>
c0d029d4:	2c02      	cmp	r4, #2
c0d029d6:	d016      	beq.n	c0d02a06 <encode_block+0x4a>
c0d029d8:	e069      	b.n	c0d02aae <encode_block+0xf2>
c0d029da:	2c06      	cmp	r4, #6
c0d029dc:	dc09      	bgt.n	c0d029f2 <encode_block+0x36>
c0d029de:	2c05      	cmp	r4, #5
c0d029e0:	d026      	beq.n	c0d02a30 <encode_block+0x74>
c0d029e2:	2c06      	cmp	r4, #6
c0d029e4:	d02b      	beq.n	c0d02a3e <encode_block+0x82>
c0d029e6:	e062      	b.n	c0d02aae <encode_block+0xf2>
c0d029e8:	2c03      	cmp	r4, #3
c0d029ea:	d013      	beq.n	c0d02a14 <encode_block+0x58>
c0d029ec:	2c04      	cmp	r4, #4
c0d029ee:	d018      	beq.n	c0d02a22 <encode_block+0x66>
c0d029f0:	e05d      	b.n	c0d02aae <encode_block+0xf2>
c0d029f2:	2c07      	cmp	r4, #7
c0d029f4:	d02a      	beq.n	c0d02a4c <encode_block+0x90>
c0d029f6:	2c08      	cmp	r4, #8
c0d029f8:	d02f      	beq.n	c0d02a5a <encode_block+0x9e>
c0d029fa:	e058      	b.n	c0d02aae <encode_block+0xf2>
    case 1:            res |= *data++;
c0d029fc:	1c44      	adds	r4, r0, #1
c0d029fe:	7800      	ldrb	r0, [r0, #0]
c0d02a00:	0203      	lsls	r3, r0, #8
c0d02a02:	2600      	movs	r6, #0
c0d02a04:	4620      	mov	r0, r4
    case 2: res <<= 8; res |= *data++;
c0d02a06:	7804      	ldrb	r4, [r0, #0]
c0d02a08:	431c      	orrs	r4, r3
c0d02a0a:	0e23      	lsrs	r3, r4, #24
c0d02a0c:	0235      	lsls	r5, r6, #8
c0d02a0e:	18ee      	adds	r6, r5, r3
c0d02a10:	0223      	lsls	r3, r4, #8
c0d02a12:	1c40      	adds	r0, r0, #1
    case 3: res <<= 8; res |= *data++;
c0d02a14:	7804      	ldrb	r4, [r0, #0]
c0d02a16:	431c      	orrs	r4, r3
c0d02a18:	0e23      	lsrs	r3, r4, #24
c0d02a1a:	0235      	lsls	r5, r6, #8
c0d02a1c:	18ee      	adds	r6, r5, r3
c0d02a1e:	0223      	lsls	r3, r4, #8
c0d02a20:	1c40      	adds	r0, r0, #1
    case 4: res <<= 8; res |= *data++;
c0d02a22:	7804      	ldrb	r4, [r0, #0]
c0d02a24:	431c      	orrs	r4, r3
c0d02a26:	0e23      	lsrs	r3, r4, #24
c0d02a28:	0235      	lsls	r5, r6, #8
c0d02a2a:	18ee      	adds	r6, r5, r3
c0d02a2c:	0223      	lsls	r3, r4, #8
c0d02a2e:	1c40      	adds	r0, r0, #1
    case 5: res <<= 8; res |= *data++;
c0d02a30:	7804      	ldrb	r4, [r0, #0]
c0d02a32:	431c      	orrs	r4, r3
c0d02a34:	0e23      	lsrs	r3, r4, #24
c0d02a36:	0235      	lsls	r5, r6, #8
c0d02a38:	18ee      	adds	r6, r5, r3
c0d02a3a:	0223      	lsls	r3, r4, #8
c0d02a3c:	1c40      	adds	r0, r0, #1
    case 6: res <<= 8; res |= *data++;
c0d02a3e:	7804      	ldrb	r4, [r0, #0]
c0d02a40:	431c      	orrs	r4, r3
c0d02a42:	0e23      	lsrs	r3, r4, #24
c0d02a44:	0235      	lsls	r5, r6, #8
c0d02a46:	18ee      	adds	r6, r5, r3
c0d02a48:	0223      	lsls	r3, r4, #8
c0d02a4a:	1c40      	adds	r0, r0, #1
    case 7: res <<= 8; res |= *data++;
c0d02a4c:	7804      	ldrb	r4, [r0, #0]
c0d02a4e:	431c      	orrs	r4, r3
c0d02a50:	0e23      	lsrs	r3, r4, #24
c0d02a52:	0235      	lsls	r5, r6, #8
c0d02a54:	18ee      	adds	r6, r5, r3
c0d02a56:	0223      	lsls	r3, r4, #8
c0d02a58:	1c40      	adds	r0, r0, #1
    case 8: res <<= 8; res |= *data; 
c0d02a5a:	7805      	ldrb	r5, [r0, #0]
c0d02a5c:	431d      	orrs	r5, r3
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
    uint64_t num = uint_8be_to_64(block, size);
    int i = encoded_block_sizes[size] - 1;
    while (0 < num) {
c0d02a5e:	4628      	mov	r0, r5
c0d02a60:	4330      	orrs	r0, r6
c0d02a62:	2800      	cmp	r0, #0
c0d02a64:	d023      	beq.n	c0d02aae <encode_block+0xf2>
    return res;
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
    uint64_t num = uint_8be_to_64(block, size);
    int i = encoded_block_sizes[size] - 1;
c0d02a66:	0088      	lsls	r0, r1, #2
c0d02a68:	4912      	ldr	r1, [pc, #72]	; (c0d02ab4 <encode_block+0xf8>)
c0d02a6a:	4479      	add	r1, pc
c0d02a6c:	5808      	ldr	r0, [r1, r0]
c0d02a6e:	1810      	adds	r0, r2, r0
c0d02a70:	1e47      	subs	r7, r0, #1
c0d02a72:	4811      	ldr	r0, [pc, #68]	; (c0d02ab8 <encode_block+0xfc>)
c0d02a74:	4478      	add	r0, pc
c0d02a76:	9001      	str	r0, [sp, #4]
c0d02a78:	243a      	movs	r4, #58	; 0x3a
c0d02a7a:	4631      	mov	r1, r6
c0d02a7c:	9604      	str	r6, [sp, #16]
c0d02a7e:	2600      	movs	r6, #0
    while (0 < num) {
        uint64_t remainder = num % alphabet_size;
        num /= alphabet_size;
c0d02a80:	4628      	mov	r0, r5
c0d02a82:	4622      	mov	r2, r4
c0d02a84:	4633      	mov	r3, r6
c0d02a86:	f003 fc8f 	bl	c0d063a8 <__aeabi_uldivmod>
c0d02a8a:	9003      	str	r0, [sp, #12]
c0d02a8c:	9102      	str	r1, [sp, #8]
c0d02a8e:	4622      	mov	r2, r4
c0d02a90:	4633      	mov	r3, r6
c0d02a92:	f003 fca9 	bl	c0d063e8 <__aeabi_lmul>
c0d02a96:	1a28      	subs	r0, r5, r0
        res[i] = alphabet[remainder];
c0d02a98:	9901      	ldr	r1, [sp, #4]
c0d02a9a:	5c08      	ldrb	r0, [r1, r0]
c0d02a9c:	7038      	strb	r0, [r7, #0]
}

static void encode_block(const unsigned char* block, unsigned int  size,  char* res) {
    uint64_t num = uint_8be_to_64(block, size);
    int i = encoded_block_sizes[size] - 1;
    while (0 < num) {
c0d02a9e:	1e7f      	subs	r7, r7, #1
c0d02aa0:	2039      	movs	r0, #57	; 0x39
c0d02aa2:	1b40      	subs	r0, r0, r5
c0d02aa4:	9804      	ldr	r0, [sp, #16]
c0d02aa6:	4186      	sbcs	r6, r0
c0d02aa8:	9d03      	ldr	r5, [sp, #12]
c0d02aaa:	9e02      	ldr	r6, [sp, #8]
c0d02aac:	d3e4      	bcc.n	c0d02a78 <encode_block+0xbc>
        uint64_t remainder = num % alphabet_size;
        num /= alphabet_size;
        res[i] = alphabet[remainder];
        --i;
    }
}
c0d02aae:	b005      	add	sp, #20
c0d02ab0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02ab2:	46c0      	nop			; (mov r8, r8)
c0d02ab4:	000043e2 	.word	0x000043e2
c0d02ab8:	0000439c 	.word	0x0000439c

c0d02abc <monero_reset_tx>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
void monero_reset_tx() {
c0d02abc:	b570      	push	{r4, r5, r6, lr}
c0d02abe:	2021      	movs	r0, #33	; 0x21
c0d02ac0:	0100      	lsls	r0, r0, #4
    os_memset(G_monero_vstate.r, 0, 32);
c0d02ac2:	4e13      	ldr	r6, [pc, #76]	; (c0d02b10 <monero_reset_tx+0x54>)
c0d02ac4:	1830      	adds	r0, r6, r0
c0d02ac6:	2400      	movs	r4, #0
c0d02ac8:	2520      	movs	r5, #32
c0d02aca:	4621      	mov	r1, r4
c0d02acc:	462a      	mov	r2, r5
c0d02ace:	f000 ff55 	bl	c0d0397c <os_memset>
c0d02ad2:	201f      	movs	r0, #31
c0d02ad4:	0100      	lsls	r0, r0, #4
    os_memset(G_monero_vstate.R, 0, 32);
c0d02ad6:	1830      	adds	r0, r6, r0
c0d02ad8:	4621      	mov	r1, r4
c0d02ada:	462a      	mov	r2, r5
c0d02adc:	f000 ff4e 	bl	c0d0397c <os_memset>
c0d02ae0:	257b      	movs	r5, #123	; 0x7b
c0d02ae2:	00e8      	lsls	r0, r5, #3
    monero_keccak_init_H();
c0d02ae4:	1830      	adds	r0, r6, r0
c0d02ae6:	f7fd fbd3 	bl	c0d00290 <monero_hash_init_keccak>
c0d02aea:	480a      	ldr	r0, [pc, #40]	; (c0d02b14 <monero_reset_tx+0x58>)
    monero_sha256_commitment_init();
c0d02aec:	1830      	adds	r0, r6, r0
c0d02aee:	f7fd fc22 	bl	c0d00336 <monero_hash_init_sha256>
c0d02af2:	2017      	movs	r0, #23
c0d02af4:	0180      	lsls	r0, r0, #6
    monero_sha256_outkeys_init();
c0d02af6:	1830      	adds	r0, r6, r0
c0d02af8:	f7fd fc1d 	bl	c0d00336 <monero_hash_init_sha256>
c0d02afc:	00a8      	lsls	r0, r5, #2
    G_monero_vstate.tx_in_progress = 0;
    G_monero_vstate.tx_output_cnt = 0;
c0d02afe:	5034      	str	r4, [r6, r0]
c0d02b00:	203d      	movs	r0, #61	; 0x3d
c0d02b02:	00c0      	lsls	r0, r0, #3
    os_memset(G_monero_vstate.r, 0, 32);
    os_memset(G_monero_vstate.R, 0, 32);
    monero_keccak_init_H();
    monero_sha256_commitment_init();
    monero_sha256_outkeys_init();
    G_monero_vstate.tx_in_progress = 0;
c0d02b04:	5c31      	ldrb	r1, [r6, r0]
c0d02b06:	22fd      	movs	r2, #253	; 0xfd
c0d02b08:	400a      	ands	r2, r1
c0d02b0a:	5432      	strb	r2, [r6, r0]
    G_monero_vstate.tx_output_cnt = 0;

 }
c0d02b0c:	bd70      	pop	{r4, r5, r6, pc}
c0d02b0e:	46c0      	nop			; (mov r8, r8)
c0d02b10:	20001930 	.word	0x20001930
c0d02b14:	0000064c 	.word	0x0000064c

c0d02b18 <monero_apdu_open_tx>:
/* ----------------------------------------------------------------------- */
/*
 * HD wallet not yet supported : account is assumed to be zero
 */
#define OPTION_KEEP_r 1
int monero_apdu_open_tx() {
c0d02b18:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02b1a:	b081      	sub	sp, #4

    unsigned int account;

    account = monero_io_fetch_u32();
c0d02b1c:	f7fe fda8 	bl	c0d01670 <monero_io_fetch_u32>
c0d02b20:	2001      	movs	r0, #1

    monero_io_discard(1);
c0d02b22:	f7fe fca7 	bl	c0d01474 <monero_io_discard>

    monero_reset_tx();
c0d02b26:	f7ff ffc9 	bl	c0d02abc <monero_reset_tx>
c0d02b2a:	2021      	movs	r0, #33	; 0x21
c0d02b2c:	0100      	lsls	r0, r0, #4
    monero_rng(G_monero_vstate.r,32);
c0d02b2e:	4f12      	ldr	r7, [pc, #72]	; (c0d02b78 <monero_apdu_open_tx+0x60>)
c0d02b30:	183c      	adds	r4, r7, r0
c0d02b32:	2520      	movs	r5, #32
c0d02b34:	4620      	mov	r0, r4
c0d02b36:	4629      	mov	r1, r5
c0d02b38:	f7fd fbe8 	bl	c0d0030c <monero_rng>
    monero_reduce(G_monero_vstate.r, G_monero_vstate.r);
c0d02b3c:	4620      	mov	r0, r4
c0d02b3e:	4621      	mov	r1, r4
c0d02b40:	f7fd fc22 	bl	c0d00388 <monero_reduce>
c0d02b44:	201f      	movs	r0, #31
c0d02b46:	0100      	lsls	r0, r0, #4
    monero_ecmul_G(G_monero_vstate.R, G_monero_vstate.r);
c0d02b48:	183e      	adds	r6, r7, r0
c0d02b4a:	4630      	mov	r0, r6
c0d02b4c:	4621      	mov	r1, r4
c0d02b4e:	f7fd fe75 	bl	c0d0083c <monero_ecmul_G>

    monero_io_insert(G_monero_vstate.R,32);
c0d02b52:	4630      	mov	r0, r6
c0d02b54:	4629      	mov	r1, r5
c0d02b56:	f7fe fcb9 	bl	c0d014cc <monero_io_insert>
    monero_io_insert_encrypt(G_monero_vstate.r,32);
c0d02b5a:	4620      	mov	r0, r4
c0d02b5c:	4629      	mov	r1, r5
c0d02b5e:	f7fe fcc9 	bl	c0d014f4 <monero_io_insert_encrypt>
c0d02b62:	203d      	movs	r0, #61	; 0x3d
c0d02b64:	00c0      	lsls	r0, r0, #3
#ifdef DEBUG_HWDEVICE
    monero_io_insert(G_monero_vstate.r,32);
#endif
    G_monero_vstate.tx_in_progress = 1;
c0d02b66:	5c39      	ldrb	r1, [r7, r0]
c0d02b68:	2202      	movs	r2, #2
c0d02b6a:	430a      	orrs	r2, r1
c0d02b6c:	543a      	strb	r2, [r7, r0]
c0d02b6e:	2009      	movs	r0, #9
c0d02b70:	0300      	lsls	r0, r0, #12
    return SW_OK;
c0d02b72:	b001      	add	sp, #4
c0d02b74:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02b76:	46c0      	nop			; (mov r8, r8)
c0d02b78:	20001930 	.word	0x20001930

c0d02b7c <monero_apdu_close_tx>:
#undef OPTION_KEEP_r

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_close_tx() {
c0d02b7c:	b580      	push	{r7, lr}
c0d02b7e:	2001      	movs	r0, #1
   monero_io_discard(1);
c0d02b80:	f7fe fc78 	bl	c0d01474 <monero_io_discard>
   monero_reset_tx();
c0d02b84:	f7ff ff9a 	bl	c0d02abc <monero_reset_tx>
c0d02b88:	203d      	movs	r0, #61	; 0x3d
c0d02b8a:	00c0      	lsls	r0, r0, #3
   G_monero_vstate.tx_in_progress = 0;
c0d02b8c:	4903      	ldr	r1, [pc, #12]	; (c0d02b9c <monero_apdu_close_tx+0x20>)
c0d02b8e:	5c0a      	ldrb	r2, [r1, r0]
c0d02b90:	23fd      	movs	r3, #253	; 0xfd
c0d02b92:	4013      	ands	r3, r2
c0d02b94:	540b      	strb	r3, [r1, r0]
c0d02b96:	2009      	movs	r0, #9
c0d02b98:	0300      	lsls	r0, r0, #12
   return SW_OK;
c0d02b9a:	bd80      	pop	{r7, pc}
c0d02b9c:	20001930 	.word	0x20001930

c0d02ba0 <monero_abort_tx>:
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/*
 * Sub dest address not yet supported: P1 = 2 not supported
 */
int monero_abort_tx() {
c0d02ba0:	b580      	push	{r7, lr}
    monero_reset_tx();
c0d02ba2:	f7ff ff8b 	bl	c0d02abc <monero_reset_tx>
c0d02ba6:	2000      	movs	r0, #0
    return 0;
c0d02ba8:	bd80      	pop	{r7, pc}
	...

c0d02bac <monero_apdu_set_signature_mode>:
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
/*
 * Sub dest address not yet supported: P1 = 2 not supported
 */
int monero_apdu_set_signature_mode() {
c0d02bac:	b570      	push	{r4, r5, r6, lr}
c0d02bae:	2005      	movs	r0, #5
c0d02bb0:	0185      	lsls	r5, r0, #6
    unsigned int sig_mode;

    G_monero_vstate.sig_mode = TRANSACTION_CREATE_FAKE;
c0d02bb2:	4e0b      	ldr	r6, [pc, #44]	; (c0d02be0 <monero_apdu_set_signature_mode+0x34>)
c0d02bb4:	2002      	movs	r0, #2
c0d02bb6:	5170      	str	r0, [r6, r5]

    sig_mode = monero_io_fetch_u8();
c0d02bb8:	f7fe fd76 	bl	c0d016a8 <monero_io_fetch_u8>
c0d02bbc:	4604      	mov	r4, r0
c0d02bbe:	2000      	movs	r0, #0
    monero_io_discard(0);
c0d02bc0:	f7fe fc58 	bl	c0d01474 <monero_io_discard>
    switch(sig_mode) {
c0d02bc4:	1e60      	subs	r0, r4, #1
c0d02bc6:	2802      	cmp	r0, #2
c0d02bc8:	d206      	bcs.n	c0d02bd8 <monero_apdu_set_signature_mode+0x2c>
    case TRANSACTION_CREATE_FAKE:
        break;
    default:
        THROW(SW_WRONG_DATA);
    }
    G_monero_vstate.sig_mode = sig_mode;
c0d02bca:	5174      	str	r4, [r6, r5]

    monero_io_insert_u32( G_monero_vstate.sig_mode );
c0d02bcc:	4620      	mov	r0, r4
c0d02bce:	f7fe fcad 	bl	c0d0152c <monero_io_insert_u32>
c0d02bd2:	2009      	movs	r0, #9
c0d02bd4:	0300      	lsls	r0, r0, #12
    return SW_OK;
c0d02bd6:	bd70      	pop	{r4, r5, r6, pc}
c0d02bd8:	20d5      	movs	r0, #213	; 0xd5
c0d02bda:	01c0      	lsls	r0, r0, #7
    switch(sig_mode) {
    case TRANSACTION_CREATE_REAL:
    case TRANSACTION_CREATE_FAKE:
        break;
    default:
        THROW(SW_WRONG_DATA);
c0d02bdc:	f000 ffa6 	bl	c0d03b2c <os_longjmp>
c0d02be0:	20001930 	.word	0x20001930

c0d02be4 <monero_apdu_mlsag_prehash_init>:
#include "monero_vars.h"

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prehash_init() {
c0d02be4:	b570      	push	{r4, r5, r6, lr}
c0d02be6:	2005      	movs	r0, #5
c0d02be8:	0186      	lsls	r6, r0, #6
    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02bea:	4d22      	ldr	r5, [pc, #136]	; (c0d02c74 <monero_apdu_mlsag_prehash_init+0x90>)
c0d02bec:	59a8      	ldr	r0, [r5, r6]
c0d02bee:	2801      	cmp	r0, #1
c0d02bf0:	d116      	bne.n	c0d02c20 <monero_apdu_mlsag_prehash_init+0x3c>
c0d02bf2:	7968      	ldrb	r0, [r5, #5]
c0d02bf4:	2801      	cmp	r0, #1
c0d02bf6:	d113      	bne.n	c0d02c20 <monero_apdu_mlsag_prehash_init+0x3c>
c0d02bf8:	481f      	ldr	r0, [pc, #124]	; (c0d02c78 <monero_apdu_mlsag_prehash_init+0x94>)
        if (G_monero_vstate.io_p2 == 1) {
            monero_sha256_outkeys_final(NULL);
c0d02bfa:	1829      	adds	r1, r5, r0
c0d02bfc:	2017      	movs	r0, #23
c0d02bfe:	0180      	lsls	r0, r0, #6
c0d02c00:	182c      	adds	r4, r5, r0
c0d02c02:	4620      	mov	r0, r4
c0d02c04:	f7fd fb56 	bl	c0d002b4 <monero_hash_final>
            monero_sha256_outkeys_init();
c0d02c08:	4620      	mov	r0, r4
c0d02c0a:	f7fd fb94 	bl	c0d00336 <monero_hash_init_sha256>
c0d02c0e:	481b      	ldr	r0, [pc, #108]	; (c0d02c7c <monero_apdu_mlsag_prehash_init+0x98>)
            monero_sha256_commitment_init();
c0d02c10:	1828      	adds	r0, r5, r0
c0d02c12:	f7fd fb90 	bl	c0d00336 <monero_hash_init_sha256>
c0d02c16:	207b      	movs	r0, #123	; 0x7b
c0d02c18:	00c0      	lsls	r0, r0, #3
            monero_keccak_init_H();
c0d02c1a:	1828      	adds	r0, r5, r0
c0d02c1c:	f7fd fb38 	bl	c0d00290 <monero_hash_init_keccak>
c0d02c20:	207b      	movs	r0, #123	; 0x7b
c0d02c22:	00c0      	lsls	r0, r0, #3
        }
    }
    monero_keccak_update_H(G_monero_vstate.io_buffer+G_monero_vstate.io_offset,
c0d02c24:	1828      	adds	r0, r5, r0
c0d02c26:	8969      	ldrh	r1, [r5, #10]
c0d02c28:	892a      	ldrh	r2, [r5, #8]
c0d02c2a:	1a52      	subs	r2, r2, r1
c0d02c2c:	1869      	adds	r1, r5, r1
c0d02c2e:	310e      	adds	r1, #14
c0d02c30:	f7fd fb34 	bl	c0d0029c <monero_hash_update>
                          G_monero_vstate.io_length-G_monero_vstate.io_offset);
    if ((G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) &&(G_monero_vstate.io_p2==1)) {
c0d02c34:	59a8      	ldr	r0, [r5, r6]
c0d02c36:	2801      	cmp	r0, #1
c0d02c38:	d115      	bne.n	c0d02c66 <monero_apdu_mlsag_prehash_init+0x82>
c0d02c3a:	7968      	ldrb	r0, [r5, #5]
c0d02c3c:	2801      	cmp	r0, #1
c0d02c3e:	d112      	bne.n	c0d02c66 <monero_apdu_mlsag_prehash_init+0x82>
        // skip type
        monero_io_fetch_u8();
c0d02c40:	f7fe fd32 	bl	c0d016a8 <monero_io_fetch_u8>
c0d02c44:	20f5      	movs	r0, #245	; 0xf5
c0d02c46:	00c0      	lsls	r0, r0, #3
        // fee str
        monero_vamount2str(G_monero_vstate.io_buffer+G_monero_vstate.io_offset, G_monero_vstate.ux_amount, 15);
c0d02c48:	1829      	adds	r1, r5, r0
c0d02c4a:	8968      	ldrh	r0, [r5, #10]
c0d02c4c:	1828      	adds	r0, r5, r0
c0d02c4e:	300e      	adds	r0, #14
c0d02c50:	220f      	movs	r2, #15
c0d02c52:	f7fe f9b9 	bl	c0d00fc8 <monero_vamount2str>
c0d02c56:	2001      	movs	r0, #1
         //ask user
        monero_io_discard(1);
c0d02c58:	f7fe fc0c 	bl	c0d01474 <monero_io_discard>
c0d02c5c:	2400      	movs	r4, #0
        ui_menu_fee_validation_display(0);
c0d02c5e:	4620      	mov	r0, r4
c0d02c60:	f000 fa0e 	bl	c0d03080 <ui_menu_fee_validation_display>
c0d02c64:	e004      	b.n	c0d02c70 <monero_apdu_mlsag_prehash_init+0x8c>
c0d02c66:	2001      	movs	r0, #1
        return 0;
    } else {
        monero_io_discard(1);
c0d02c68:	f7fe fc04 	bl	c0d01474 <monero_io_discard>
c0d02c6c:	2009      	movs	r0, #9
c0d02c6e:	0304      	lsls	r4, r0, #12
        return SW_OK;
    }
}
c0d02c70:	4620      	mov	r0, r4
c0d02c72:	bd70      	pop	{r4, r5, r6, pc}
c0d02c74:	20001930 	.word	0x20001930
c0d02c78:	0000062c 	.word	0x0000062c
c0d02c7c:	0000064c 	.word	0x0000064c

c0d02c80 <monero_apdu_mlsag_prehash_update>:

/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prehash_update() {
c0d02c80:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02c82:	b0af      	sub	sp, #188	; 0xbc

    #define aH AKout
    unsigned char kG[32];

    //fetch destination
    is_subaddress = monero_io_fetch_u8();
c0d02c84:	f7fe fd10 	bl	c0d016a8 <monero_io_fetch_u8>
c0d02c88:	9002      	str	r0, [sp, #8]
    if (G_monero_vstate.io_protocol_version == 2) {
c0d02c8a:	4c84      	ldr	r4, [pc, #528]	; (c0d02e9c <monero_apdu_mlsag_prehash_update+0x21c>)
c0d02c8c:	78a1      	ldrb	r1, [r4, #2]
c0d02c8e:	2000      	movs	r0, #0
c0d02c90:	2902      	cmp	r1, #2
c0d02c92:	d101      	bne.n	c0d02c98 <monero_apdu_mlsag_prehash_update+0x18>
        is_change =  monero_io_fetch_u8();
c0d02c94:	f7fe fd08 	bl	c0d016a8 <monero_io_fetch_u8>
c0d02c98:	a92e      	add	r1, sp, #184	; 0xb8
c0d02c9a:	7008      	strb	r0, [r1, #0]
    } else {
        is_change = 0;
    }
    Aout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02c9c:	8966      	ldrh	r6, [r4, #10]
c0d02c9e:	2400      	movs	r4, #0
c0d02ca0:	2520      	movs	r5, #32
c0d02ca2:	4620      	mov	r0, r4
c0d02ca4:	4629      	mov	r1, r5
c0d02ca6:	f7fe fc73 	bl	c0d01590 <monero_io_fetch>
    Bout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02caa:	487c      	ldr	r0, [pc, #496]	; (c0d02e9c <monero_apdu_mlsag_prehash_update+0x21c>)
c0d02cac:	8947      	ldrh	r7, [r0, #10]
c0d02cae:	4620      	mov	r0, r4
c0d02cb0:	4629      	mov	r1, r5
c0d02cb2:	f7fe fc6d 	bl	c0d01590 <monero_io_fetch>
c0d02cb6:	a826      	add	r0, sp, #152	; 0x98
    monero_io_fetch_decrypt(AKout,32);
c0d02cb8:	4629      	mov	r1, r5
c0d02cba:	f7fe fc85 	bl	c0d015c8 <monero_io_fetch_decrypt>
c0d02cbe:	a81e      	add	r0, sp, #120	; 0x78
    monero_io_fetch(C, 32);
c0d02cc0:	4629      	mov	r1, r5
c0d02cc2:	f7fe fc65 	bl	c0d01590 <monero_io_fetch>
c0d02cc6:	a80e      	add	r0, sp, #56	; 0x38
    monero_io_fetch(k, 32);
c0d02cc8:	4629      	mov	r1, r5
c0d02cca:	f7fe fc61 	bl	c0d01590 <monero_io_fetch>
c0d02cce:	a816      	add	r0, sp, #88	; 0x58
    monero_io_fetch(v, 32);
c0d02cd0:	4629      	mov	r1, r5
c0d02cd2:	f7fe fc5d 	bl	c0d01590 <monero_io_fetch>
c0d02cd6:	9403      	str	r4, [sp, #12]

    monero_io_discard(0);
c0d02cd8:	4620      	mov	r0, r4
c0d02cda:	4c70      	ldr	r4, [pc, #448]	; (c0d02e9c <monero_apdu_mlsag_prehash_update+0x21c>)
c0d02cdc:	f7fe fbca 	bl	c0d01474 <monero_io_discard>
    if (G_monero_vstate.io_protocol_version == 2) {
        is_change =  monero_io_fetch_u8();
    } else {
        is_change = 0;
    }
    Aout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02ce0:	4620      	mov	r0, r4
c0d02ce2:	300e      	adds	r0, #14
c0d02ce4:	1981      	adds	r1, r0, r6
    Bout = G_monero_vstate.io_buffer+G_monero_vstate.io_offset; monero_io_fetch(NULL,32);
c0d02ce6:	9104      	str	r1, [sp, #16]
c0d02ce8:	19c5      	adds	r5, r0, r7
c0d02cea:	204f      	movs	r0, #79	; 0x4f
c0d02cec:	0080      	lsls	r0, r0, #2
c0d02cee:	9005      	str	r0, [sp, #20]
    monero_io_fetch(v, 32);

    monero_io_discard(0);

    //update MLSAG prehash
    if ((G_monero_vstate.options&0x03) == 0x02) {
c0d02cf0:	5820      	ldr	r0, [r4, r0]
c0d02cf2:	2603      	movs	r6, #3
c0d02cf4:	4030      	ands	r0, r6
c0d02cf6:	2802      	cmp	r0, #2
c0d02cf8:	d105      	bne.n	c0d02d06 <monero_apdu_mlsag_prehash_update+0x86>
c0d02cfa:	207b      	movs	r0, #123	; 0x7b
c0d02cfc:	00c0      	lsls	r0, r0, #3
        monero_keccak_update_H(v,8);
c0d02cfe:	1820      	adds	r0, r4, r0
c0d02d00:	a916      	add	r1, sp, #88	; 0x58
c0d02d02:	2208      	movs	r2, #8
c0d02d04:	e00f      	b.n	c0d02d26 <monero_apdu_mlsag_prehash_update+0xa6>
c0d02d06:	207b      	movs	r0, #123	; 0x7b
c0d02d08:	00c0      	lsls	r0, r0, #3
c0d02d0a:	462c      	mov	r4, r5
    } else {
        monero_keccak_update_H(k,32);
c0d02d0c:	4963      	ldr	r1, [pc, #396]	; (c0d02e9c <monero_apdu_mlsag_prehash_update+0x21c>)
c0d02d0e:	180d      	adds	r5, r1, r0
c0d02d10:	a90e      	add	r1, sp, #56	; 0x38
c0d02d12:	2720      	movs	r7, #32
c0d02d14:	4628      	mov	r0, r5
c0d02d16:	463a      	mov	r2, r7
c0d02d18:	f7fd fac0 	bl	c0d0029c <monero_hash_update>
c0d02d1c:	a916      	add	r1, sp, #88	; 0x58
        monero_keccak_update_H(v,32);
c0d02d1e:	4628      	mov	r0, r5
c0d02d20:	4625      	mov	r5, r4
c0d02d22:	4c5e      	ldr	r4, [pc, #376]	; (c0d02e9c <monero_apdu_mlsag_prehash_update+0x21c>)
c0d02d24:	463a      	mov	r2, r7
c0d02d26:	f7fd fab9 	bl	c0d0029c <monero_hash_update>
c0d02d2a:	2005      	movs	r0, #5
c0d02d2c:	0180      	lsls	r0, r0, #6
    }

    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02d2e:	5820      	ldr	r0, [r4, r0]
c0d02d30:	2109      	movs	r1, #9
c0d02d32:	030f      	lsls	r7, r1, #12
c0d02d34:	2801      	cmp	r0, #1
c0d02d36:	d000      	beq.n	c0d02d3a <monero_apdu_mlsag_prehash_update+0xba>
c0d02d38:	e0a6      	b.n	c0d02e88 <monero_apdu_mlsag_prehash_update+0x208>
c0d02d3a:	2059      	movs	r0, #89	; 0x59
c0d02d3c:	0080      	lsls	r0, r0, #2
        if ((os_memcmp(Aout, G_monero_vstate.A, 32) == 0) && (os_memcmp(Bout, G_monero_vstate.B, 32) == 0)) {
c0d02d3e:	1821      	adds	r1, r4, r0
c0d02d40:	2220      	movs	r2, #32
c0d02d42:	9804      	ldr	r0, [sp, #16]
c0d02d44:	f000 fede 	bl	c0d03b04 <os_memcmp>
c0d02d48:	2800      	cmp	r0, #0
c0d02d4a:	d108      	bne.n	c0d02d5e <monero_apdu_mlsag_prehash_update+0xde>
c0d02d4c:	2069      	movs	r0, #105	; 0x69
c0d02d4e:	0080      	lsls	r0, r0, #2
c0d02d50:	1821      	adds	r1, r4, r0
c0d02d52:	2220      	movs	r2, #32
c0d02d54:	4628      	mov	r0, r5
c0d02d56:	f000 fed5 	bl	c0d03b04 <os_memcmp>
c0d02d5a:	2800      	cmp	r0, #0
c0d02d5c:	d00d      	beq.n	c0d02d7a <monero_apdu_mlsag_prehash_update+0xfa>
c0d02d5e:	a82e      	add	r0, sp, #184	; 0xb8
            is_change = 1;
        }
        if (is_change == 0) {
c0d02d60:	7800      	ldrb	r0, [r0, #0]
c0d02d62:	2800      	cmp	r0, #0
c0d02d64:	d10c      	bne.n	c0d02d80 <monero_apdu_mlsag_prehash_update+0x100>
c0d02d66:	20e9      	movs	r0, #233	; 0xe9
c0d02d68:	00c0      	lsls	r0, r0, #3
            //encode dest adress
            monero_base58_public_key(&G_monero_vstate.ux_address[0], Aout, Bout, is_subaddress);
c0d02d6a:	1820      	adds	r0, r4, r0
c0d02d6c:	9902      	ldr	r1, [sp, #8]
c0d02d6e:	b2cb      	uxtb	r3, r1
c0d02d70:	9904      	ldr	r1, [sp, #16]
c0d02d72:	462a      	mov	r2, r5
c0d02d74:	f7ff fdaa 	bl	c0d028cc <monero_base58_public_key>
c0d02d78:	e002      	b.n	c0d02d80 <monero_apdu_mlsag_prehash_update+0x100>
c0d02d7a:	a82e      	add	r0, sp, #184	; 0xb8
c0d02d7c:	2101      	movs	r1, #1
        monero_keccak_update_H(v,32);
    }

    if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
        if ((os_memcmp(Aout, G_monero_vstate.A, 32) == 0) && (os_memcmp(Bout, G_monero_vstate.B, 32) == 0)) {
            is_change = 1;
c0d02d7e:	7001      	strb	r1, [r0, #0]
        if (is_change == 0) {
            //encode dest adress
            monero_base58_public_key(&G_monero_vstate.ux_address[0], Aout, Bout, is_subaddress);
        }
        //update destination hash control
        if (G_monero_vstate.io_protocol_version == 2) {
c0d02d80:	78a0      	ldrb	r0, [r4, #2]
c0d02d82:	2802      	cmp	r0, #2
c0d02d84:	d11a      	bne.n	c0d02dbc <monero_apdu_mlsag_prehash_update+0x13c>
c0d02d86:	2017      	movs	r0, #23
c0d02d88:	0180      	lsls	r0, r0, #6
c0d02d8a:	9501      	str	r5, [sp, #4]
            monero_sha256_outkeys_update(Aout,32);
c0d02d8c:	1825      	adds	r5, r4, r0
c0d02d8e:	9702      	str	r7, [sp, #8]
c0d02d90:	2720      	movs	r7, #32
c0d02d92:	4628      	mov	r0, r5
c0d02d94:	9904      	ldr	r1, [sp, #16]
c0d02d96:	463a      	mov	r2, r7
c0d02d98:	f7fd fa80 	bl	c0d0029c <monero_hash_update>
            monero_sha256_outkeys_update(Bout,32);
c0d02d9c:	4628      	mov	r0, r5
c0d02d9e:	9901      	ldr	r1, [sp, #4]
c0d02da0:	463a      	mov	r2, r7
c0d02da2:	f7fd fa7b 	bl	c0d0029c <monero_hash_update>
c0d02da6:	a92e      	add	r1, sp, #184	; 0xb8
c0d02da8:	2201      	movs	r2, #1
            monero_sha256_outkeys_update(&is_change,1);
c0d02daa:	4628      	mov	r0, r5
c0d02dac:	f7fd fa76 	bl	c0d0029c <monero_hash_update>
c0d02db0:	a926      	add	r1, sp, #152	; 0x98
            monero_sha256_outkeys_update(AKout,32);
c0d02db2:	4628      	mov	r0, r5
c0d02db4:	463a      	mov	r2, r7
c0d02db6:	9f02      	ldr	r7, [sp, #8]
c0d02db8:	f7fd fa70 	bl	c0d0029c <monero_hash_update>
        }

        //check C = aH+kG
        monero_unblind(v,k, AKout, G_monero_vstate.options&0x03);
c0d02dbc:	9805      	ldr	r0, [sp, #20]
c0d02dbe:	5823      	ldr	r3, [r4, r0]
c0d02dc0:	4033      	ands	r3, r6
c0d02dc2:	ad16      	add	r5, sp, #88	; 0x58
c0d02dc4:	ae0e      	add	r6, sp, #56	; 0x38
c0d02dc6:	aa26      	add	r2, sp, #152	; 0x98
c0d02dc8:	4628      	mov	r0, r5
c0d02dca:	4631      	mov	r1, r6
c0d02dcc:	f7fd f996 	bl	c0d000fc <monero_unblind>
c0d02dd0:	a806      	add	r0, sp, #24
        monero_ecmul_G(kG, k);
c0d02dd2:	4631      	mov	r1, r6
c0d02dd4:	f7fd fd32 	bl	c0d0083c <monero_ecmul_G>
c0d02dd8:	2120      	movs	r1, #32
        if (!cx_math_is_zero(v, 32)) {
c0d02dda:	4628      	mov	r0, r5
c0d02ddc:	f001 fdf6 	bl	c0d049cc <cx_math_is_zero>
c0d02de0:	2800      	cmp	r0, #0
c0d02de2:	d005      	beq.n	c0d02df0 <monero_apdu_mlsag_prehash_update+0x170>
c0d02de4:	a826      	add	r0, sp, #152	; 0x98
c0d02de6:	a906      	add	r1, sp, #24
c0d02de8:	2220      	movs	r2, #32
            monero_ecmul_H(aH, v);
            monero_ecadd(aH, kG, aH);
        } else {
            os_memmove(aH, kG, 32);
c0d02dea:	f000 fdd0 	bl	c0d0398e <os_memmove>
c0d02dee:	e009      	b.n	c0d02e04 <monero_apdu_mlsag_prehash_update+0x184>
c0d02df0:	ad26      	add	r5, sp, #152	; 0x98
c0d02df2:	a916      	add	r1, sp, #88	; 0x58

        //check C = aH+kG
        monero_unblind(v,k, AKout, G_monero_vstate.options&0x03);
        monero_ecmul_G(kG, k);
        if (!cx_math_is_zero(v, 32)) {
            monero_ecmul_H(aH, v);
c0d02df4:	4628      	mov	r0, r5
c0d02df6:	f7fd ff25 	bl	c0d00c44 <monero_ecmul_H>
c0d02dfa:	a906      	add	r1, sp, #24
            monero_ecadd(aH, kG, aH);
c0d02dfc:	4628      	mov	r0, r5
c0d02dfe:	462a      	mov	r2, r5
c0d02e00:	f7fd fdeb 	bl	c0d009da <monero_ecadd>
c0d02e04:	a81e      	add	r0, sp, #120	; 0x78
c0d02e06:	a926      	add	r1, sp, #152	; 0x98
c0d02e08:	2220      	movs	r2, #32
        } else {
            os_memmove(aH, kG, 32);
        }
        if (os_memcmp(C, aH, 32)) {
c0d02e0a:	f000 fe7b 	bl	c0d03b04 <os_memcmp>
c0d02e0e:	2800      	cmp	r0, #0
c0d02e10:	d13d      	bne.n	c0d02e8e <monero_apdu_mlsag_prehash_update+0x20e>
c0d02e12:	4824      	ldr	r0, [pc, #144]	; (c0d02ea4 <monero_apdu_mlsag_prehash_update+0x224>)
            THROW(SW_SECURITY_COMMITMENT_CONTROL);
        }
        //update commitment hash control
        monero_sha256_commitment_update(C,32);
c0d02e14:	1826      	adds	r6, r4, r0
c0d02e16:	a91e      	add	r1, sp, #120	; 0x78
c0d02e18:	2220      	movs	r2, #32
c0d02e1a:	4630      	mov	r0, r6
c0d02e1c:	f7fd fa3e 	bl	c0d0029c <monero_hash_update>


        if ((G_monero_vstate.options & IN_OPTION_MORE_COMMAND)==0) {
c0d02e20:	9805      	ldr	r0, [sp, #20]
c0d02e22:	5c20      	ldrb	r0, [r4, r0]
c0d02e24:	0600      	lsls	r0, r0, #24
c0d02e26:	d41a      	bmi.n	c0d02e5e <monero_apdu_mlsag_prehash_update+0x1de>
            if (G_monero_vstate.io_protocol_version == 2) {
c0d02e28:	78a0      	ldrb	r0, [r4, #2]
c0d02e2a:	2802      	cmp	r0, #2
c0d02e2c:	d10e      	bne.n	c0d02e4c <monero_apdu_mlsag_prehash_update+0x1cc>
c0d02e2e:	2017      	movs	r0, #23
c0d02e30:	0180      	lsls	r0, r0, #6
                //finalize and check destination hash_control
                monero_sha256_outkeys_final(k);
c0d02e32:	1820      	adds	r0, r4, r0
c0d02e34:	ad0e      	add	r5, sp, #56	; 0x38
c0d02e36:	4629      	mov	r1, r5
c0d02e38:	f7fd fa3c 	bl	c0d002b4 <monero_hash_final>
c0d02e3c:	481a      	ldr	r0, [pc, #104]	; (c0d02ea8 <monero_apdu_mlsag_prehash_update+0x228>)
                if (os_memcmp(k, G_monero_vstate.OUTK, 32)) {
c0d02e3e:	1821      	adds	r1, r4, r0
c0d02e40:	2220      	movs	r2, #32
c0d02e42:	4628      	mov	r0, r5
c0d02e44:	f000 fe5e 	bl	c0d03b04 <os_memcmp>
c0d02e48:	2800      	cmp	r0, #0
c0d02e4a:	d123      	bne.n	c0d02e94 <monero_apdu_mlsag_prehash_update+0x214>
c0d02e4c:	20d7      	movs	r0, #215	; 0xd7
c0d02e4e:	00c0      	lsls	r0, r0, #3
                    THROW(SW_SECURITY_OUTKEYS_CHAIN_CONTROL);
                }
            }
            //finalize commitment hash control
            monero_sha256_commitment_final(NULL);
c0d02e50:	1821      	adds	r1, r4, r0
c0d02e52:	4630      	mov	r0, r6
c0d02e54:	f7fd fa2e 	bl	c0d002b4 <monero_hash_final>
            monero_sha256_commitment_init();
c0d02e58:	4630      	mov	r0, r6
c0d02e5a:	f7fd fa6c 	bl	c0d00336 <monero_hash_init_sha256>
c0d02e5e:	a816      	add	r0, sp, #88	; 0x58
        }

        //ask user
        uint64_t amount;
        amount = monero_bamount2uint64(v);
c0d02e60:	f7fe f873 	bl	c0d00f4a <monero_bamount2uint64>
c0d02e64:	aa2e      	add	r2, sp, #184	; 0xb8
        if (!is_change && amount) {
c0d02e66:	4603      	mov	r3, r0
c0d02e68:	430b      	orrs	r3, r1
c0d02e6a:	2b00      	cmp	r3, #0
c0d02e6c:	d00c      	beq.n	c0d02e88 <monero_apdu_mlsag_prehash_update+0x208>
c0d02e6e:	7812      	ldrb	r2, [r2, #0]
c0d02e70:	2a00      	cmp	r2, #0
c0d02e72:	d109      	bne.n	c0d02e88 <monero_apdu_mlsag_prehash_update+0x208>
c0d02e74:	22f5      	movs	r2, #245	; 0xf5
c0d02e76:	00d2      	lsls	r2, r2, #3
            monero_amount2str(amount, G_monero_vstate.ux_amount, 15);
c0d02e78:	18a2      	adds	r2, r4, r2
c0d02e7a:	230f      	movs	r3, #15
c0d02e7c:	f7fd fff2 	bl	c0d00e64 <monero_amount2str>
c0d02e80:	9f03      	ldr	r7, [sp, #12]
            ui_menu_validation_display(0);
c0d02e82:	4638      	mov	r0, r7
c0d02e84:	f000 fa28 	bl	c0d032d8 <ui_menu_validation_display>
        }
    }
    return SW_OK;

    #undef aH
}
c0d02e88:	4638      	mov	r0, r7
c0d02e8a:	b02f      	add	sp, #188	; 0xbc
c0d02e8c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02e8e:	4804      	ldr	r0, [pc, #16]	; (c0d02ea0 <monero_apdu_mlsag_prehash_update+0x220>)
            monero_ecadd(aH, kG, aH);
        } else {
            os_memmove(aH, kG, 32);
        }
        if (os_memcmp(C, aH, 32)) {
            THROW(SW_SECURITY_COMMITMENT_CONTROL);
c0d02e90:	f000 fe4c 	bl	c0d03b2c <os_longjmp>
c0d02e94:	4802      	ldr	r0, [pc, #8]	; (c0d02ea0 <monero_apdu_mlsag_prehash_update+0x220>)
        if ((G_monero_vstate.options & IN_OPTION_MORE_COMMAND)==0) {
            if (G_monero_vstate.io_protocol_version == 2) {
                //finalize and check destination hash_control
                monero_sha256_outkeys_final(k);
                if (os_memcmp(k, G_monero_vstate.OUTK, 32)) {
                    THROW(SW_SECURITY_OUTKEYS_CHAIN_CONTROL);
c0d02e96:	1cc0      	adds	r0, r0, #3
c0d02e98:	f000 fe48 	bl	c0d03b2c <os_longjmp>
c0d02e9c:	20001930 	.word	0x20001930
c0d02ea0:	00006911 	.word	0x00006911
c0d02ea4:	0000064c 	.word	0x0000064c
c0d02ea8:	0000062c 	.word	0x0000062c

c0d02eac <monero_apdu_mlsag_prehash_finalize>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_mlsag_prehash_finalize() {
c0d02eac:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02eae:	b099      	sub	sp, #100	; 0x64
c0d02eb0:	204f      	movs	r0, #79	; 0x4f
c0d02eb2:	0080      	lsls	r0, r0, #2
    unsigned char message[32];
    unsigned char proof[32];
    unsigned char H[32];

    if (G_monero_vstate.options & IN_OPTION_MORE_COMMAND) {
c0d02eb4:	4e32      	ldr	r6, [pc, #200]	; (c0d02f80 <monero_apdu_mlsag_prehash_finalize+0xd4>)
c0d02eb6:	5c30      	ldrb	r0, [r6, r0]
c0d02eb8:	0600      	lsls	r0, r0, #24
c0d02eba:	d443      	bmi.n	c0d02f44 <monero_apdu_mlsag_prehash_finalize+0x98>
c0d02ebc:	2005      	movs	r0, #5
c0d02ebe:	0180      	lsls	r0, r0, #6
        monero_io_insert(H, 32);
#endif

    } else {
        //Finalize and check commitment hash control
        if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
c0d02ec0:	5830      	ldr	r0, [r6, r0]
c0d02ec2:	2801      	cmp	r0, #1
c0d02ec4:	d10e      	bne.n	c0d02ee4 <monero_apdu_mlsag_prehash_finalize+0x38>
c0d02ec6:	482f      	ldr	r0, [pc, #188]	; (c0d02f84 <monero_apdu_mlsag_prehash_finalize+0xd8>)
            monero_sha256_commitment_final(H);
c0d02ec8:	1830      	adds	r0, r6, r0
c0d02eca:	ac01      	add	r4, sp, #4
c0d02ecc:	4621      	mov	r1, r4
c0d02ece:	f7fd f9f1 	bl	c0d002b4 <monero_hash_final>
c0d02ed2:	20d7      	movs	r0, #215	; 0xd7
c0d02ed4:	00c0      	lsls	r0, r0, #3
            if (os_memcmp(H,G_monero_vstate.C,32)) {
c0d02ed6:	1831      	adds	r1, r6, r0
c0d02ed8:	2220      	movs	r2, #32
c0d02eda:	4620      	mov	r0, r4
c0d02edc:	f000 fe12 	bl	c0d03b04 <os_memcmp>
c0d02ee0:	2800      	cmp	r0, #0
c0d02ee2:	d149      	bne.n	c0d02f78 <monero_apdu_mlsag_prehash_finalize+0xcc>
c0d02ee4:	207b      	movs	r0, #123	; 0x7b
c0d02ee6:	00c0      	lsls	r0, r0, #3
                THROW(SW_SECURITY_COMMITMENT_CHAIN_CONTROL);
            }
        }
        //compute last H
        monero_keccak_final_H(H);
c0d02ee8:	1834      	adds	r4, r6, r0
c0d02eea:	a901      	add	r1, sp, #4
c0d02eec:	9100      	str	r1, [sp, #0]
c0d02eee:	4620      	mov	r0, r4
c0d02ef0:	f7fd f9e0 	bl	c0d002b4 <monero_hash_final>
c0d02ef4:	ad11      	add	r5, sp, #68	; 0x44
c0d02ef6:	2620      	movs	r6, #32
        //compute last prehash
        monero_io_fetch(message,32);
c0d02ef8:	4628      	mov	r0, r5
c0d02efa:	4631      	mov	r1, r6
c0d02efc:	f7fe fb48 	bl	c0d01590 <monero_io_fetch>
c0d02f00:	af09      	add	r7, sp, #36	; 0x24
        monero_io_fetch(proof,32);
c0d02f02:	4638      	mov	r0, r7
c0d02f04:	4631      	mov	r1, r6
c0d02f06:	f7fe fb43 	bl	c0d01590 <monero_io_fetch>
c0d02f0a:	2001      	movs	r0, #1
        monero_io_discard(1);
c0d02f0c:	f7fe fab2 	bl	c0d01474 <monero_io_discard>
        monero_keccak_init_H();
c0d02f10:	4620      	mov	r0, r4
c0d02f12:	f7fd f9bd 	bl	c0d00290 <monero_hash_init_keccak>
        monero_keccak_update_H(message,32);
c0d02f16:	4620      	mov	r0, r4
c0d02f18:	4629      	mov	r1, r5
c0d02f1a:	4632      	mov	r2, r6
c0d02f1c:	f7fd f9be 	bl	c0d0029c <monero_hash_update>
        monero_keccak_update_H(H,32);
c0d02f20:	4620      	mov	r0, r4
c0d02f22:	9900      	ldr	r1, [sp, #0]
c0d02f24:	4632      	mov	r2, r6
c0d02f26:	f7fd f9b9 	bl	c0d0029c <monero_hash_update>
        monero_keccak_update_H(proof,32);
c0d02f2a:	4620      	mov	r0, r4
c0d02f2c:	4639      	mov	r1, r7
c0d02f2e:	4632      	mov	r2, r6
c0d02f30:	f7fd f9b4 	bl	c0d0029c <monero_hash_update>
c0d02f34:	200b      	movs	r0, #11
c0d02f36:	01c0      	lsls	r0, r0, #7
        monero_keccak_final_H(NULL);
c0d02f38:	4911      	ldr	r1, [pc, #68]	; (c0d02f80 <monero_apdu_mlsag_prehash_finalize+0xd4>)
c0d02f3a:	1809      	adds	r1, r1, r0
c0d02f3c:	4620      	mov	r0, r4
c0d02f3e:	f7fd f9b9 	bl	c0d002b4 <monero_hash_final>
c0d02f42:	e015      	b.n	c0d02f70 <monero_apdu_mlsag_prehash_finalize+0xc4>
c0d02f44:	ac01      	add	r4, sp, #4
c0d02f46:	2520      	movs	r5, #32
    unsigned char proof[32];
    unsigned char H[32];

    if (G_monero_vstate.options & IN_OPTION_MORE_COMMAND) {
        //accumulate
        monero_io_fetch(H,32);
c0d02f48:	4620      	mov	r0, r4
c0d02f4a:	4629      	mov	r1, r5
c0d02f4c:	f7fe fb20 	bl	c0d01590 <monero_io_fetch>
c0d02f50:	2001      	movs	r0, #1
        monero_io_discard(1);
c0d02f52:	f7fe fa8f 	bl	c0d01474 <monero_io_discard>
c0d02f56:	207b      	movs	r0, #123	; 0x7b
c0d02f58:	00c0      	lsls	r0, r0, #3
        monero_keccak_update_H(H,32);
c0d02f5a:	1830      	adds	r0, r6, r0
c0d02f5c:	4621      	mov	r1, r4
c0d02f5e:	462a      	mov	r2, r5
c0d02f60:	f7fd f99c 	bl	c0d0029c <monero_hash_update>
c0d02f64:	4807      	ldr	r0, [pc, #28]	; (c0d02f84 <monero_apdu_mlsag_prehash_finalize+0xd8>)
        monero_sha256_commitment_update(H,32);
c0d02f66:	1830      	adds	r0, r6, r0
c0d02f68:	4621      	mov	r1, r4
c0d02f6a:	462a      	mov	r2, r5
c0d02f6c:	f7fd f996 	bl	c0d0029c <monero_hash_update>
c0d02f70:	2009      	movs	r0, #9
c0d02f72:	0300      	lsls	r0, r0, #12
        monero_io_insert(G_monero_vstate.H, 32);
        monero_io_insert(H, 32);
#endif
    }

    return SW_OK;
c0d02f74:	b019      	add	sp, #100	; 0x64
c0d02f76:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02f78:	4803      	ldr	r0, [pc, #12]	; (c0d02f88 <monero_apdu_mlsag_prehash_finalize+0xdc>)
    } else {
        //Finalize and check commitment hash control
        if (G_monero_vstate.sig_mode == TRANSACTION_CREATE_REAL) {
            monero_sha256_commitment_final(H);
            if (os_memcmp(H,G_monero_vstate.C,32)) {
                THROW(SW_SECURITY_COMMITMENT_CHAIN_CONTROL);
c0d02f7a:	f000 fdd7 	bl	c0d03b2c <os_longjmp>
c0d02f7e:	46c0      	nop			; (mov r8, r8)
c0d02f80:	20001930 	.word	0x20001930
c0d02f84:	0000064c 	.word	0x0000064c
c0d02f88:	00006913 	.word	0x00006913

c0d02f8c <monero_apdu_stealth>:


/* ----------------------------------------------------------------------- */
/* ---                                                                 --- */
/* ----------------------------------------------------------------------- */
int monero_apdu_stealth() {
c0d02f8c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d02f8e:	b09d      	sub	sp, #116	; 0x74
c0d02f90:	af15      	add	r7, sp, #84	; 0x54
c0d02f92:	2120      	movs	r1, #32
    unsigned char sec[32];
    unsigned char drv[33];
    unsigned char payID[8];
    
    //fetch pub
    monero_io_fetch(pub,32);
c0d02f94:	9101      	str	r1, [sp, #4]
c0d02f96:	4638      	mov	r0, r7
c0d02f98:	f7fe fafa 	bl	c0d01590 <monero_io_fetch>
c0d02f9c:	ae0d      	add	r6, sp, #52	; 0x34
    //fetch sec
    monero_io_fetch_decrypt_key(sec);
c0d02f9e:	4630      	mov	r0, r6
c0d02fa0:	f7fe fb34 	bl	c0d0160c <monero_io_fetch_decrypt_key>
c0d02fa4:	a802      	add	r0, sp, #8
c0d02fa6:	2108      	movs	r1, #8
    //fetch paymentID
    monero_io_fetch(payID,8);
c0d02fa8:	f7fe faf2 	bl	c0d01590 <monero_io_fetch>
c0d02fac:	2400      	movs	r4, #0

    monero_io_discard(0);
c0d02fae:	4620      	mov	r0, r4
c0d02fb0:	f7fe fa60 	bl	c0d01474 <monero_io_discard>
c0d02fb4:	ad04      	add	r5, sp, #16

    //Compute Dout
    monero_generate_key_derivation(drv, pub, sec);
c0d02fb6:	4628      	mov	r0, r5
c0d02fb8:	4639      	mov	r1, r7
c0d02fba:	4632      	mov	r2, r6
c0d02fbc:	f7fd fc6c 	bl	c0d00898 <monero_generate_key_derivation>
c0d02fc0:	208d      	movs	r0, #141	; 0x8d
    
    //compute mask
    drv[32] = ENCRYPTED_PAYMENT_ID_TAIL;
c0d02fc2:	9901      	ldr	r1, [sp, #4]
c0d02fc4:	5468      	strb	r0, [r5, r1]
    monero_keccak_F(drv,33,sec);
c0d02fc6:	4668      	mov	r0, sp
c0d02fc8:	6006      	str	r6, [r0, #0]
c0d02fca:	2023      	movs	r0, #35	; 0x23
c0d02fcc:	0100      	lsls	r0, r0, #4
c0d02fce:	490c      	ldr	r1, [pc, #48]	; (c0d03000 <monero_apdu_stealth+0x74>)
c0d02fd0:	1809      	adds	r1, r1, r0
c0d02fd2:	2006      	movs	r0, #6
c0d02fd4:	2321      	movs	r3, #33	; 0x21
c0d02fd6:	462a      	mov	r2, r5
c0d02fd8:	f7fd f978 	bl	c0d002cc <monero_hash>
c0d02fdc:	a802      	add	r0, sp, #8
    
    //stealth!
    for (i=0; i<8; i++) {
        payID[i] = payID[i] ^ sec[i];
c0d02fde:	5d01      	ldrb	r1, [r0, r4]
c0d02fe0:	aa0d      	add	r2, sp, #52	; 0x34
c0d02fe2:	5d12      	ldrb	r2, [r2, r4]
c0d02fe4:	404a      	eors	r2, r1
c0d02fe6:	5502      	strb	r2, [r0, r4]
    //compute mask
    drv[32] = ENCRYPTED_PAYMENT_ID_TAIL;
    monero_keccak_F(drv,33,sec);
    
    //stealth!
    for (i=0; i<8; i++) {
c0d02fe8:	1c64      	adds	r4, r4, #1
c0d02fea:	2c08      	cmp	r4, #8
c0d02fec:	d1f6      	bne.n	c0d02fdc <monero_apdu_stealth+0x50>
c0d02fee:	a802      	add	r0, sp, #8
c0d02ff0:	2108      	movs	r1, #8
        payID[i] = payID[i] ^ sec[i];
    }
    
    monero_io_insert(payID,8);
c0d02ff2:	f7fe fa6b 	bl	c0d014cc <monero_io_insert>
c0d02ff6:	2009      	movs	r0, #9
c0d02ff8:	0300      	lsls	r0, r0, #12

    return SW_OK;
c0d02ffa:	b01d      	add	sp, #116	; 0x74
c0d02ffc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d02ffe:	46c0      	nop			; (mov r8, r8)
c0d03000:	20001930 	.word	0x20001930

c0d03004 <ui_menu_fee_validation_action>:
    }
  }
  return element;
}

void ui_menu_fee_validation_action(unsigned int value) {
c0d03004:	b580      	push	{r7, lr}
c0d03006:	4601      	mov	r1, r0
c0d03008:	2009      	movs	r0, #9
c0d0300a:	0300      	lsls	r0, r0, #12
c0d0300c:	4a09      	ldr	r2, [pc, #36]	; (c0d03034 <ui_menu_fee_validation_action+0x30>)
  unsigned short sw;
  if (value == ACCEPT) {
c0d0300e:	4291      	cmp	r1, r2
c0d03010:	d002      	beq.n	c0d03018 <ui_menu_fee_validation_action+0x14>
    sw = 0x9000;
  } else {
   sw = SW_SECURITY_STATUS_NOT_SATISFIED;
    monero_abort_tx();
c0d03012:	f7ff fdc5 	bl	c0d02ba0 <monero_abort_tx>
c0d03016:	4808      	ldr	r0, [pc, #32]	; (c0d03038 <ui_menu_fee_validation_action+0x34>)
  }
  monero_io_insert_u16(sw);
c0d03018:	f7fe fa9c 	bl	c0d01554 <monero_io_insert_u16>
c0d0301c:	2020      	movs	r0, #32
  monero_io_do(IO_RETURN_AFTER_TX);
c0d0301e:	f7fe fb55 	bl	c0d016cc <monero_io_do>
c0d03022:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03024:	4905      	ldr	r1, [pc, #20]	; (c0d0303c <ui_menu_fee_validation_action+0x38>)
c0d03026:	4479      	add	r1, pc
c0d03028:	4a05      	ldr	r2, [pc, #20]	; (c0d03040 <ui_menu_fee_validation_action+0x3c>)
c0d0302a:	447a      	add	r2, pc
c0d0302c:	f001 fb0c 	bl	c0d04648 <ux_menu_display>
    monero_abort_tx();
  }
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
}
c0d03030:	bd80      	pop	{r7, pc}
c0d03032:	46c0      	nop			; (mov r8, r8)
c0d03034:	0000acce 	.word	0x0000acce
c0d03038:	00006982 	.word	0x00006982
c0d0303c:	00004746 	.word	0x00004746
c0d03040:	000006e7 	.word	0x000006e7

c0d03044 <ui_menu_fee_validation_preprocessor>:
};

const bagl_element_t* ui_menu_fee_validation_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {

  /* --- Amount --- */
  if (entry == &ui_menu_fee_validation[0]) {
c0d03044:	4a07      	ldr	r2, [pc, #28]	; (c0d03064 <ui_menu_fee_validation_preprocessor+0x20>)
c0d03046:	447a      	add	r2, pc
c0d03048:	4290      	cmp	r0, r2
c0d0304a:	d107      	bne.n	c0d0305c <ui_menu_fee_validation_preprocessor+0x18>
    if(element->component.userid==0x22) {
c0d0304c:	7848      	ldrb	r0, [r1, #1]
c0d0304e:	2822      	cmp	r0, #34	; 0x22
c0d03050:	d104      	bne.n	c0d0305c <ui_menu_fee_validation_preprocessor+0x18>
c0d03052:	20f5      	movs	r0, #245	; 0xf5
c0d03054:	00c0      	lsls	r0, r0, #3
      element->text = G_monero_vstate.ux_amount;
c0d03056:	4a02      	ldr	r2, [pc, #8]	; (c0d03060 <ui_menu_fee_validation_preprocessor+0x1c>)
c0d03058:	1810      	adds	r0, r2, r0
c0d0305a:	61c8      	str	r0, [r1, #28]
    }
  }
  return element;
c0d0305c:	4608      	mov	r0, r1
c0d0305e:	4770      	bx	lr
c0d03060:	20001930 	.word	0x20001930
c0d03064:	00003fd2 	.word	0x00003fd2

c0d03068 <ui_menu_main_display>:
      element->text = G_monero_vstate.ux_menu;
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
c0d03068:	b580      	push	{r7, lr}
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d0306a:	4903      	ldr	r1, [pc, #12]	; (c0d03078 <ui_menu_main_display+0x10>)
c0d0306c:	4479      	add	r1, pc
c0d0306e:	4a03      	ldr	r2, [pc, #12]	; (c0d0307c <ui_menu_main_display+0x14>)
c0d03070:	447a      	add	r2, pc
c0d03072:	f001 fae9 	bl	c0d04648 <ux_menu_display>
}
c0d03076:	bd80      	pop	{r7, pc}
c0d03078:	00004700 	.word	0x00004700
c0d0307c:	000006a1 	.word	0x000006a1

c0d03080 <ui_menu_fee_validation_display>:
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
}

void ui_menu_fee_validation_display(unsigned int value) {
c0d03080:	b580      	push	{r7, lr}
c0d03082:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_fee_validation, ui_menu_fee_validation_preprocessor);
c0d03084:	4903      	ldr	r1, [pc, #12]	; (c0d03094 <ui_menu_fee_validation_display+0x14>)
c0d03086:	4479      	add	r1, pc
c0d03088:	4a03      	ldr	r2, [pc, #12]	; (c0d03098 <ui_menu_fee_validation_display+0x18>)
c0d0308a:	447a      	add	r2, pc
c0d0308c:	f001 fadc 	bl	c0d04648 <ux_menu_display>
}
c0d03090:	bd80      	pop	{r7, pc}
c0d03092:	46c0      	nop			; (mov r8, r8)
c0d03094:	00003f92 	.word	0x00003f92
c0d03098:	ffffffb7 	.word	0xffffffb7

c0d0309c <ui_menu_words_back>:
}
void ui_menu_words_clear(unsigned int value) {
  monero_clear_words();
  ui_menu_main_display(0);
}
void ui_menu_words_back(unsigned int value) {
c0d0309c:	b580      	push	{r7, lr}
c0d0309e:	2001      	movs	r0, #1
  UX_MENU_END
};


void ui_menu_settings_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_settings, NULL);
c0d030a0:	4902      	ldr	r1, [pc, #8]	; (c0d030ac <ui_menu_words_back+0x10>)
c0d030a2:	4479      	add	r1, pc
c0d030a4:	2200      	movs	r2, #0
c0d030a6:	f001 facf 	bl	c0d04648 <ux_menu_display>
  monero_clear_words();
  ui_menu_main_display(0);
}
void ui_menu_words_back(unsigned int value) {
  ui_menu_settings_display(1);
}
c0d030aa:	bd80      	pop	{r7, pc}
c0d030ac:	000044d2 	.word	0x000044d2

c0d030b0 <ui_menu_words_clear>:
}

void ui_menu_words_display(unsigned int value) {
  UX_MENU_DISPLAY(0, ui_menu_words, ui_menu_words_preprocessor);
}
void ui_menu_words_clear(unsigned int value) {
c0d030b0:	b580      	push	{r7, lr}
  monero_clear_words();
c0d030b2:	f7fe fb49 	bl	c0d01748 <monero_clear_words>
c0d030b6:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d030b8:	4903      	ldr	r1, [pc, #12]	; (c0d030c8 <ui_menu_words_clear+0x18>)
c0d030ba:	4479      	add	r1, pc
c0d030bc:	4a03      	ldr	r2, [pc, #12]	; (c0d030cc <ui_menu_words_clear+0x1c>)
c0d030be:	447a      	add	r2, pc
c0d030c0:	f001 fac2 	bl	c0d04648 <ux_menu_display>
  UX_MENU_DISPLAY(0, ui_menu_words, ui_menu_words_preprocessor);
}
void ui_menu_words_clear(unsigned int value) {
  monero_clear_words();
  ui_menu_main_display(0);
}
c0d030c4:	bd80      	pop	{r7, pc}
c0d030c6:	46c0      	nop			; (mov r8, r8)
c0d030c8:	000046b2 	.word	0x000046b2
c0d030cc:	00000653 	.word	0x00000653

c0d030d0 <ui_menu_words_preprocessor>:
  {NULL,  ui_menu_words_back,                  24,     NULL,  "",  "",    0, 0},
  {NULL,  ui_menu_words_clear,                 -1,     NULL,  "CLEAR WORDS",  "(NO WIPE)",    0, 0},
  UX_MENU_END
};

const bagl_element_t* ui_menu_words_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d030d0:	b5b0      	push	{r4, r5, r7, lr}
c0d030d2:	460c      	mov	r4, r1
  if ((entry->userid >= 0) && (entry->userid <25)) {
c0d030d4:	6881      	ldr	r1, [r0, #8]
c0d030d6:	2918      	cmp	r1, #24
c0d030d8:	d81a      	bhi.n	c0d03110 <ui_menu_words_preprocessor+0x40>
c0d030da:	4605      	mov	r5, r0

    if(element->component.userid==0x21) {
c0d030dc:	7860      	ldrb	r0, [r4, #1]
c0d030de:	2821      	cmp	r0, #33	; 0x21
c0d030e0:	d109      	bne.n	c0d030f6 <ui_menu_words_preprocessor+0x26>
      element->text = N_monero_pstate->words[entry->userid];
c0d030e2:	480c      	ldr	r0, [pc, #48]	; (c0d03114 <ui_menu_words_preprocessor+0x44>)
c0d030e4:	f001 fb40 	bl	c0d04768 <pic>
c0d030e8:	68a9      	ldr	r1, [r5, #8]
c0d030ea:	2214      	movs	r2, #20
c0d030ec:	434a      	muls	r2, r1
c0d030ee:	1880      	adds	r0, r0, r2
c0d030f0:	304a      	adds	r0, #74	; 0x4a
c0d030f2:	61e0      	str	r0, [r4, #28]
    }

    if ((element->component.userid==0x22)&&(entry->userid<24)) {
c0d030f4:	7860      	ldrb	r0, [r4, #1]
c0d030f6:	2822      	cmp	r0, #34	; 0x22
c0d030f8:	d10a      	bne.n	c0d03110 <ui_menu_words_preprocessor+0x40>
c0d030fa:	2917      	cmp	r1, #23
c0d030fc:	d808      	bhi.n	c0d03110 <ui_menu_words_preprocessor+0x40>
      element->text = N_monero_pstate->words[entry->userid+1];
c0d030fe:	4805      	ldr	r0, [pc, #20]	; (c0d03114 <ui_menu_words_preprocessor+0x44>)
c0d03100:	f001 fb32 	bl	c0d04768 <pic>
c0d03104:	68a9      	ldr	r1, [r5, #8]
c0d03106:	2214      	movs	r2, #20
c0d03108:	434a      	muls	r2, r1
c0d0310a:	1880      	adds	r0, r0, r2
c0d0310c:	305e      	adds	r0, #94	; 0x5e
c0d0310e:	61e0      	str	r0, [r4, #28]
    }
  }

  return element;
c0d03110:	4620      	mov	r0, r4
c0d03112:	bdb0      	pop	{r4, r5, r7, pc}
c0d03114:	c0d07c00 	.word	0xc0d07c00

c0d03118 <ui_menu_words_display>:
}

void ui_menu_words_display(unsigned int value) {
c0d03118:	b580      	push	{r7, lr}
c0d0311a:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_words, ui_menu_words_preprocessor);
c0d0311c:	4903      	ldr	r1, [pc, #12]	; (c0d0312c <ui_menu_words_display+0x14>)
c0d0311e:	4479      	add	r1, pc
c0d03120:	4a03      	ldr	r2, [pc, #12]	; (c0d03130 <ui_menu_words_display+0x18>)
c0d03122:	447a      	add	r2, pc
c0d03124:	f001 fa90 	bl	c0d04648 <ux_menu_display>
}
c0d03128:	bd80      	pop	{r7, pc}
c0d0312a:	46c0      	nop			; (mov r8, r8)
c0d0312c:	00003f6a 	.word	0x00003f6a
c0d03130:	ffffffab 	.word	0xffffffab

c0d03134 <ui_menu_validation_action>:

void ui_menu_validation_display(unsigned int value) {
  UX_MENU_DISPLAY(0, ui_menu_validation, ui_menu_validation_preprocessor);
}

void ui_menu_validation_action(unsigned int value) {
c0d03134:	b580      	push	{r7, lr}
c0d03136:	4601      	mov	r1, r0
c0d03138:	2009      	movs	r0, #9
c0d0313a:	0300      	lsls	r0, r0, #12
c0d0313c:	4a09      	ldr	r2, [pc, #36]	; (c0d03164 <ui_menu_validation_action+0x30>)
  unsigned short sw;
  if (value == ACCEPT) {
c0d0313e:	4291      	cmp	r1, r2
c0d03140:	d002      	beq.n	c0d03148 <ui_menu_validation_action+0x14>
    sw = 0x9000;
  } else {
   sw = SW_SECURITY_STATUS_NOT_SATISFIED;
    monero_abort_tx();
c0d03142:	f7ff fd2d 	bl	c0d02ba0 <monero_abort_tx>
c0d03146:	4808      	ldr	r0, [pc, #32]	; (c0d03168 <ui_menu_validation_action+0x34>)
  }
  monero_io_insert_u16(sw);
c0d03148:	f7fe fa04 	bl	c0d01554 <monero_io_insert_u16>
c0d0314c:	2020      	movs	r0, #32
  monero_io_do(IO_RETURN_AFTER_TX);
c0d0314e:	f7fe fabd 	bl	c0d016cc <monero_io_do>
c0d03152:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03154:	4905      	ldr	r1, [pc, #20]	; (c0d0316c <ui_menu_validation_action+0x38>)
c0d03156:	4479      	add	r1, pc
c0d03158:	4a05      	ldr	r2, [pc, #20]	; (c0d03170 <ui_menu_validation_action+0x3c>)
c0d0315a:	447a      	add	r2, pc
c0d0315c:	f001 fa74 	bl	c0d04648 <ux_menu_display>
    monero_abort_tx();
  }
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
}
c0d03160:	bd80      	pop	{r7, pc}
c0d03162:	46c0      	nop			; (mov r8, r8)
c0d03164:	0000acce 	.word	0x0000acce
c0d03168:	00006982 	.word	0x00006982
c0d0316c:	00004616 	.word	0x00004616
c0d03170:	000005b7 	.word	0x000005b7

c0d03174 <ui_menu_validation_preprocessor>:
  {NULL,  ui_menu_validation_action,  REJECT, NULL,  "Reject",       "TX",         0, 0},
  {NULL,  ui_menu_validation_action,  ACCEPT, NULL,  "Accept",       "TX",         0, 0},
  UX_MENU_END
};

const bagl_element_t* ui_menu_validation_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03174:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03176:	b081      	sub	sp, #4
c0d03178:	460c      	mov	r4, r1

  /* --- Amount --- */
  if (entry == &ui_menu_validation[0]) {
c0d0317a:	4956      	ldr	r1, [pc, #344]	; (c0d032d4 <ui_menu_validation_preprocessor+0x160>)
c0d0317c:	4479      	add	r1, pc
c0d0317e:	4288      	cmp	r0, r1
c0d03180:	d02d      	beq.n	c0d031de <ui_menu_validation_preprocessor+0x6a>
    }
  }
#endif

   /* --- Destination --- */
  if (entry == &ui_menu_validation[1]) {
c0d03182:	460a      	mov	r2, r1
c0d03184:	321c      	adds	r2, #28
c0d03186:	4290      	cmp	r0, r2
c0d03188:	d031      	beq.n	c0d031ee <ui_menu_validation_preprocessor+0x7a>
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
      element->text = G_monero_vstate.ux_menu;
    }
  }
  if (entry == &ui_menu_validation[2]) {
c0d0318a:	460a      	mov	r2, r1
c0d0318c:	3238      	adds	r2, #56	; 0x38
c0d0318e:	4290      	cmp	r0, r2
c0d03190:	d042      	beq.n	c0d03218 <ui_menu_validation_preprocessor+0xa4>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[3]) {
c0d03192:	460a      	mov	r2, r1
c0d03194:	3254      	adds	r2, #84	; 0x54
c0d03196:	4290      	cmp	r0, r2
c0d03198:	d055      	beq.n	c0d03246 <ui_menu_validation_preprocessor+0xd2>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[4]) {
c0d0319a:	460a      	mov	r2, r1
c0d0319c:	3270      	adds	r2, #112	; 0x70
c0d0319e:	4290      	cmp	r0, r2
c0d031a0:	d068      	beq.n	c0d03274 <ui_menu_validation_preprocessor+0x100>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*6, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[5]) {
c0d031a2:	318c      	adds	r1, #140	; 0x8c
c0d031a4:	4288      	cmp	r0, r1
c0d031a6:	d000      	beq.n	c0d031aa <ui_menu_validation_preprocessor+0x36>
c0d031a8:	e081      	b.n	c0d032ae <ui_menu_validation_preprocessor+0x13a>
c0d031aa:	20db      	movs	r0, #219	; 0xdb
c0d031ac:	00c6      	lsls	r6, r0, #3
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d031ae:	4f41      	ldr	r7, [pc, #260]	; (c0d032b4 <ui_menu_validation_preprocessor+0x140>)
c0d031b0:	19bd      	adds	r5, r7, r6
c0d031b2:	2100      	movs	r1, #0
c0d031b4:	2270      	movs	r2, #112	; 0x70
c0d031b6:	4628      	mov	r0, r5
c0d031b8:	f000 fbe0 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d031bc:	7860      	ldrb	r0, [r4, #1]
c0d031be:	2821      	cmp	r0, #33	; 0x21
c0d031c0:	d106      	bne.n	c0d031d0 <ui_menu_validation_preprocessor+0x5c>
c0d031c2:	483d      	ldr	r0, [pc, #244]	; (c0d032b8 <ui_menu_validation_preprocessor+0x144>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*7, 11);
c0d031c4:	1839      	adds	r1, r7, r0
c0d031c6:	220b      	movs	r2, #11
c0d031c8:	4628      	mov	r0, r5
c0d031ca:	f000 fbe0 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d031ce:	7860      	ldrb	r0, [r4, #1]
c0d031d0:	2822      	cmp	r0, #34	; 0x22
c0d031d2:	d16a      	bne.n	c0d032aa <ui_menu_validation_preprocessor+0x136>
c0d031d4:	203d      	movs	r0, #61	; 0x3d
c0d031d6:	0140      	lsls	r0, r0, #5
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
c0d031d8:	1839      	adds	r1, r7, r0
c0d031da:	2207      	movs	r2, #7
c0d031dc:	e062      	b.n	c0d032a4 <ui_menu_validation_preprocessor+0x130>

const bagl_element_t* ui_menu_validation_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {

  /* --- Amount --- */
  if (entry == &ui_menu_validation[0]) {
    if(element->component.userid==0x22) {
c0d031de:	7860      	ldrb	r0, [r4, #1]
c0d031e0:	2822      	cmp	r0, #34	; 0x22
c0d031e2:	d164      	bne.n	c0d032ae <ui_menu_validation_preprocessor+0x13a>
c0d031e4:	20f5      	movs	r0, #245	; 0xf5
c0d031e6:	00c0      	lsls	r0, r0, #3
      element->text = G_monero_vstate.ux_amount;
c0d031e8:	4932      	ldr	r1, [pc, #200]	; (c0d032b4 <ui_menu_validation_preprocessor+0x140>)
c0d031ea:	1808      	adds	r0, r1, r0
c0d031ec:	e05e      	b.n	c0d032ac <ui_menu_validation_preprocessor+0x138>
  }
#endif

   /* --- Destination --- */
  if (entry == &ui_menu_validation[1]) {
    if(element->component.userid==0x22) {
c0d031ee:	7860      	ldrb	r0, [r4, #1]
c0d031f0:	2822      	cmp	r0, #34	; 0x22
c0d031f2:	d15c      	bne.n	c0d032ae <ui_menu_validation_preprocessor+0x13a>
c0d031f4:	20db      	movs	r0, #219	; 0xdb
c0d031f6:	00c0      	lsls	r0, r0, #3
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d031f8:	4e2e      	ldr	r6, [pc, #184]	; (c0d032b4 <ui_menu_validation_preprocessor+0x140>)
c0d031fa:	1835      	adds	r5, r6, r0
c0d031fc:	2100      	movs	r1, #0
c0d031fe:	2270      	movs	r2, #112	; 0x70
c0d03200:	4628      	mov	r0, r5
c0d03202:	f000 fbbb 	bl	c0d0397c <os_memset>
c0d03206:	20e9      	movs	r0, #233	; 0xe9
c0d03208:	00c0      	lsls	r0, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
c0d0320a:	1831      	adds	r1, r6, r0
c0d0320c:	220b      	movs	r2, #11
c0d0320e:	4628      	mov	r0, r5
c0d03210:	f000 fbbd 	bl	c0d0398e <os_memmove>
      element->text = G_monero_vstate.ux_menu;
c0d03214:	61e5      	str	r5, [r4, #28]
c0d03216:	e04a      	b.n	c0d032ae <ui_menu_validation_preprocessor+0x13a>
c0d03218:	20db      	movs	r0, #219	; 0xdb
c0d0321a:	00c6      	lsls	r6, r0, #3
    }
  }
  if (entry == &ui_menu_validation[2]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0321c:	4f25      	ldr	r7, [pc, #148]	; (c0d032b4 <ui_menu_validation_preprocessor+0x140>)
c0d0321e:	19bd      	adds	r5, r7, r6
c0d03220:	2100      	movs	r1, #0
c0d03222:	2270      	movs	r2, #112	; 0x70
c0d03224:	4628      	mov	r0, r5
c0d03226:	f000 fba9 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d0322a:	7860      	ldrb	r0, [r4, #1]
c0d0322c:	2821      	cmp	r0, #33	; 0x21
c0d0322e:	d106      	bne.n	c0d0323e <ui_menu_validation_preprocessor+0xca>
c0d03230:	4826      	ldr	r0, [pc, #152]	; (c0d032cc <ui_menu_validation_preprocessor+0x158>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*1, 11);
c0d03232:	1839      	adds	r1, r7, r0
c0d03234:	220b      	movs	r2, #11
c0d03236:	4628      	mov	r0, r5
c0d03238:	f000 fba9 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0323c:	7860      	ldrb	r0, [r4, #1]
c0d0323e:	2822      	cmp	r0, #34	; 0x22
c0d03240:	d133      	bne.n	c0d032aa <ui_menu_validation_preprocessor+0x136>
c0d03242:	4823      	ldr	r0, [pc, #140]	; (c0d032d0 <ui_menu_validation_preprocessor+0x15c>)
c0d03244:	e02c      	b.n	c0d032a0 <ui_menu_validation_preprocessor+0x12c>
c0d03246:	20db      	movs	r0, #219	; 0xdb
c0d03248:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[3]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0324a:	4f1a      	ldr	r7, [pc, #104]	; (c0d032b4 <ui_menu_validation_preprocessor+0x140>)
c0d0324c:	19bd      	adds	r5, r7, r6
c0d0324e:	2100      	movs	r1, #0
c0d03250:	2270      	movs	r2, #112	; 0x70
c0d03252:	4628      	mov	r0, r5
c0d03254:	f000 fb92 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d03258:	7860      	ldrb	r0, [r4, #1]
c0d0325a:	2821      	cmp	r0, #33	; 0x21
c0d0325c:	d106      	bne.n	c0d0326c <ui_menu_validation_preprocessor+0xf8>
c0d0325e:	4819      	ldr	r0, [pc, #100]	; (c0d032c4 <ui_menu_validation_preprocessor+0x150>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*3, 11);
c0d03260:	1839      	adds	r1, r7, r0
c0d03262:	220b      	movs	r2, #11
c0d03264:	4628      	mov	r0, r5
c0d03266:	f000 fb92 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0326a:	7860      	ldrb	r0, [r4, #1]
c0d0326c:	2822      	cmp	r0, #34	; 0x22
c0d0326e:	d11c      	bne.n	c0d032aa <ui_menu_validation_preprocessor+0x136>
c0d03270:	4815      	ldr	r0, [pc, #84]	; (c0d032c8 <ui_menu_validation_preprocessor+0x154>)
c0d03272:	e015      	b.n	c0d032a0 <ui_menu_validation_preprocessor+0x12c>
c0d03274:	20db      	movs	r0, #219	; 0xdb
c0d03276:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_validation[4]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d03278:	4f0e      	ldr	r7, [pc, #56]	; (c0d032b4 <ui_menu_validation_preprocessor+0x140>)
c0d0327a:	19bd      	adds	r5, r7, r6
c0d0327c:	2100      	movs	r1, #0
c0d0327e:	2270      	movs	r2, #112	; 0x70
c0d03280:	4628      	mov	r0, r5
c0d03282:	f000 fb7b 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d03286:	7860      	ldrb	r0, [r4, #1]
c0d03288:	2821      	cmp	r0, #33	; 0x21
c0d0328a:	d106      	bne.n	c0d0329a <ui_menu_validation_preprocessor+0x126>
c0d0328c:	480b      	ldr	r0, [pc, #44]	; (c0d032bc <ui_menu_validation_preprocessor+0x148>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*5, 11);
c0d0328e:	1839      	adds	r1, r7, r0
c0d03290:	220b      	movs	r2, #11
c0d03292:	4628      	mov	r0, r5
c0d03294:	f000 fb7b 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d03298:	7860      	ldrb	r0, [r4, #1]
c0d0329a:	2822      	cmp	r0, #34	; 0x22
c0d0329c:	d105      	bne.n	c0d032aa <ui_menu_validation_preprocessor+0x136>
c0d0329e:	4808      	ldr	r0, [pc, #32]	; (c0d032c0 <ui_menu_validation_preprocessor+0x14c>)
c0d032a0:	1839      	adds	r1, r7, r0
c0d032a2:	220b      	movs	r2, #11
c0d032a4:	4628      	mov	r0, r5
c0d032a6:	f000 fb72 	bl	c0d0398e <os_memmove>
c0d032aa:	19b8      	adds	r0, r7, r6
c0d032ac:	61e0      	str	r0, [r4, #28]
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
    }
    element->text = G_monero_vstate.ux_menu;
  }

  return element;
c0d032ae:	4620      	mov	r0, r4
c0d032b0:	b001      	add	sp, #4
c0d032b2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d032b4:	20001930 	.word	0x20001930
c0d032b8:	00000795 	.word	0x00000795
c0d032bc:	0000077f 	.word	0x0000077f
c0d032c0:	0000078a 	.word	0x0000078a
c0d032c4:	00000769 	.word	0x00000769
c0d032c8:	00000774 	.word	0x00000774
c0d032cc:	00000753 	.word	0x00000753
c0d032d0:	0000075e 	.word	0x0000075e
c0d032d4:	000040b0 	.word	0x000040b0

c0d032d8 <ui_menu_validation_display>:
}

void ui_menu_validation_display(unsigned int value) {
c0d032d8:	b580      	push	{r7, lr}
c0d032da:	2000      	movs	r0, #0
  UX_MENU_DISPLAY(0, ui_menu_validation, ui_menu_validation_preprocessor);
c0d032dc:	4903      	ldr	r1, [pc, #12]	; (c0d032ec <ui_menu_validation_display+0x14>)
c0d032de:	4479      	add	r1, pc
c0d032e0:	4a03      	ldr	r2, [pc, #12]	; (c0d032f0 <ui_menu_validation_display+0x18>)
c0d032e2:	447a      	add	r2, pc
c0d032e4:	f001 f9b0 	bl	c0d04648 <ux_menu_display>
}
c0d032e8:	bd80      	pop	{r7, pc}
c0d032ea:	46c0      	nop			; (mov r8, r8)
c0d032ec:	00003f4e 	.word	0x00003f4e
c0d032f0:	fffffe8f 	.word	0xfffffe8f

c0d032f4 <ui_export_viewkey_display>:
    0, 0,
    NULL, NULL, NULL },

};

void ui_export_viewkey_display(unsigned int value) {
c0d032f4:	b5b0      	push	{r4, r5, r7, lr}
 UX_DISPLAY(ui_export_viewkey, (void*)ui_export_viewkey_prepro);
c0d032f6:	4c23      	ldr	r4, [pc, #140]	; (c0d03384 <ui_export_viewkey_display+0x90>)
c0d032f8:	2005      	movs	r0, #5
c0d032fa:	4924      	ldr	r1, [pc, #144]	; (c0d0338c <ui_export_viewkey_display+0x98>)
c0d032fc:	4479      	add	r1, pc
c0d032fe:	6021      	str	r1, [r4, #0]
c0d03300:	6060      	str	r0, [r4, #4]
c0d03302:	4823      	ldr	r0, [pc, #140]	; (c0d03390 <ui_export_viewkey_display+0x9c>)
c0d03304:	4478      	add	r0, pc
c0d03306:	4923      	ldr	r1, [pc, #140]	; (c0d03394 <ui_export_viewkey_display+0xa0>)
c0d03308:	4479      	add	r1, pc
c0d0330a:	60e1      	str	r1, [r4, #12]
c0d0330c:	6120      	str	r0, [r4, #16]
c0d0330e:	2003      	movs	r0, #3
c0d03310:	7620      	strb	r0, [r4, #24]
c0d03312:	2500      	movs	r5, #0
c0d03314:	61e5      	str	r5, [r4, #28]
c0d03316:	4620      	mov	r0, r4
c0d03318:	3018      	adds	r0, #24
c0d0331a:	f001 fc41 	bl	c0d04ba0 <os_ux>
c0d0331e:	61e0      	str	r0, [r4, #28]
c0d03320:	f001 fa20 	bl	c0d04764 <ux_check_status_default>
c0d03324:	f000 fd58 	bl	c0d03dd8 <io_seproxyhal_init_ux>
c0d03328:	f000 fd5c 	bl	c0d03de4 <io_seproxyhal_init_button>
c0d0332c:	60a5      	str	r5, [r4, #8]
c0d0332e:	6820      	ldr	r0, [r4, #0]
c0d03330:	2800      	cmp	r0, #0
c0d03332:	d026      	beq.n	c0d03382 <ui_export_viewkey_display+0x8e>
c0d03334:	69e0      	ldr	r0, [r4, #28]
c0d03336:	4914      	ldr	r1, [pc, #80]	; (c0d03388 <ui_export_viewkey_display+0x94>)
c0d03338:	4288      	cmp	r0, r1
c0d0333a:	d022      	beq.n	c0d03382 <ui_export_viewkey_display+0x8e>
c0d0333c:	2800      	cmp	r0, #0
c0d0333e:	d020      	beq.n	c0d03382 <ui_export_viewkey_display+0x8e>
c0d03340:	2000      	movs	r0, #0
c0d03342:	6861      	ldr	r1, [r4, #4]
c0d03344:	4288      	cmp	r0, r1
c0d03346:	d21c      	bcs.n	c0d03382 <ui_export_viewkey_display+0x8e>
c0d03348:	f001 fc84 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d0334c:	2800      	cmp	r0, #0
c0d0334e:	d118      	bne.n	c0d03382 <ui_export_viewkey_display+0x8e>
c0d03350:	68a0      	ldr	r0, [r4, #8]
c0d03352:	68e1      	ldr	r1, [r4, #12]
c0d03354:	2538      	movs	r5, #56	; 0x38
c0d03356:	4368      	muls	r0, r5
c0d03358:	6822      	ldr	r2, [r4, #0]
c0d0335a:	1810      	adds	r0, r2, r0
c0d0335c:	2900      	cmp	r1, #0
c0d0335e:	d002      	beq.n	c0d03366 <ui_export_viewkey_display+0x72>
c0d03360:	4788      	blx	r1
c0d03362:	2800      	cmp	r0, #0
c0d03364:	d007      	beq.n	c0d03376 <ui_export_viewkey_display+0x82>
c0d03366:	2801      	cmp	r0, #1
c0d03368:	d103      	bne.n	c0d03372 <ui_export_viewkey_display+0x7e>
c0d0336a:	68a0      	ldr	r0, [r4, #8]
c0d0336c:	4345      	muls	r5, r0
c0d0336e:	6820      	ldr	r0, [r4, #0]
c0d03370:	1940      	adds	r0, r0, r5
 // setup the first screen changing
  UX_CALLBACK_SET_INTERVAL(1000);
}

void io_seproxyhal_display(const bagl_element_t *element) {
  io_seproxyhal_display_default((bagl_element_t *)element);
c0d03372:	f000 fe7b 	bl	c0d0406c <io_seproxyhal_display_default>
    NULL, NULL, NULL },

};

void ui_export_viewkey_display(unsigned int value) {
 UX_DISPLAY(ui_export_viewkey, (void*)ui_export_viewkey_prepro);
c0d03376:	68a0      	ldr	r0, [r4, #8]
c0d03378:	1c40      	adds	r0, r0, #1
c0d0337a:	60a0      	str	r0, [r4, #8]
c0d0337c:	6821      	ldr	r1, [r4, #0]
c0d0337e:	2900      	cmp	r1, #0
c0d03380:	d1df      	bne.n	c0d03342 <ui_export_viewkey_display+0x4e>
}
c0d03382:	bdb0      	pop	{r4, r5, r7, pc}
c0d03384:	20001880 	.word	0x20001880
c0d03388:	b0105044 	.word	0xb0105044
c0d0338c:	0000402c 	.word	0x0000402c
c0d03390:	00000091 	.word	0x00000091
c0d03394:	000000f9 	.word	0x000000f9

c0d03398 <ui_export_viewkey_button>:
  }
  snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "Please Cancel");
  return 1;
}

unsigned int ui_export_viewkey_button(unsigned int button_mask, unsigned int button_mask_counter) {
c0d03398:	b5b0      	push	{r4, r5, r7, lr}
c0d0339a:	b088      	sub	sp, #32
c0d0339c:	4604      	mov	r4, r0
c0d0339e:	2500      	movs	r5, #0
  unsigned int sw;
  unsigned char x[32];

  monero_io_discard(0);
c0d033a0:	4628      	mov	r0, r5
c0d033a2:	f7fe f867 	bl	c0d01474 <monero_io_discard>
c0d033a6:	4668      	mov	r0, sp
c0d033a8:	2220      	movs	r2, #32
  os_memset(x,0,32);
c0d033aa:	4629      	mov	r1, r5
c0d033ac:	f000 fae6 	bl	c0d0397c <os_memset>
c0d033b0:	480f      	ldr	r0, [pc, #60]	; (c0d033f0 <ui_export_viewkey_button+0x58>)
  sw = 0x9000;

  switch(button_mask) {
c0d033b2:	4284      	cmp	r4, r0
c0d033b4:	d004      	beq.n	c0d033c0 <ui_export_viewkey_button+0x28>
c0d033b6:	480f      	ldr	r0, [pc, #60]	; (c0d033f4 <ui_export_viewkey_button+0x5c>)
c0d033b8:	4284      	cmp	r4, r0
c0d033ba:	d116      	bne.n	c0d033ea <ui_export_viewkey_button+0x52>
c0d033bc:	4668      	mov	r0, sp
c0d033be:	e003      	b.n	c0d033c8 <ui_export_viewkey_button+0x30>
c0d033c0:	2051      	movs	r0, #81	; 0x51
c0d033c2:	0080      	lsls	r0, r0, #2
  case BUTTON_EVT_RELEASED|BUTTON_LEFT: // CANCEL
    monero_io_insert(x, 32);
    break;

  case BUTTON_EVT_RELEASED|BUTTON_RIGHT:  // OK
    monero_io_insert(G_monero_vstate.a, 32);
c0d033c4:	490c      	ldr	r1, [pc, #48]	; (c0d033f8 <ui_export_viewkey_button+0x60>)
c0d033c6:	1808      	adds	r0, r1, r0
c0d033c8:	2120      	movs	r1, #32
c0d033ca:	f7fe f87f 	bl	c0d014cc <monero_io_insert>
c0d033ce:	2009      	movs	r0, #9
c0d033d0:	0300      	lsls	r0, r0, #12
    break;

  default:
    return 0;
  }
  monero_io_insert_u16(sw);
c0d033d2:	f7fe f8bf 	bl	c0d01554 <monero_io_insert_u16>
c0d033d6:	2020      	movs	r0, #32
  monero_io_do(IO_RETURN_AFTER_TX);
c0d033d8:	f7fe f978 	bl	c0d016cc <monero_io_do>
c0d033dc:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d033de:	4907      	ldr	r1, [pc, #28]	; (c0d033fc <ui_export_viewkey_button+0x64>)
c0d033e0:	4479      	add	r1, pc
c0d033e2:	4a07      	ldr	r2, [pc, #28]	; (c0d03400 <ui_export_viewkey_button+0x68>)
c0d033e4:	447a      	add	r2, pc
c0d033e6:	f001 f92f 	bl	c0d04648 <ux_menu_display>
c0d033ea:	2000      	movs	r0, #0
  }
  monero_io_insert_u16(sw);
  monero_io_do(IO_RETURN_AFTER_TX);
  ui_menu_main_display(0);
  return 0;
}
c0d033ec:	b008      	add	sp, #32
c0d033ee:	bdb0      	pop	{r4, r5, r7, pc}
c0d033f0:	80000002 	.word	0x80000002
c0d033f4:	80000001 	.word	0x80000001
c0d033f8:	20001930 	.word	0x20001930
c0d033fc:	0000438c 	.word	0x0000438c
c0d03400:	0000032d 	.word	0x0000032d

c0d03404 <ui_export_viewkey_prepro>:

void ui_export_viewkey_display(unsigned int value) {
 UX_DISPLAY(ui_export_viewkey, (void*)ui_export_viewkey_prepro);
}

unsigned int ui_export_viewkey_prepro(const  bagl_element_t* element) {
c0d03404:	b510      	push	{r4, lr}
  if (element->component.userid == 1) {
c0d03406:	7840      	ldrb	r0, [r0, #1]
c0d03408:	2802      	cmp	r0, #2
c0d0340a:	d00b      	beq.n	c0d03424 <ui_export_viewkey_prepro+0x20>
c0d0340c:	2801      	cmp	r0, #1
c0d0340e:	d114      	bne.n	c0d0343a <ui_export_viewkey_prepro+0x36>
c0d03410:	20db      	movs	r0, #219	; 0xdb
c0d03412:	00c0      	lsls	r0, r0, #3
    snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "Export");
c0d03414:	490f      	ldr	r1, [pc, #60]	; (c0d03454 <ui_export_viewkey_prepro+0x50>)
c0d03416:	1808      	adds	r0, r1, r0
c0d03418:	490f      	ldr	r1, [pc, #60]	; (c0d03458 <ui_export_viewkey_prepro+0x54>)
c0d0341a:	4479      	add	r1, pc
c0d0341c:	2207      	movs	r2, #7
c0d0341e:	f003 f8ff 	bl	c0d06620 <__aeabi_memcpy>
c0d03422:	e014      	b.n	c0d0344e <ui_export_viewkey_prepro+0x4a>
c0d03424:	20db      	movs	r0, #219	; 0xdb
c0d03426:	00c0      	lsls	r0, r0, #3
    return 1;
  }
  if (element->component.userid == 2) {
    snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "View Key");
c0d03428:	490a      	ldr	r1, [pc, #40]	; (c0d03454 <ui_export_viewkey_prepro+0x50>)
c0d0342a:	1808      	adds	r0, r1, r0
c0d0342c:	490b      	ldr	r1, [pc, #44]	; (c0d0345c <ui_export_viewkey_prepro+0x58>)
c0d0342e:	4479      	add	r1, pc
c0d03430:	c90c      	ldmia	r1!, {r2, r3}
c0d03432:	c00c      	stmia	r0!, {r2, r3}
c0d03434:	7809      	ldrb	r1, [r1, #0]
c0d03436:	7001      	strb	r1, [r0, #0]
c0d03438:	e009      	b.n	c0d0344e <ui_export_viewkey_prepro+0x4a>
c0d0343a:	20db      	movs	r0, #219	; 0xdb
c0d0343c:	00c0      	lsls	r0, r0, #3
    return 1;
  }
  snprintf(G_monero_vstate.ux_menu, sizeof(G_monero_vstate.ux_menu), "Please Cancel");
c0d0343e:	4905      	ldr	r1, [pc, #20]	; (c0d03454 <ui_export_viewkey_prepro+0x50>)
c0d03440:	1808      	adds	r0, r1, r0
c0d03442:	4907      	ldr	r1, [pc, #28]	; (c0d03460 <ui_export_viewkey_prepro+0x5c>)
c0d03444:	4479      	add	r1, pc
c0d03446:	c91c      	ldmia	r1!, {r2, r3, r4}
c0d03448:	c01c      	stmia	r0!, {r2, r3, r4}
c0d0344a:	8809      	ldrh	r1, [r1, #0]
c0d0344c:	8001      	strh	r1, [r0, #0]
c0d0344e:	2001      	movs	r0, #1
  return 1;
}
c0d03450:	bd10      	pop	{r4, pc}
c0d03452:	46c0      	nop			; (mov r8, r8)
c0d03454:	20001930 	.word	0x20001930
c0d03458:	00003ac9 	.word	0x00003ac9
c0d0345c:	00004012 	.word	0x00004012
c0d03460:	00004008 	.word	0x00004008

c0d03464 <io_seproxyhal_display>:
 ui_menu_main_display(0);
 // setup the first screen changing
  UX_CALLBACK_SET_INTERVAL(1000);
}

void io_seproxyhal_display(const bagl_element_t *element) {
c0d03464:	b580      	push	{r7, lr}
  io_seproxyhal_display_default((bagl_element_t *)element);
c0d03466:	f000 fe01 	bl	c0d0406c <io_seproxyhal_display_default>
}
c0d0346a:	bd80      	pop	{r7, pc}

c0d0346c <ui_menu_network_action>:
    element->text = G_monero_vstate.ux_menu;
  }
  return element;
}

void ui_menu_network_action(unsigned int value) {
c0d0346c:	b580      	push	{r7, lr}
  monero_install(value);
c0d0346e:	b2c0      	uxtb	r0, r0
c0d03470:	f7fd ff3c 	bl	c0d012ec <monero_install>
  monero_init();
c0d03474:	f7fd ff16 	bl	c0d012a4 <monero_init>
c0d03478:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d0347a:	4903      	ldr	r1, [pc, #12]	; (c0d03488 <ui_menu_network_action+0x1c>)
c0d0347c:	4479      	add	r1, pc
c0d0347e:	4a03      	ldr	r2, [pc, #12]	; (c0d0348c <ui_menu_network_action+0x20>)
c0d03480:	447a      	add	r2, pc
c0d03482:	f001 f8e1 	bl	c0d04648 <ux_menu_display>

void ui_menu_network_action(unsigned int value) {
  monero_install(value);
  monero_init();
  ui_menu_main_display(0);
}
c0d03486:	bd80      	pop	{r7, pc}
c0d03488:	000042f0 	.word	0x000042f0
c0d0348c:	00000291 	.word	0x00000291

c0d03490 <ui_menu_network_preprocessor>:
  {NULL,   ui_menu_network_action, STAGENET, NULL, "Stage Network", NULL,          0, 0},
  {NULL,   ui_menu_network_action, MAINNET,  NULL, "Main Network",  NULL,          0, 0},
  UX_MENU_END
};

const bagl_element_t* ui_menu_network_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03490:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03492:	b081      	sub	sp, #4
c0d03494:	460c      	mov	r4, r1
c0d03496:	4606      	mov	r6, r0
c0d03498:	20db      	movs	r0, #219	; 0xdb
c0d0349a:	00c0      	lsls	r0, r0, #3
  os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu));
c0d0349c:	4f20      	ldr	r7, [pc, #128]	; (c0d03520 <ui_menu_network_preprocessor+0x90>)
c0d0349e:	183d      	adds	r5, r7, r0
c0d034a0:	2100      	movs	r1, #0
c0d034a2:	2270      	movs	r2, #112	; 0x70
c0d034a4:	4628      	mov	r0, r5
c0d034a6:	f000 fa69 	bl	c0d0397c <os_memset>
  if ((entry == &ui_menu_network[2]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == TESTNET)) {
c0d034aa:	4820      	ldr	r0, [pc, #128]	; (c0d0352c <ui_menu_network_preprocessor+0x9c>)
c0d034ac:	4478      	add	r0, pc
c0d034ae:	4601      	mov	r1, r0
c0d034b0:	3138      	adds	r1, #56	; 0x38
c0d034b2:	428e      	cmp	r6, r1
c0d034b4:	d012      	beq.n	c0d034dc <ui_menu_network_preprocessor+0x4c>
    os_memmove(G_monero_vstate.ux_menu, "Test Network  ", 14);
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  if ((entry == &ui_menu_network[3]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == STAGENET)) {
c0d034b6:	4601      	mov	r1, r0
c0d034b8:	3154      	adds	r1, #84	; 0x54
c0d034ba:	428e      	cmp	r6, r1
c0d034bc:	d01a      	beq.n	c0d034f4 <ui_menu_network_preprocessor+0x64>
    os_memmove(G_monero_vstate.ux_menu, "Stage Network ", 14);
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  if ((entry == &ui_menu_network[4]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == MAINNET)) {
c0d034be:	3070      	adds	r0, #112	; 0x70
c0d034c0:	4286      	cmp	r6, r0
c0d034c2:	d12a      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
c0d034c4:	7860      	ldrb	r0, [r4, #1]
c0d034c6:	2820      	cmp	r0, #32
c0d034c8:	d127      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
c0d034ca:	4816      	ldr	r0, [pc, #88]	; (c0d03524 <ui_menu_network_preprocessor+0x94>)
c0d034cc:	f001 f94c 	bl	c0d04768 <pic>
c0d034d0:	7a00      	ldrb	r0, [r0, #8]
c0d034d2:	2800      	cmp	r0, #0
c0d034d4:	d121      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
    os_memmove(G_monero_vstate.ux_menu, "Main Network  ", 14);
c0d034d6:	4918      	ldr	r1, [pc, #96]	; (c0d03538 <ui_menu_network_preprocessor+0xa8>)
c0d034d8:	4479      	add	r1, pc
c0d034da:	e016      	b.n	c0d0350a <ui_menu_network_preprocessor+0x7a>
  UX_MENU_END
};

const bagl_element_t* ui_menu_network_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
  os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu));
  if ((entry == &ui_menu_network[2]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == TESTNET)) {
c0d034dc:	7860      	ldrb	r0, [r4, #1]
c0d034de:	2820      	cmp	r0, #32
c0d034e0:	d11b      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
c0d034e2:	4810      	ldr	r0, [pc, #64]	; (c0d03524 <ui_menu_network_preprocessor+0x94>)
c0d034e4:	f001 f940 	bl	c0d04768 <pic>
c0d034e8:	7a00      	ldrb	r0, [r0, #8]
c0d034ea:	2801      	cmp	r0, #1
c0d034ec:	d115      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
    os_memmove(G_monero_vstate.ux_menu, "Test Network  ", 14);
c0d034ee:	4910      	ldr	r1, [pc, #64]	; (c0d03530 <ui_menu_network_preprocessor+0xa0>)
c0d034f0:	4479      	add	r1, pc
c0d034f2:	e00a      	b.n	c0d0350a <ui_menu_network_preprocessor+0x7a>
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  if ((entry == &ui_menu_network[3]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == STAGENET)) {
c0d034f4:	7860      	ldrb	r0, [r4, #1]
c0d034f6:	2820      	cmp	r0, #32
c0d034f8:	d10f      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
c0d034fa:	480a      	ldr	r0, [pc, #40]	; (c0d03524 <ui_menu_network_preprocessor+0x94>)
c0d034fc:	f001 f934 	bl	c0d04768 <pic>
c0d03500:	7a00      	ldrb	r0, [r0, #8]
c0d03502:	2802      	cmp	r0, #2
c0d03504:	d109      	bne.n	c0d0351a <ui_menu_network_preprocessor+0x8a>
    os_memmove(G_monero_vstate.ux_menu, "Stage Network ", 14);
c0d03506:	490b      	ldr	r1, [pc, #44]	; (c0d03534 <ui_menu_network_preprocessor+0xa4>)
c0d03508:	4479      	add	r1, pc
c0d0350a:	220e      	movs	r2, #14
c0d0350c:	4628      	mov	r0, r5
c0d0350e:	f000 fa3e 	bl	c0d0398e <os_memmove>
c0d03512:	4805      	ldr	r0, [pc, #20]	; (c0d03528 <ui_menu_network_preprocessor+0x98>)
c0d03514:	212b      	movs	r1, #43	; 0x2b
c0d03516:	5439      	strb	r1, [r7, r0]
c0d03518:	61e5      	str	r5, [r4, #28]
  if ((entry == &ui_menu_network[4]) && (element->component.userid==0x20) && (N_monero_pstate->network_id == MAINNET)) {
    os_memmove(G_monero_vstate.ux_menu, "Main Network  ", 14);
    G_monero_vstate.ux_menu[13] = '+';
    element->text = G_monero_vstate.ux_menu;
  }
  return element;
c0d0351a:	4620      	mov	r0, r4
c0d0351c:	b001      	add	sp, #4
c0d0351e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03520:	20001930 	.word	0x20001930
c0d03524:	c0d07c00 	.word	0xc0d07c00
c0d03528:	000006e5 	.word	0x000006e5
c0d0352c:	00003fb0 	.word	0x00003fb0
c0d03530:	00003a48 	.word	0x00003a48
c0d03534:	00003a3f 	.word	0x00003a3f
c0d03538:	00003a7e 	.word	0x00003a7e

c0d0353c <ui_menu_network_display>:
  monero_install(value);
  monero_init();
  ui_menu_main_display(0);
}

void ui_menu_network_display(unsigned int value) {
c0d0353c:	b580      	push	{r7, lr}
   UX_MENU_DISPLAY(value, ui_menu_network, ui_menu_network_preprocessor);
c0d0353e:	4903      	ldr	r1, [pc, #12]	; (c0d0354c <ui_menu_network_display+0x10>)
c0d03540:	4479      	add	r1, pc
c0d03542:	4a03      	ldr	r2, [pc, #12]	; (c0d03550 <ui_menu_network_display+0x14>)
c0d03544:	447a      	add	r2, pc
c0d03546:	f001 f87f 	bl	c0d04648 <ux_menu_display>
}
c0d0354a:	bd80      	pop	{r7, pc}
c0d0354c:	00003f1c 	.word	0x00003f1c
c0d03550:	ffffff49 	.word	0xffffff49

c0d03554 <ui_menu_reset_action>:
  {NULL,   ui_menu_main_display, 0, &C_badge_back, "No",         NULL, 61, 40},
  {NULL,   ui_menu_reset_action, 0, NULL,          "Yes",           NULL, 0, 0},
  UX_MENU_END
};

void ui_menu_reset_action(unsigned int value) {
c0d03554:	b510      	push	{r4, lr}
c0d03556:	b082      	sub	sp, #8
c0d03558:	2400      	movs	r4, #0
  unsigned char magic[4];
  magic[0] = 0; magic[1] = 0; magic[2] = 0; magic[3] = 0;
c0d0355a:	9401      	str	r4, [sp, #4]
  monero_nvm_write(N_monero_pstate->magic, magic, 4);
c0d0355c:	4808      	ldr	r0, [pc, #32]	; (c0d03580 <ui_menu_reset_action+0x2c>)
c0d0355e:	f001 f903 	bl	c0d04768 <pic>
c0d03562:	a901      	add	r1, sp, #4
c0d03564:	2204      	movs	r2, #4
c0d03566:	f001 f941 	bl	c0d047ec <nvm_write>
  monero_init();
c0d0356a:	f7fd fe9b 	bl	c0d012a4 <monero_init>
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d0356e:	4905      	ldr	r1, [pc, #20]	; (c0d03584 <ui_menu_reset_action+0x30>)
c0d03570:	4479      	add	r1, pc
c0d03572:	4a05      	ldr	r2, [pc, #20]	; (c0d03588 <ui_menu_reset_action+0x34>)
c0d03574:	447a      	add	r2, pc
c0d03576:	4620      	mov	r0, r4
c0d03578:	f001 f866 	bl	c0d04648 <ux_menu_display>
  unsigned char magic[4];
  magic[0] = 0; magic[1] = 0; magic[2] = 0; magic[3] = 0;
  monero_nvm_write(N_monero_pstate->magic, magic, 4);
  monero_init();
  ui_menu_main_display(0);
}
c0d0357c:	b002      	add	sp, #8
c0d0357e:	bd10      	pop	{r4, pc}
c0d03580:	c0d07c00 	.word	0xc0d07c00
c0d03584:	000041fc 	.word	0x000041fc
c0d03588:	0000019d 	.word	0x0000019d

c0d0358c <ui_menu_pubaddr_preprocessor>:
  {NULL,  NULL,                  7,          NULL,  "?addr.5?",     "?addr.5?",   0, 0},
  {NULL,  ui_menu_main_display,  0, &C_badge_back, "Back",                     NULL, 61, 40},
  UX_MENU_END
};

const bagl_element_t* ui_menu_pubaddr_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d0358c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0358e:	b081      	sub	sp, #4
c0d03590:	460c      	mov	r4, r1

   /* --- address --- */
  if (entry == &ui_menu_pubaddr[0]) {
c0d03592:	4950      	ldr	r1, [pc, #320]	; (c0d036d4 <ui_menu_pubaddr_preprocessor+0x148>)
c0d03594:	4479      	add	r1, pc
c0d03596:	4288      	cmp	r0, r1
c0d03598:	d028      	beq.n	c0d035ec <ui_menu_pubaddr_preprocessor+0x60>
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
      element->text = G_monero_vstate.ux_menu;
    }
  }
  if (entry == &ui_menu_pubaddr[1]) {
c0d0359a:	460a      	mov	r2, r1
c0d0359c:	321c      	adds	r2, #28
c0d0359e:	4290      	cmp	r0, r2
c0d035a0:	d039      	beq.n	c0d03616 <ui_menu_pubaddr_preprocessor+0x8a>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[2]) {
c0d035a2:	460a      	mov	r2, r1
c0d035a4:	3238      	adds	r2, #56	; 0x38
c0d035a6:	4290      	cmp	r0, r2
c0d035a8:	d04c      	beq.n	c0d03644 <ui_menu_pubaddr_preprocessor+0xb8>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[3]) {
c0d035aa:	460a      	mov	r2, r1
c0d035ac:	3254      	adds	r2, #84	; 0x54
c0d035ae:	4290      	cmp	r0, r2
c0d035b0:	d05f      	beq.n	c0d03672 <ui_menu_pubaddr_preprocessor+0xe6>
    if(element->component.userid==0x22) {
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*6, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[4]) {
c0d035b2:	3170      	adds	r1, #112	; 0x70
c0d035b4:	4288      	cmp	r0, r1
c0d035b6:	d179      	bne.n	c0d036ac <ui_menu_pubaddr_preprocessor+0x120>
c0d035b8:	20db      	movs	r0, #219	; 0xdb
c0d035ba:	00c6      	lsls	r6, r0, #3
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d035bc:	4f3d      	ldr	r7, [pc, #244]	; (c0d036b4 <ui_menu_pubaddr_preprocessor+0x128>)
c0d035be:	19bd      	adds	r5, r7, r6
c0d035c0:	2100      	movs	r1, #0
c0d035c2:	2270      	movs	r2, #112	; 0x70
c0d035c4:	4628      	mov	r0, r5
c0d035c6:	f000 f9d9 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d035ca:	7860      	ldrb	r0, [r4, #1]
c0d035cc:	2821      	cmp	r0, #33	; 0x21
c0d035ce:	d106      	bne.n	c0d035de <ui_menu_pubaddr_preprocessor+0x52>
c0d035d0:	4839      	ldr	r0, [pc, #228]	; (c0d036b8 <ui_menu_pubaddr_preprocessor+0x12c>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*7, 11);
c0d035d2:	1839      	adds	r1, r7, r0
c0d035d4:	220b      	movs	r2, #11
c0d035d6:	4628      	mov	r0, r5
c0d035d8:	f000 f9d9 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d035dc:	7860      	ldrb	r0, [r4, #1]
c0d035de:	2822      	cmp	r0, #34	; 0x22
c0d035e0:	d162      	bne.n	c0d036a8 <ui_menu_pubaddr_preprocessor+0x11c>
c0d035e2:	203d      	movs	r0, #61	; 0x3d
c0d035e4:	0140      	lsls	r0, r0, #5
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
c0d035e6:	1839      	adds	r1, r7, r0
c0d035e8:	2207      	movs	r2, #7
c0d035ea:	e05a      	b.n	c0d036a2 <ui_menu_pubaddr_preprocessor+0x116>

const bagl_element_t* ui_menu_pubaddr_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {

   /* --- address --- */
  if (entry == &ui_menu_pubaddr[0]) {
    if(element->component.userid==0x22) {
c0d035ec:	7860      	ldrb	r0, [r4, #1]
c0d035ee:	2822      	cmp	r0, #34	; 0x22
c0d035f0:	d15c      	bne.n	c0d036ac <ui_menu_pubaddr_preprocessor+0x120>
c0d035f2:	20db      	movs	r0, #219	; 0xdb
c0d035f4:	00c0      	lsls	r0, r0, #3
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d035f6:	4e2f      	ldr	r6, [pc, #188]	; (c0d036b4 <ui_menu_pubaddr_preprocessor+0x128>)
c0d035f8:	1835      	adds	r5, r6, r0
c0d035fa:	2100      	movs	r1, #0
c0d035fc:	2270      	movs	r2, #112	; 0x70
c0d035fe:	4628      	mov	r0, r5
c0d03600:	f000 f9bc 	bl	c0d0397c <os_memset>
c0d03604:	20e9      	movs	r0, #233	; 0xe9
c0d03606:	00c0      	lsls	r0, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*0, 11);
c0d03608:	1831      	adds	r1, r6, r0
c0d0360a:	220b      	movs	r2, #11
c0d0360c:	4628      	mov	r0, r5
c0d0360e:	f000 f9be 	bl	c0d0398e <os_memmove>
      element->text = G_monero_vstate.ux_menu;
c0d03612:	61e5      	str	r5, [r4, #28]
c0d03614:	e04a      	b.n	c0d036ac <ui_menu_pubaddr_preprocessor+0x120>
c0d03616:	20db      	movs	r0, #219	; 0xdb
c0d03618:	00c6      	lsls	r6, r0, #3
    }
  }
  if (entry == &ui_menu_pubaddr[1]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d0361a:	4f26      	ldr	r7, [pc, #152]	; (c0d036b4 <ui_menu_pubaddr_preprocessor+0x128>)
c0d0361c:	19bd      	adds	r5, r7, r6
c0d0361e:	2100      	movs	r1, #0
c0d03620:	2270      	movs	r2, #112	; 0x70
c0d03622:	4628      	mov	r0, r5
c0d03624:	f000 f9aa 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d03628:	7860      	ldrb	r0, [r4, #1]
c0d0362a:	2821      	cmp	r0, #33	; 0x21
c0d0362c:	d106      	bne.n	c0d0363c <ui_menu_pubaddr_preprocessor+0xb0>
c0d0362e:	4827      	ldr	r0, [pc, #156]	; (c0d036cc <ui_menu_pubaddr_preprocessor+0x140>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*1, 11);
c0d03630:	1839      	adds	r1, r7, r0
c0d03632:	220b      	movs	r2, #11
c0d03634:	4628      	mov	r0, r5
c0d03636:	f000 f9aa 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d0363a:	7860      	ldrb	r0, [r4, #1]
c0d0363c:	2822      	cmp	r0, #34	; 0x22
c0d0363e:	d133      	bne.n	c0d036a8 <ui_menu_pubaddr_preprocessor+0x11c>
c0d03640:	4823      	ldr	r0, [pc, #140]	; (c0d036d0 <ui_menu_pubaddr_preprocessor+0x144>)
c0d03642:	e02c      	b.n	c0d0369e <ui_menu_pubaddr_preprocessor+0x112>
c0d03644:	20db      	movs	r0, #219	; 0xdb
c0d03646:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*2, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[2]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d03648:	4f1a      	ldr	r7, [pc, #104]	; (c0d036b4 <ui_menu_pubaddr_preprocessor+0x128>)
c0d0364a:	19bd      	adds	r5, r7, r6
c0d0364c:	2100      	movs	r1, #0
c0d0364e:	2270      	movs	r2, #112	; 0x70
c0d03650:	4628      	mov	r0, r5
c0d03652:	f000 f993 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d03656:	7860      	ldrb	r0, [r4, #1]
c0d03658:	2821      	cmp	r0, #33	; 0x21
c0d0365a:	d106      	bne.n	c0d0366a <ui_menu_pubaddr_preprocessor+0xde>
c0d0365c:	4819      	ldr	r0, [pc, #100]	; (c0d036c4 <ui_menu_pubaddr_preprocessor+0x138>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*3, 11);
c0d0365e:	1839      	adds	r1, r7, r0
c0d03660:	220b      	movs	r2, #11
c0d03662:	4628      	mov	r0, r5
c0d03664:	f000 f993 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d03668:	7860      	ldrb	r0, [r4, #1]
c0d0366a:	2822      	cmp	r0, #34	; 0x22
c0d0366c:	d11c      	bne.n	c0d036a8 <ui_menu_pubaddr_preprocessor+0x11c>
c0d0366e:	4816      	ldr	r0, [pc, #88]	; (c0d036c8 <ui_menu_pubaddr_preprocessor+0x13c>)
c0d03670:	e015      	b.n	c0d0369e <ui_menu_pubaddr_preprocessor+0x112>
c0d03672:	20db      	movs	r0, #219	; 0xdb
c0d03674:	00c6      	lsls	r6, r0, #3
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*4, 11);
    }
    element->text = G_monero_vstate.ux_menu;
  }
  if (entry == &ui_menu_pubaddr[3]) {
    os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu)) ;
c0d03676:	4f0f      	ldr	r7, [pc, #60]	; (c0d036b4 <ui_menu_pubaddr_preprocessor+0x128>)
c0d03678:	19bd      	adds	r5, r7, r6
c0d0367a:	2100      	movs	r1, #0
c0d0367c:	2270      	movs	r2, #112	; 0x70
c0d0367e:	4628      	mov	r0, r5
c0d03680:	f000 f97c 	bl	c0d0397c <os_memset>
    if(element->component.userid==0x21) {
c0d03684:	7860      	ldrb	r0, [r4, #1]
c0d03686:	2821      	cmp	r0, #33	; 0x21
c0d03688:	d106      	bne.n	c0d03698 <ui_menu_pubaddr_preprocessor+0x10c>
c0d0368a:	480c      	ldr	r0, [pc, #48]	; (c0d036bc <ui_menu_pubaddr_preprocessor+0x130>)
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*5, 11);
c0d0368c:	1839      	adds	r1, r7, r0
c0d0368e:	220b      	movs	r2, #11
c0d03690:	4628      	mov	r0, r5
c0d03692:	f000 f97c 	bl	c0d0398e <os_memmove>
    }
    if(element->component.userid==0x22) {
c0d03696:	7860      	ldrb	r0, [r4, #1]
c0d03698:	2822      	cmp	r0, #34	; 0x22
c0d0369a:	d105      	bne.n	c0d036a8 <ui_menu_pubaddr_preprocessor+0x11c>
c0d0369c:	4808      	ldr	r0, [pc, #32]	; (c0d036c0 <ui_menu_pubaddr_preprocessor+0x134>)
c0d0369e:	1839      	adds	r1, r7, r0
c0d036a0:	220b      	movs	r2, #11
c0d036a2:	4628      	mov	r0, r5
c0d036a4:	f000 f973 	bl	c0d0398e <os_memmove>
c0d036a8:	19b8      	adds	r0, r7, r6
c0d036aa:	61e0      	str	r0, [r4, #28]
      os_memmove(G_monero_vstate.ux_menu, G_monero_vstate.ux_address+11*8, 7);
    }
    element->text = G_monero_vstate.ux_menu;
  }

  return element;
c0d036ac:	4620      	mov	r0, r4
c0d036ae:	b001      	add	sp, #4
c0d036b0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d036b2:	46c0      	nop			; (mov r8, r8)
c0d036b4:	20001930 	.word	0x20001930
c0d036b8:	00000795 	.word	0x00000795
c0d036bc:	0000077f 	.word	0x0000077f
c0d036c0:	0000078a 	.word	0x0000078a
c0d036c4:	00000769 	.word	0x00000769
c0d036c8:	00000774 	.word	0x00000774
c0d036cc:	00000753 	.word	0x00000753
c0d036d0:	0000075e 	.word	0x0000075e
c0d036d4:	00004114 	.word	0x00004114

c0d036d8 <ui_menu_pubaddr_display>:
}

void ui_menu_pubaddr_display(unsigned int value) {
c0d036d8:	b510      	push	{r4, lr}
c0d036da:	4604      	mov	r4, r0
c0d036dc:	20e9      	movs	r0, #233	; 0xe9
c0d036de:	00c0      	lsls	r0, r0, #3
   monero_base58_public_key(G_monero_vstate.ux_address, G_monero_vstate.A,G_monero_vstate.B, 0);
c0d036e0:	4a09      	ldr	r2, [pc, #36]	; (c0d03708 <ui_menu_pubaddr_display+0x30>)
c0d036e2:	1810      	adds	r0, r2, r0
c0d036e4:	2159      	movs	r1, #89	; 0x59
c0d036e6:	0089      	lsls	r1, r1, #2
c0d036e8:	1851      	adds	r1, r2, r1
c0d036ea:	2369      	movs	r3, #105	; 0x69
c0d036ec:	009b      	lsls	r3, r3, #2
c0d036ee:	18d2      	adds	r2, r2, r3
c0d036f0:	2300      	movs	r3, #0
c0d036f2:	f7ff f8eb 	bl	c0d028cc <monero_base58_public_key>
   UX_MENU_DISPLAY(value, ui_menu_pubaddr, ui_menu_pubaddr_preprocessor);
c0d036f6:	4905      	ldr	r1, [pc, #20]	; (c0d0370c <ui_menu_pubaddr_display+0x34>)
c0d036f8:	4479      	add	r1, pc
c0d036fa:	4a05      	ldr	r2, [pc, #20]	; (c0d03710 <ui_menu_pubaddr_display+0x38>)
c0d036fc:	447a      	add	r2, pc
c0d036fe:	4620      	mov	r0, r4
c0d03700:	f000 ffa2 	bl	c0d04648 <ux_menu_display>
}
c0d03704:	bd10      	pop	{r4, pc}
c0d03706:	46c0      	nop			; (mov r8, r8)
c0d03708:	20001930 	.word	0x20001930
c0d0370c:	00003fb0 	.word	0x00003fb0
c0d03710:	fffffe8d 	.word	0xfffffe8d

c0d03714 <ui_menu_main_preprocessor>:
  {ui_menu_info,               NULL,  0, NULL,              "About",       NULL, 0, 0},
  {NULL,              os_sched_exit,  0, &C_icon_dashboard, "Quit app" ,   NULL, 50, 29},
  UX_MENU_END
};

const bagl_element_t* ui_menu_main_preprocessor(const ux_menu_entry_t* entry, bagl_element_t* element) {
c0d03714:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03716:	b081      	sub	sp, #4
c0d03718:	460c      	mov	r4, r1
  if (entry == &ui_menu_main[0]) {
c0d0371a:	491c      	ldr	r1, [pc, #112]	; (c0d0378c <ui_menu_main_preprocessor+0x78>)
c0d0371c:	4479      	add	r1, pc
c0d0371e:	4288      	cmp	r0, r1
c0d03720:	d126      	bne.n	c0d03770 <ui_menu_main_preprocessor+0x5c>
    if(element->component.userid==0x22) {
c0d03722:	7860      	ldrb	r0, [r4, #1]
c0d03724:	2822      	cmp	r0, #34	; 0x22
c0d03726:	d123      	bne.n	c0d03770 <ui_menu_main_preprocessor+0x5c>
c0d03728:	20db      	movs	r0, #219	; 0xdb
c0d0372a:	00c0      	lsls	r0, r0, #3
      os_memset(G_monero_vstate.ux_menu, 0, sizeof(G_monero_vstate.ux_menu));
c0d0372c:	4f12      	ldr	r7, [pc, #72]	; (c0d03778 <ui_menu_main_preprocessor+0x64>)
c0d0372e:	183d      	adds	r5, r7, r0
c0d03730:	2600      	movs	r6, #0
c0d03732:	2270      	movs	r2, #112	; 0x70
c0d03734:	4628      	mov	r0, r5
c0d03736:	4631      	mov	r1, r6
c0d03738:	f000 f920 	bl	c0d0397c <os_memset>
c0d0373c:	2059      	movs	r0, #89	; 0x59
c0d0373e:	0080      	lsls	r0, r0, #2
      monero_base58_public_key(G_monero_vstate.ux_menu, G_monero_vstate.A,G_monero_vstate.B, 0);
c0d03740:	1839      	adds	r1, r7, r0
c0d03742:	2069      	movs	r0, #105	; 0x69
c0d03744:	0080      	lsls	r0, r0, #2
c0d03746:	183a      	adds	r2, r7, r0
c0d03748:	4628      	mov	r0, r5
c0d0374a:	4633      	mov	r3, r6
c0d0374c:	f7ff f8be 	bl	c0d028cc <monero_base58_public_key>
c0d03750:	480a      	ldr	r0, [pc, #40]	; (c0d0377c <ui_menu_main_preprocessor+0x68>)
      os_memset(G_monero_vstate.ux_menu+5,'.',2);
c0d03752:	1838      	adds	r0, r7, r0
c0d03754:	212e      	movs	r1, #46	; 0x2e
c0d03756:	2202      	movs	r2, #2
c0d03758:	f000 f910 	bl	c0d0397c <os_memset>
c0d0375c:	4808      	ldr	r0, [pc, #32]	; (c0d03780 <ui_menu_main_preprocessor+0x6c>)
      os_memmove(G_monero_vstate.ux_menu+7, G_monero_vstate.ux_menu+95-5,5);
c0d0375e:	1838      	adds	r0, r7, r0
c0d03760:	4908      	ldr	r1, [pc, #32]	; (c0d03784 <ui_menu_main_preprocessor+0x70>)
c0d03762:	1879      	adds	r1, r7, r1
c0d03764:	2205      	movs	r2, #5
c0d03766:	f000 f912 	bl	c0d0398e <os_memmove>
c0d0376a:	4807      	ldr	r0, [pc, #28]	; (c0d03788 <ui_menu_main_preprocessor+0x74>)
      G_monero_vstate.ux_menu[12] = 0;
c0d0376c:	543e      	strb	r6, [r7, r0]
      element->text = G_monero_vstate.ux_menu;
c0d0376e:	61e5      	str	r5, [r4, #28]
    }
  }
  return element;
c0d03770:	4620      	mov	r0, r4
c0d03772:	b001      	add	sp, #4
c0d03774:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03776:	46c0      	nop			; (mov r8, r8)
c0d03778:	20001930 	.word	0x20001930
c0d0377c:	000006dd 	.word	0x000006dd
c0d03780:	000006df 	.word	0x000006df
c0d03784:	00000732 	.word	0x00000732
c0d03788:	000006e4 	.word	0x000006e4
c0d0378c:	00004050 	.word	0x00004050

c0d03790 <ui_init>:
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
}

void ui_init(void) {
c0d03790:	b580      	push	{r7, lr}
c0d03792:	2000      	movs	r0, #0
    }
  }
  return element;
}
void ui_menu_main_display(unsigned int value) {
   UX_MENU_DISPLAY(value, ui_menu_main, ui_menu_main_preprocessor);
c0d03794:	4906      	ldr	r1, [pc, #24]	; (c0d037b0 <ui_init+0x20>)
c0d03796:	4479      	add	r1, pc
c0d03798:	4a06      	ldr	r2, [pc, #24]	; (c0d037b4 <ui_init+0x24>)
c0d0379a:	447a      	add	r2, pc
c0d0379c:	f000 ff54 	bl	c0d04648 <ux_menu_display>
c0d037a0:	207d      	movs	r0, #125	; 0x7d
c0d037a2:	00c0      	lsls	r0, r0, #3
}

void ui_init(void) {
 ui_menu_main_display(0);
 // setup the first screen changing
  UX_CALLBACK_SET_INTERVAL(1000);
c0d037a4:	4901      	ldr	r1, [pc, #4]	; (c0d037ac <ui_init+0x1c>)
c0d037a6:	6148      	str	r0, [r1, #20]
}
c0d037a8:	bd80      	pop	{r7, pc}
c0d037aa:	46c0      	nop			; (mov r8, r8)
c0d037ac:	20001880 	.word	0x20001880
c0d037b0:	00003fd6 	.word	0x00003fd6
c0d037b4:	ffffff77 	.word	0xffffff77

c0d037b8 <os_boot>:

// apdu buffer must hold a complete apdu to avoid troubles
unsigned char G_io_apdu_buffer[IO_APDU_BUFFER_SIZE];


void os_boot(void) {
c0d037b8:	2000      	movs	r0, #0
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d037ba:	4681      	mov	r9, r0

void os_boot(void) {
  // TODO patch entry point when romming (f)
  // set the default try context to nothing
  try_context_set(NULL);
}
c0d037bc:	4770      	bx	lr

c0d037be <try_context_set>:
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
}

void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
c0d037be:	4681      	mov	r9, r0
}
c0d037c0:	4770      	bx	lr
	...

c0d037c4 <io_usb_hid_receive>:
volatile unsigned int   G_io_usb_hid_channel;
volatile unsigned int   G_io_usb_hid_remaining_length;
volatile unsigned int   G_io_usb_hid_sequence_number;
volatile unsigned char* G_io_usb_hid_current_buffer;

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
c0d037c4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d037c6:	b081      	sub	sp, #4
c0d037c8:	4606      	mov	r6, r0
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
c0d037ca:	4f65      	ldr	r7, [pc, #404]	; (c0d03960 <io_usb_hid_receive+0x19c>)
c0d037cc:	42b9      	cmp	r1, r7
c0d037ce:	d038      	beq.n	c0d03842 <io_usb_hid_receive+0x7e>
c0d037d0:	460d      	mov	r5, r1
c0d037d2:	4614      	mov	r4, r2
c0d037d4:	9600      	str	r6, [sp, #0]
c0d037d6:	2640      	movs	r6, #64	; 0x40
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d037d8:	4638      	mov	r0, r7
c0d037da:	4631      	mov	r1, r6
c0d037dc:	f002 ff1a 	bl	c0d06614 <__aeabi_memclr>

io_usb_hid_receive_status_t io_usb_hid_receive (io_send_t sndfct, unsigned char* buffer, unsigned short l) {
  // avoid over/under flows
  if (buffer != G_io_usb_ep_buffer) {
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
c0d037e0:	2c40      	cmp	r4, #64	; 0x40
c0d037e2:	4622      	mov	r2, r4
c0d037e4:	d300      	bcc.n	c0d037e8 <io_usb_hid_receive+0x24>
c0d037e6:	4634      	mov	r4, r6
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d037e8:	42bd      	cmp	r5, r7
c0d037ea:	d217      	bcs.n	c0d0381c <io_usb_hid_receive+0x58>
    while(length--) {
c0d037ec:	2c00      	cmp	r4, #0
c0d037ee:	9e00      	ldr	r6, [sp, #0]
c0d037f0:	d027      	beq.n	c0d03842 <io_usb_hid_receive+0x7e>
c0d037f2:	2040      	movs	r0, #64	; 0x40
c0d037f4:	43c1      	mvns	r1, r0
c0d037f6:	4608      	mov	r0, r1
c0d037f8:	3040      	adds	r0, #64	; 0x40
c0d037fa:	1a83      	subs	r3, r0, r2
c0d037fc:	428b      	cmp	r3, r1
c0d037fe:	d800      	bhi.n	c0d03802 <io_usb_hid_receive+0x3e>
c0d03800:	460b      	mov	r3, r1
c0d03802:	313f      	adds	r1, #63	; 0x3f
c0d03804:	1acc      	subs	r4, r1, r3
c0d03806:	1929      	adds	r1, r5, r4
c0d03808:	4d55      	ldr	r5, [pc, #340]	; (c0d03960 <io_usb_hid_receive+0x19c>)
c0d0380a:	192c      	adds	r4, r5, r4
c0d0380c:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
c0d0380e:	780d      	ldrb	r5, [r1, #0]
c0d03810:	7025      	strb	r5, [r4, #0]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03812:	1809      	adds	r1, r1, r0
c0d03814:	1824      	adds	r4, r4, r0
c0d03816:	1c5b      	adds	r3, r3, #1
c0d03818:	d1f9      	bne.n	c0d0380e <io_usb_hid_receive+0x4a>
c0d0381a:	e012      	b.n	c0d03842 <io_usb_hid_receive+0x7e>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d0381c:	2c00      	cmp	r4, #0
c0d0381e:	9e00      	ldr	r6, [sp, #0]
c0d03820:	d00f      	beq.n	c0d03842 <io_usb_hid_receive+0x7e>
c0d03822:	2040      	movs	r0, #64	; 0x40
c0d03824:	43c0      	mvns	r0, r0
c0d03826:	4601      	mov	r1, r0
c0d03828:	3140      	adds	r1, #64	; 0x40
c0d0382a:	1a89      	subs	r1, r1, r2
c0d0382c:	4281      	cmp	r1, r0
c0d0382e:	d800      	bhi.n	c0d03832 <io_usb_hid_receive+0x6e>
c0d03830:	4601      	mov	r1, r0
c0d03832:	1c48      	adds	r0, r1, #1
      DSTCHAR[l] = SRCCHAR[l];
c0d03834:	7829      	ldrb	r1, [r5, #0]
c0d03836:	7039      	strb	r1, [r7, #0]
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03838:	1c40      	adds	r0, r0, #1
c0d0383a:	1c7f      	adds	r7, r7, #1
c0d0383c:	1c6d      	adds	r5, r5, #1
c0d0383e:	2800      	cmp	r0, #0
c0d03840:	d1f8      	bne.n	c0d03834 <io_usb_hid_receive+0x70>
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d03842:	4d47      	ldr	r5, [pc, #284]	; (c0d03960 <io_usb_hid_receive+0x19c>)
c0d03844:	78a8      	ldrb	r0, [r5, #2]
c0d03846:	2801      	cmp	r0, #1
c0d03848:	dc0a      	bgt.n	c0d03860 <io_usb_hid_receive+0x9c>
c0d0384a:	2800      	cmp	r0, #0
c0d0384c:	d030      	beq.n	c0d038b0 <io_usb_hid_receive+0xec>
c0d0384e:	2801      	cmp	r0, #1
c0d03850:	d17a      	bne.n	c0d03948 <io_usb_hid_receive+0x184>
    // await for the next chunk
    goto apdu_reset;

  case 0x01: // ALLOCATE CHANNEL
    // do not reset the current apdu reception if any
    cx_rng(G_io_usb_ep_buffer+3, 4);
c0d03852:	1ce8      	adds	r0, r5, #3
c0d03854:	2104      	movs	r1, #4
c0d03856:	f000 ffdf 	bl	c0d04818 <cx_rng>
c0d0385a:	2140      	movs	r1, #64	; 0x40
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d0385c:	4628      	mov	r0, r5
c0d0385e:	e032      	b.n	c0d038c6 <io_usb_hid_receive+0x102>
    os_memset(G_io_usb_ep_buffer, 0, sizeof(G_io_usb_ep_buffer));
    os_memmove(G_io_usb_ep_buffer, buffer, MIN(l, sizeof(G_io_usb_ep_buffer)));
  }

  // process the chunk content
  switch(G_io_usb_ep_buffer[2]) {
c0d03860:	2802      	cmp	r0, #2
c0d03862:	d02e      	beq.n	c0d038c2 <io_usb_hid_receive+0xfe>
c0d03864:	2805      	cmp	r0, #5
c0d03866:	d16f      	bne.n	c0d03948 <io_usb_hid_receive+0x184>
  case 0x05:
    // ensure sequence idx is 0 for the first chunk ! 
    if ((unsigned int)U2BE(G_io_usb_ep_buffer, 3) != (unsigned int)G_io_usb_hid_sequence_number) {
c0d03868:	7928      	ldrb	r0, [r5, #4]
c0d0386a:	78e9      	ldrb	r1, [r5, #3]
c0d0386c:	0209      	lsls	r1, r1, #8
c0d0386e:	1808      	adds	r0, r1, r0
c0d03870:	4e3c      	ldr	r6, [pc, #240]	; (c0d03964 <io_usb_hid_receive+0x1a0>)
c0d03872:	6831      	ldr	r1, [r6, #0]
c0d03874:	2700      	movs	r7, #0
c0d03876:	4288      	cmp	r0, r1
c0d03878:	d16c      	bne.n	c0d03954 <io_usb_hid_receive+0x190>
      // ignore packet
      goto apdu_reset;
    }
    // cid, tag, seq
    l -= 2+1+2;
c0d0387a:	1f50      	subs	r0, r2, #5
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
c0d0387c:	6831      	ldr	r1, [r6, #0]
c0d0387e:	2900      	cmp	r1, #0
c0d03880:	d024      	beq.n	c0d038cc <io_usb_hid_receive+0x108>
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
    }
    else {
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (l > G_io_usb_hid_remaining_length) {
c0d03882:	b281      	uxth	r1, r0
c0d03884:	4a38      	ldr	r2, [pc, #224]	; (c0d03968 <io_usb_hid_receive+0x1a4>)
c0d03886:	6813      	ldr	r3, [r2, #0]
c0d03888:	428b      	cmp	r3, r1
c0d0388a:	d201      	bcs.n	c0d03890 <io_usb_hid_receive+0xcc>
        l = G_io_usb_hid_remaining_length;
c0d0388c:	6810      	ldr	r0, [r2, #0]
      }

      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
c0d0388e:	b281      	uxth	r1, r0
c0d03890:	4a36      	ldr	r2, [pc, #216]	; (c0d0396c <io_usb_hid_receive+0x1a8>)
c0d03892:	6812      	ldr	r2, [r2, #0]
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03894:	1d6b      	adds	r3, r5, #5
c0d03896:	429a      	cmp	r2, r3
c0d03898:	d93f      	bls.n	c0d0391a <io_usb_hid_receive+0x156>
c0d0389a:	2300      	movs	r3, #0
    while(length--) {
c0d0389c:	0404      	lsls	r4, r0, #16
c0d0389e:	d047      	beq.n	c0d03930 <io_usb_hid_receive+0x16c>
c0d038a0:	3a41      	subs	r2, #65	; 0x41
c0d038a2:	3240      	adds	r2, #64	; 0x40
      DSTCHAR[length] = SRCCHAR[length];
c0d038a4:	186b      	adds	r3, r5, r1
c0d038a6:	791b      	ldrb	r3, [r3, #4]
c0d038a8:	5453      	strb	r3, [r2, r1]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d038aa:	1e49      	subs	r1, r1, #1
c0d038ac:	d1fa      	bne.n	c0d038a4 <io_usb_hid_receive+0xe0>
c0d038ae:	e03e      	b.n	c0d0392e <io_usb_hid_receive+0x16a>
c0d038b0:	2700      	movs	r7, #0
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d038b2:	71af      	strb	r7, [r5, #6]
c0d038b4:	716f      	strb	r7, [r5, #5]
c0d038b6:	712f      	strb	r7, [r5, #4]
c0d038b8:	70ef      	strb	r7, [r5, #3]
c0d038ba:	2140      	movs	r1, #64	; 0x40

  case 0x00: // get version ID
    // do not reset the current apdu reception if any
    os_memset(G_io_usb_ep_buffer+3, 0, 4); // PROTOCOL VERSION is 0
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d038bc:	4628      	mov	r0, r5
c0d038be:	47b0      	blx	r6
c0d038c0:	e048      	b.n	c0d03954 <io_usb_hid_receive+0x190>
    goto apdu_reset;

  case 0x02: // ECHO|PING
    // do not reset the current apdu reception if any
    // send the response
    sndfct(G_io_usb_ep_buffer, IO_HID_EP_LENGTH);
c0d038c2:	4827      	ldr	r0, [pc, #156]	; (c0d03960 <io_usb_hid_receive+0x19c>)
c0d038c4:	2140      	movs	r1, #64	; 0x40
c0d038c6:	47b0      	blx	r6
c0d038c8:	2700      	movs	r7, #0
c0d038ca:	e043      	b.n	c0d03954 <io_usb_hid_receive+0x190>
    
    // append the received chunk to the current command apdu
    if (G_io_usb_hid_sequence_number == 0) {
      /// This is the apdu first chunk
      // total apdu size to receive
      G_io_usb_hid_total_length = U2BE(G_io_usb_ep_buffer, 5); //(G_io_usb_ep_buffer[5]<<8)+(G_io_usb_ep_buffer[6]&0xFF);
c0d038cc:	79a8      	ldrb	r0, [r5, #6]
c0d038ce:	7969      	ldrb	r1, [r5, #5]
c0d038d0:	0209      	lsls	r1, r1, #8
c0d038d2:	1809      	adds	r1, r1, r0
c0d038d4:	4826      	ldr	r0, [pc, #152]	; (c0d03970 <io_usb_hid_receive+0x1ac>)
c0d038d6:	6001      	str	r1, [r0, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
c0d038d8:	6801      	ldr	r1, [r0, #0]
c0d038da:	0849      	lsrs	r1, r1, #1
c0d038dc:	29a8      	cmp	r1, #168	; 0xa8
c0d038de:	d839      	bhi.n	c0d03954 <io_usb_hid_receive+0x190>
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
c0d038e0:	6801      	ldr	r1, [r0, #0]
c0d038e2:	4821      	ldr	r0, [pc, #132]	; (c0d03968 <io_usb_hid_receive+0x1a4>)
c0d038e4:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);
c0d038e6:	7869      	ldrb	r1, [r5, #1]
c0d038e8:	782b      	ldrb	r3, [r5, #0]
c0d038ea:	021b      	lsls	r3, r3, #8
c0d038ec:	1859      	adds	r1, r3, r1
c0d038ee:	4b21      	ldr	r3, [pc, #132]	; (c0d03974 <io_usb_hid_receive+0x1b0>)
c0d038f0:	6019      	str	r1, [r3, #0]
      }
      // seq and total length
      l -= 2;
      // compute remaining size to receive
      G_io_usb_hid_remaining_length = G_io_usb_hid_total_length;
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d038f2:	491e      	ldr	r1, [pc, #120]	; (c0d0396c <io_usb_hid_receive+0x1a8>)
c0d038f4:	4b20      	ldr	r3, [pc, #128]	; (c0d03978 <io_usb_hid_receive+0x1b4>)
c0d038f6:	600b      	str	r3, [r1, #0]
      // check for invalid length encoding (more data in chunk that announced in the total apdu)
      if (G_io_usb_hid_total_length > sizeof(G_io_apdu_buffer)) {
        goto apdu_reset;
      }
      // seq and total length
      l -= 2;
c0d038f8:	1fd4      	subs	r4, r2, #7
      G_io_usb_hid_current_buffer = G_io_apdu_buffer;

      // retain the channel id to use for the reply
      G_io_usb_hid_channel = U2BE(G_io_usb_ep_buffer, 0);

      if (l > G_io_usb_hid_remaining_length) {
c0d038fa:	b2a2      	uxth	r2, r4
c0d038fc:	6801      	ldr	r1, [r0, #0]
c0d038fe:	4291      	cmp	r1, r2
c0d03900:	d201      	bcs.n	c0d03906 <io_usb_hid_receive+0x142>
        l = G_io_usb_hid_remaining_length;
c0d03902:	6804      	ldr	r4, [r0, #0]
      }
      // copy data
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+7, l);
c0d03904:	b2a2      	uxth	r2, r4
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03906:	1de9      	adds	r1, r5, #7
c0d03908:	428b      	cmp	r3, r1
c0d0390a:	2300      	movs	r3, #0
c0d0390c:	0420      	lsls	r0, r4, #16
c0d0390e:	d00f      	beq.n	c0d03930 <io_usb_hid_receive+0x16c>
c0d03910:	4819      	ldr	r0, [pc, #100]	; (c0d03978 <io_usb_hid_receive+0x1b4>)
c0d03912:	f002 fe85 	bl	c0d06620 <__aeabi_memcpy>
c0d03916:	4623      	mov	r3, r4
c0d03918:	e00a      	b.n	c0d03930 <io_usb_hid_receive+0x16c>
c0d0391a:	2300      	movs	r3, #0
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d0391c:	0404      	lsls	r4, r0, #16
c0d0391e:	d007      	beq.n	c0d03930 <io_usb_hid_receive+0x16c>
c0d03920:	1d6b      	adds	r3, r5, #5
      DSTCHAR[l] = SRCCHAR[l];
c0d03922:	781c      	ldrb	r4, [r3, #0]
c0d03924:	7014      	strb	r4, [r2, #0]
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03926:	1c52      	adds	r2, r2, #1
c0d03928:	1c5b      	adds	r3, r3, #1
c0d0392a:	1e49      	subs	r1, r1, #1
c0d0392c:	d1f9      	bne.n	c0d03922 <io_usb_hid_receive+0x15e>
c0d0392e:	4603      	mov	r3, r0
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d03930:	b298      	uxth	r0, r3
    G_io_usb_hid_remaining_length -= l;
c0d03932:	490d      	ldr	r1, [pc, #52]	; (c0d03968 <io_usb_hid_receive+0x1a4>)
c0d03934:	680a      	ldr	r2, [r1, #0]
c0d03936:	1a12      	subs	r2, r2, r0
c0d03938:	600a      	str	r2, [r1, #0]
      /// This is a following chunk
      // append content
      os_memmove((void*)G_io_usb_hid_current_buffer, G_io_usb_ep_buffer+5, l);
    }
    // factorize (f)
    G_io_usb_hid_current_buffer += l;
c0d0393a:	490c      	ldr	r1, [pc, #48]	; (c0d0396c <io_usb_hid_receive+0x1a8>)
c0d0393c:	680a      	ldr	r2, [r1, #0]
c0d0393e:	1810      	adds	r0, r2, r0
c0d03940:	6008      	str	r0, [r1, #0]
    G_io_usb_hid_remaining_length -= l;
    G_io_usb_hid_sequence_number++;
c0d03942:	6830      	ldr	r0, [r6, #0]
c0d03944:	1c40      	adds	r0, r0, #1
c0d03946:	6030      	str	r0, [r6, #0]
    // await for the next chunk
    goto apdu_reset;
  }

  // if more data to be received, notify it
  if (G_io_usb_hid_remaining_length) {
c0d03948:	4807      	ldr	r0, [pc, #28]	; (c0d03968 <io_usb_hid_receive+0x1a4>)
c0d0394a:	6801      	ldr	r1, [r0, #0]
c0d0394c:	2001      	movs	r0, #1
c0d0394e:	2702      	movs	r7, #2
c0d03950:	2900      	cmp	r1, #0
c0d03952:	d103      	bne.n	c0d0395c <io_usb_hid_receive+0x198>
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d03954:	4803      	ldr	r0, [pc, #12]	; (c0d03964 <io_usb_hid_receive+0x1a0>)
c0d03956:	2100      	movs	r1, #0
c0d03958:	6001      	str	r1, [r0, #0]
c0d0395a:	4638      	mov	r0, r7
  return IO_USB_APDU_RECEIVED;

apdu_reset:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}
c0d0395c:	b001      	add	sp, #4
c0d0395e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03960:	20002370 	.word	0x20002370
c0d03964:	20002160 	.word	0x20002160
c0d03968:	20002168 	.word	0x20002168
c0d0396c:	200022c0 	.word	0x200022c0
c0d03970:	20002164 	.word	0x20002164
c0d03974:	200022c4 	.word	0x200022c4
c0d03978:	2000216c 	.word	0x2000216c

c0d0397c <os_memset>:
    }
  }
#undef DSTCHAR
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
c0d0397c:	b580      	push	{r7, lr}
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
c0d0397e:	2a00      	cmp	r2, #0
c0d03980:	d004      	beq.n	c0d0398c <os_memset+0x10>
c0d03982:	460b      	mov	r3, r1
    DSTCHAR[length] = c;
c0d03984:	4611      	mov	r1, r2
c0d03986:	461a      	mov	r2, r3
c0d03988:	f002 fe4e 	bl	c0d06628 <__aeabi_memset>
  }
#undef DSTCHAR
}
c0d0398c:	bd80      	pop	{r7, pc}

c0d0398e <os_memmove>:
  }
}

#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
c0d0398e:	b5b0      	push	{r4, r5, r7, lr}
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03990:	4288      	cmp	r0, r1
c0d03992:	d908      	bls.n	c0d039a6 <os_memmove+0x18>
    while(length--) {
c0d03994:	2a00      	cmp	r2, #0
c0d03996:	d00f      	beq.n	c0d039b8 <os_memmove+0x2a>
c0d03998:	1e49      	subs	r1, r1, #1
c0d0399a:	1e40      	subs	r0, r0, #1
      DSTCHAR[length] = SRCCHAR[length];
c0d0399c:	5c8b      	ldrb	r3, [r1, r2]
c0d0399e:	5483      	strb	r3, [r0, r2]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d039a0:	1e52      	subs	r2, r2, #1
c0d039a2:	d1fb      	bne.n	c0d0399c <os_memmove+0xe>
c0d039a4:	e008      	b.n	c0d039b8 <os_memmove+0x2a>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d039a6:	2a00      	cmp	r2, #0
c0d039a8:	d006      	beq.n	c0d039b8 <os_memmove+0x2a>
c0d039aa:	2300      	movs	r3, #0
      DSTCHAR[l] = SRCCHAR[l];
c0d039ac:	b29c      	uxth	r4, r3
c0d039ae:	5d0d      	ldrb	r5, [r1, r4]
c0d039b0:	5505      	strb	r5, [r0, r4]
      l++;
c0d039b2:	1c5b      	adds	r3, r3, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d039b4:	1e52      	subs	r2, r2, #1
c0d039b6:	d1f9      	bne.n	c0d039ac <os_memmove+0x1e>
      DSTCHAR[l] = SRCCHAR[l];
      l++;
    }
  }
#undef DSTCHAR
}
c0d039b8:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d039bc <io_usb_hid_init>:
  io_usb_hid_init();
  return IO_USB_APDU_RESET;
}

void io_usb_hid_init(void) {
  G_io_usb_hid_sequence_number = 0; 
c0d039bc:	4801      	ldr	r0, [pc, #4]	; (c0d039c4 <io_usb_hid_init+0x8>)
c0d039be:	2100      	movs	r1, #0
c0d039c0:	6001      	str	r1, [r0, #0]
  //G_io_usb_hid_remaining_length = 0; // not really needed
  //G_io_usb_hid_total_length = 0; // not really needed
  //G_io_usb_hid_current_buffer = G_io_apdu_buffer; // not really needed
}
c0d039c2:	4770      	bx	lr
c0d039c4:	20002160 	.word	0x20002160

c0d039c8 <io_usb_hid_sent>:

/**
 * sent the next io_usb_hid transport chunk (rx on the host, tx on the device)
 */
void io_usb_hid_sent(io_send_t sndfct) {
c0d039c8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d039ca:	b081      	sub	sp, #4
  unsigned int l;

  // only prepare next chunk if some data to be sent remain
  if (G_io_usb_hid_remaining_length) {
c0d039cc:	4f3a      	ldr	r7, [pc, #232]	; (c0d03ab8 <io_usb_hid_sent+0xf0>)
c0d039ce:	6839      	ldr	r1, [r7, #0]
c0d039d0:	2900      	cmp	r1, #0
c0d039d2:	d02b      	beq.n	c0d03a2c <io_usb_hid_sent+0x64>
c0d039d4:	9000      	str	r0, [sp, #0]
}

void os_memset(void * dst, unsigned char c, unsigned int length) {
#define DSTCHAR ((unsigned char *)dst)
  while(length--) {
    DSTCHAR[length] = c;
c0d039d6:	4c39      	ldr	r4, [pc, #228]	; (c0d03abc <io_usb_hid_sent+0xf4>)
c0d039d8:	1d66      	adds	r6, r4, #5
c0d039da:	2539      	movs	r5, #57	; 0x39
c0d039dc:	4630      	mov	r0, r6
c0d039de:	4629      	mov	r1, r5
c0d039e0:	f002 fe18 	bl	c0d06614 <__aeabi_memclr>
c0d039e4:	2005      	movs	r0, #5
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
    G_io_usb_ep_buffer[2] = 0x05;
c0d039e6:	70a0      	strb	r0, [r4, #2]
  if (G_io_usb_hid_remaining_length) {
    // fill the chunk
    os_memset(G_io_usb_ep_buffer, 0, IO_HID_EP_LENGTH-2);

    // keep the channel identifier
    G_io_usb_ep_buffer[0] = (G_io_usb_hid_channel>>8)&0xFF;
c0d039e8:	4835      	ldr	r0, [pc, #212]	; (c0d03ac0 <io_usb_hid_sent+0xf8>)
c0d039ea:	6801      	ldr	r1, [r0, #0]
c0d039ec:	0a09      	lsrs	r1, r1, #8
c0d039ee:	7021      	strb	r1, [r4, #0]
    G_io_usb_ep_buffer[1] = G_io_usb_hid_channel&0xFF;
c0d039f0:	6800      	ldr	r0, [r0, #0]
c0d039f2:	7060      	strb	r0, [r4, #1]
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
c0d039f4:	4833      	ldr	r0, [pc, #204]	; (c0d03ac4 <io_usb_hid_sent+0xfc>)
c0d039f6:	6801      	ldr	r1, [r0, #0]
c0d039f8:	0a09      	lsrs	r1, r1, #8
c0d039fa:	70e1      	strb	r1, [r4, #3]
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;
c0d039fc:	6801      	ldr	r1, [r0, #0]
c0d039fe:	7121      	strb	r1, [r4, #4]

    if (G_io_usb_hid_sequence_number == 0) {
c0d03a00:	6802      	ldr	r2, [r0, #0]
c0d03a02:	6839      	ldr	r1, [r7, #0]
c0d03a04:	2a00      	cmp	r2, #0
c0d03a06:	d019      	beq.n	c0d03a3c <io_usb_hid_sent+0x74>
c0d03a08:	253b      	movs	r5, #59	; 0x3b
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 7;
    }
    else {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-5) ? IO_HID_EP_LENGTH-5 : G_io_usb_hid_remaining_length);
c0d03a0a:	293b      	cmp	r1, #59	; 0x3b
c0d03a0c:	d800      	bhi.n	c0d03a10 <io_usb_hid_sent+0x48>
c0d03a0e:	683d      	ldr	r5, [r7, #0]
      os_memmove(G_io_usb_ep_buffer+5, (const void*)G_io_usb_hid_current_buffer, l);
c0d03a10:	482d      	ldr	r0, [pc, #180]	; (c0d03ac8 <io_usb_hid_sent+0x100>)
c0d03a12:	6801      	ldr	r1, [r0, #0]
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03a14:	42b1      	cmp	r1, r6
c0d03a16:	d228      	bcs.n	c0d03a6a <io_usb_hid_sent+0xa2>
    while(length--) {
c0d03a18:	2d00      	cmp	r5, #0
c0d03a1a:	d03d      	beq.n	c0d03a98 <io_usb_hid_sent+0xd0>
c0d03a1c:	1e4a      	subs	r2, r1, #1
c0d03a1e:	462b      	mov	r3, r5
      DSTCHAR[length] = SRCCHAR[length];
c0d03a20:	5cd0      	ldrb	r0, [r2, r3]
c0d03a22:	18e6      	adds	r6, r4, r3
c0d03a24:	7130      	strb	r0, [r6, #4]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03a26:	1e5b      	subs	r3, r3, #1
c0d03a28:	d1fa      	bne.n	c0d03a20 <io_usb_hid_sent+0x58>
c0d03a2a:	e035      	b.n	c0d03a98 <io_usb_hid_sent+0xd0>
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
  }
  // cleanup when everything has been sent (ack for the last sent usb in packet)
  else {
    G_io_usb_hid_sequence_number = 0; 
c0d03a2c:	4825      	ldr	r0, [pc, #148]	; (c0d03ac4 <io_usb_hid_sent+0xfc>)
c0d03a2e:	2100      	movs	r1, #0
c0d03a30:	6001      	str	r1, [r0, #0]
    G_io_usb_hid_current_buffer = NULL;
c0d03a32:	4825      	ldr	r0, [pc, #148]	; (c0d03ac8 <io_usb_hid_sent+0x100>)
c0d03a34:	6001      	str	r1, [r0, #0]

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
c0d03a36:	4825      	ldr	r0, [pc, #148]	; (c0d03acc <io_usb_hid_sent+0x104>)
c0d03a38:	7001      	strb	r1, [r0, #0]
c0d03a3a:	e03b      	b.n	c0d03ab4 <io_usb_hid_sent+0xec>
    G_io_usb_ep_buffer[2] = 0x05;
    G_io_usb_ep_buffer[3] = G_io_usb_hid_sequence_number>>8;
    G_io_usb_ep_buffer[4] = G_io_usb_hid_sequence_number;

    if (G_io_usb_hid_sequence_number == 0) {
      l = ((G_io_usb_hid_remaining_length>IO_HID_EP_LENGTH-7) ? IO_HID_EP_LENGTH-7 : G_io_usb_hid_remaining_length);
c0d03a3c:	2939      	cmp	r1, #57	; 0x39
c0d03a3e:	d800      	bhi.n	c0d03a42 <io_usb_hid_sent+0x7a>
c0d03a40:	683d      	ldr	r5, [r7, #0]
      G_io_usb_ep_buffer[5] = G_io_usb_hid_remaining_length>>8;
c0d03a42:	6839      	ldr	r1, [r7, #0]
c0d03a44:	0a09      	lsrs	r1, r1, #8
c0d03a46:	7161      	strb	r1, [r4, #5]
      G_io_usb_ep_buffer[6] = G_io_usb_hid_remaining_length;
c0d03a48:	6839      	ldr	r1, [r7, #0]
c0d03a4a:	71a1      	strb	r1, [r4, #6]
      os_memmove(G_io_usb_ep_buffer+7, (const void*)G_io_usb_hid_current_buffer, l);
c0d03a4c:	491e      	ldr	r1, [pc, #120]	; (c0d03ac8 <io_usb_hid_sent+0x100>)
c0d03a4e:	6809      	ldr	r1, [r1, #0]
#endif // HAVE_USB_APDU

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
c0d03a50:	1de2      	adds	r2, r4, #7
c0d03a52:	4291      	cmp	r1, r2
c0d03a54:	d215      	bcs.n	c0d03a82 <io_usb_hid_sent+0xba>
    while(length--) {
c0d03a56:	2d00      	cmp	r5, #0
c0d03a58:	d01e      	beq.n	c0d03a98 <io_usb_hid_sent+0xd0>
c0d03a5a:	1e4a      	subs	r2, r1, #1
c0d03a5c:	462b      	mov	r3, r5
      DSTCHAR[length] = SRCCHAR[length];
c0d03a5e:	5cd6      	ldrb	r6, [r2, r3]
c0d03a60:	18e0      	adds	r0, r4, r3
c0d03a62:	7186      	strb	r6, [r0, #6]

REENTRANT(void os_memmove(void * dst, const void WIDE * src, unsigned int length)) {
#define DSTCHAR ((unsigned char *)dst)
#define SRCCHAR ((unsigned char WIDE *)src)
  if (dst > src) {
    while(length--) {
c0d03a64:	1e5b      	subs	r3, r3, #1
c0d03a66:	d1fa      	bne.n	c0d03a5e <io_usb_hid_sent+0x96>
c0d03a68:	e016      	b.n	c0d03a98 <io_usb_hid_sent+0xd0>
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03a6a:	2d00      	cmp	r5, #0
c0d03a6c:	d014      	beq.n	c0d03a98 <io_usb_hid_sent+0xd0>
c0d03a6e:	2200      	movs	r2, #0
c0d03a70:	462b      	mov	r3, r5
      DSTCHAR[l] = SRCCHAR[l];
c0d03a72:	b290      	uxth	r0, r2
c0d03a74:	5c0e      	ldrb	r6, [r1, r0]
c0d03a76:	1820      	adds	r0, r4, r0
c0d03a78:	7146      	strb	r6, [r0, #5]
      l++;
c0d03a7a:	1c52      	adds	r2, r2, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03a7c:	1e5b      	subs	r3, r3, #1
c0d03a7e:	d1f8      	bne.n	c0d03a72 <io_usb_hid_sent+0xaa>
c0d03a80:	e00a      	b.n	c0d03a98 <io_usb_hid_sent+0xd0>
c0d03a82:	2d00      	cmp	r5, #0
c0d03a84:	d008      	beq.n	c0d03a98 <io_usb_hid_sent+0xd0>
c0d03a86:	2200      	movs	r2, #0
c0d03a88:	462b      	mov	r3, r5
      DSTCHAR[l] = SRCCHAR[l];
c0d03a8a:	b290      	uxth	r0, r2
c0d03a8c:	5c0e      	ldrb	r6, [r1, r0]
c0d03a8e:	1820      	adds	r0, r4, r0
c0d03a90:	71c6      	strb	r6, [r0, #7]
      l++;
c0d03a92:	1c52      	adds	r2, r2, #1
      DSTCHAR[length] = SRCCHAR[length];
    }
  }
  else {
    unsigned short l = 0;
    while (length--) {
c0d03a94:	1e5b      	subs	r3, r3, #1
c0d03a96:	d1f8      	bne.n	c0d03a8a <io_usb_hid_sent+0xc2>
c0d03a98:	1949      	adds	r1, r1, r5
c0d03a9a:	9a00      	ldr	r2, [sp, #0]
c0d03a9c:	4b09      	ldr	r3, [pc, #36]	; (c0d03ac4 <io_usb_hid_sent+0xfc>)
c0d03a9e:	6838      	ldr	r0, [r7, #0]
c0d03aa0:	1b40      	subs	r0, r0, r5
c0d03aa2:	6038      	str	r0, [r7, #0]
c0d03aa4:	4808      	ldr	r0, [pc, #32]	; (c0d03ac8 <io_usb_hid_sent+0x100>)
c0d03aa6:	6001      	str	r1, [r0, #0]
      G_io_usb_hid_current_buffer += l;
      G_io_usb_hid_remaining_length -= l;
      l += 5;
    }
    // prepare next chunk numbering
    G_io_usb_hid_sequence_number++;
c0d03aa8:	6818      	ldr	r0, [r3, #0]
c0d03aaa:	1c40      	adds	r0, r0, #1
c0d03aac:	6018      	str	r0, [r3, #0]
    // send the chunk
    // always pad :)
    sndfct(G_io_usb_ep_buffer, sizeof(G_io_usb_ep_buffer));
c0d03aae:	4803      	ldr	r0, [pc, #12]	; (c0d03abc <io_usb_hid_sent+0xf4>)
c0d03ab0:	2140      	movs	r1, #64	; 0x40
c0d03ab2:	4790      	blx	r2
    G_io_usb_hid_current_buffer = NULL;

    // we sent the whole response
    G_io_apdu_state = APDU_IDLE;
  }
}
c0d03ab4:	b001      	add	sp, #4
c0d03ab6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03ab8:	20002168 	.word	0x20002168
c0d03abc:	20002370 	.word	0x20002370
c0d03ac0:	200022c4 	.word	0x200022c4
c0d03ac4:	20002160 	.word	0x20002160
c0d03ac8:	200022c0 	.word	0x200022c0
c0d03acc:	200022dc 	.word	0x200022dc

c0d03ad0 <io_usb_hid_send>:

void io_usb_hid_send(io_send_t sndfct, unsigned short sndlength) {
c0d03ad0:	b580      	push	{r7, lr}
  // perform send
  if (sndlength) {
c0d03ad2:	2900      	cmp	r1, #0
c0d03ad4:	d00b      	beq.n	c0d03aee <io_usb_hid_send+0x1e>
    G_io_usb_hid_sequence_number = 0; 
c0d03ad6:	4a06      	ldr	r2, [pc, #24]	; (c0d03af0 <io_usb_hid_send+0x20>)
c0d03ad8:	2300      	movs	r3, #0
c0d03ada:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
    G_io_usb_hid_remaining_length = sndlength;
c0d03adc:	4a05      	ldr	r2, [pc, #20]	; (c0d03af4 <io_usb_hid_send+0x24>)
c0d03ade:	6011      	str	r1, [r2, #0]

void io_usb_hid_send(io_send_t sndfct, unsigned short sndlength) {
  // perform send
  if (sndlength) {
    G_io_usb_hid_sequence_number = 0; 
    G_io_usb_hid_current_buffer = G_io_apdu_buffer;
c0d03ae0:	4a05      	ldr	r2, [pc, #20]	; (c0d03af8 <io_usb_hid_send+0x28>)
c0d03ae2:	4b06      	ldr	r3, [pc, #24]	; (c0d03afc <io_usb_hid_send+0x2c>)
c0d03ae4:	6013      	str	r3, [r2, #0]
    G_io_usb_hid_remaining_length = sndlength;
    G_io_usb_hid_total_length = sndlength;
c0d03ae6:	4a06      	ldr	r2, [pc, #24]	; (c0d03b00 <io_usb_hid_send+0x30>)
c0d03ae8:	6011      	str	r1, [r2, #0]
    io_usb_hid_sent(sndfct);
c0d03aea:	f7ff ff6d 	bl	c0d039c8 <io_usb_hid_sent>
  }
}
c0d03aee:	bd80      	pop	{r7, pc}
c0d03af0:	20002160 	.word	0x20002160
c0d03af4:	20002168 	.word	0x20002168
c0d03af8:	200022c0 	.word	0x200022c0
c0d03afc:	2000216c 	.word	0x2000216c
c0d03b00:	20002164 	.word	0x20002164

c0d03b04 <os_memcmp>:
    DSTCHAR[length] = c;
  }
#undef DSTCHAR
}

char os_memcmp(const void WIDE * buf1, const void WIDE * buf2, unsigned int length) {
c0d03b04:	b570      	push	{r4, r5, r6, lr}
#define BUF1 ((unsigned char const WIDE *)buf1)
#define BUF2 ((unsigned char const WIDE *)buf2)
  while(length--) {
c0d03b06:	1e40      	subs	r0, r0, #1
c0d03b08:	1e49      	subs	r1, r1, #1
c0d03b0a:	1e54      	subs	r4, r2, #1
c0d03b0c:	2300      	movs	r3, #0
c0d03b0e:	2a00      	cmp	r2, #0
c0d03b10:	d00a      	beq.n	c0d03b28 <os_memcmp+0x24>
    if (BUF1[length] != BUF2[length]) {
c0d03b12:	5c8d      	ldrb	r5, [r1, r2]
c0d03b14:	5c86      	ldrb	r6, [r0, r2]
c0d03b16:	42ae      	cmp	r6, r5
c0d03b18:	4622      	mov	r2, r4
c0d03b1a:	d0f6      	beq.n	c0d03b0a <os_memcmp+0x6>
c0d03b1c:	2000      	movs	r0, #0
c0d03b1e:	43c0      	mvns	r0, r0
c0d03b20:	2301      	movs	r3, #1
      return (BUF1[length] > BUF2[length])? 1:-1;
c0d03b22:	42ae      	cmp	r6, r5
c0d03b24:	d800      	bhi.n	c0d03b28 <os_memcmp+0x24>
c0d03b26:	4603      	mov	r3, r0
  }
  return 0;
#undef BUF1
#undef BUF2

}
c0d03b28:	b2d8      	uxtb	r0, r3
c0d03b2a:	bd70      	pop	{r4, r5, r6, pc}

c0d03b2c <os_longjmp>:
void try_context_set(try_context_t* ctx) {
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
c0d03b2c:	4601      	mov	r1, r0
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d03b2e:	4648      	mov	r0, r9
  __asm volatile ("mov r9, %0"::"r"(ctx));
}

#ifndef HAVE_BOLOS
void os_longjmp(unsigned int exception) {
  longjmp(try_context_get()->jmp_buf, exception);
c0d03b30:	f002 fe12 	bl	c0d06758 <longjmp>

c0d03b34 <try_context_get>:
  return xoracc;
}

try_context_t* try_context_get(void) {
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d03b34:	4648      	mov	r0, r9
  return current_ctx;
c0d03b36:	4770      	bx	lr

c0d03b38 <try_context_get_previous>:
}

try_context_t* try_context_get_previous(void) {
c0d03b38:	2000      	movs	r0, #0
  try_context_t* current_ctx;
  __asm volatile ("mov %0, r9":"=r"(current_ctx));
c0d03b3a:	4649      	mov	r1, r9

  // first context reached ?
  if (current_ctx == NULL) {
c0d03b3c:	2900      	cmp	r1, #0
c0d03b3e:	d000      	beq.n	c0d03b42 <try_context_get_previous+0xa>
  }

  // return r9 content saved on the current context. It links to the previous context.
  // r4 r5 r6 r7 r8 r9 r10 r11 sp lr
  //                ^ platform register
  return (try_context_t*) current_ctx->jmp_buf[5];
c0d03b40:	6948      	ldr	r0, [r1, #20]
}
c0d03b42:	4770      	bx	lr

c0d03b44 <io_seproxyhal_general_status>:

#ifndef IO_RAPDU_TRANSMIT_TIMEOUT_MS 
#define IO_RAPDU_TRANSMIT_TIMEOUT_MS 2000UL
#endif // IO_RAPDU_TRANSMIT_TIMEOUT_MS

void io_seproxyhal_general_status(void) {
c0d03b44:	b580      	push	{r7, lr}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
c0d03b46:	f001 f885 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d03b4a:	2800      	cmp	r0, #0
c0d03b4c:	d000      	beq.n	c0d03b50 <io_seproxyhal_general_status+0xc>
  G_io_seproxyhal_spi_buffer[1] = 0;
  G_io_seproxyhal_spi_buffer[2] = 2;
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}
c0d03b4e:	bd80      	pop	{r7, pc}
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d03b50:	4806      	ldr	r0, [pc, #24]	; (c0d03b6c <io_seproxyhal_general_status+0x28>)
c0d03b52:	2100      	movs	r1, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d03b54:	7041      	strb	r1, [r0, #1]
c0d03b56:	2260      	movs	r2, #96	; 0x60
  // avoid troubles
  if (io_seproxyhal_spi_is_status_sent()) {
    return;
  }
  // send the general status
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_GENERAL_STATUS;
c0d03b58:	7002      	strb	r2, [r0, #0]
c0d03b5a:	2202      	movs	r2, #2
  G_io_seproxyhal_spi_buffer[1] = 0;
  G_io_seproxyhal_spi_buffer[2] = 2;
c0d03b5c:	7082      	strb	r2, [r0, #2]
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND>>8;
c0d03b5e:	70c1      	strb	r1, [r0, #3]
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_GENERAL_STATUS_LAST_COMMAND;
c0d03b60:	7101      	strb	r1, [r0, #4]
c0d03b62:	2105      	movs	r1, #5
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
c0d03b64:	f001 f860 	bl	c0d04c28 <io_seproxyhal_spi_send>
}
c0d03b68:	bd80      	pop	{r7, pc}
c0d03b6a:	46c0      	nop			; (mov r8, r8)
c0d03b6c:	20001800 	.word	0x20001800

c0d03b70 <io_seproxyhal_handle_usb_event>:
} G_io_usb_ep_timeouts[IO_USB_MAX_ENDPOINTS];
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
c0d03b70:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d03b72:	4819      	ldr	r0, [pc, #100]	; (c0d03bd8 <io_seproxyhal_handle_usb_event+0x68>)
c0d03b74:	78c0      	ldrb	r0, [r0, #3]
c0d03b76:	2803      	cmp	r0, #3
c0d03b78:	dc07      	bgt.n	c0d03b8a <io_seproxyhal_handle_usb_event+0x1a>
c0d03b7a:	2801      	cmp	r0, #1
c0d03b7c:	d00d      	beq.n	c0d03b9a <io_seproxyhal_handle_usb_event+0x2a>
c0d03b7e:	2802      	cmp	r0, #2
c0d03b80:	d126      	bne.n	c0d03bd0 <io_seproxyhal_handle_usb_event+0x60>
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
c0d03b82:	4816      	ldr	r0, [pc, #88]	; (c0d03bdc <io_seproxyhal_handle_usb_event+0x6c>)
c0d03b84:	f001 ff07 	bl	c0d05996 <USBD_LL_SOF>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d03b88:	bd10      	pop	{r4, pc}
#include "usbd_def.h"
#include "usbd_core.h"
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
c0d03b8a:	2804      	cmp	r0, #4
c0d03b8c:	d01d      	beq.n	c0d03bca <io_seproxyhal_handle_usb_event+0x5a>
c0d03b8e:	2808      	cmp	r0, #8
c0d03b90:	d11e      	bne.n	c0d03bd0 <io_seproxyhal_handle_usb_event+0x60>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
c0d03b92:	4812      	ldr	r0, [pc, #72]	; (c0d03bdc <io_seproxyhal_handle_usb_event+0x6c>)
c0d03b94:	f001 fefd 	bl	c0d05992 <USBD_LL_Resume>
      break;
  }
}
c0d03b98:	bd10      	pop	{r4, pc}
extern USBD_HandleTypeDef USBD_Device;

void io_seproxyhal_handle_usb_event(void) {
  switch(G_io_seproxyhal_spi_buffer[3]) {
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
c0d03b9a:	4c10      	ldr	r4, [pc, #64]	; (c0d03bdc <io_seproxyhal_handle_usb_event+0x6c>)
c0d03b9c:	2101      	movs	r1, #1
c0d03b9e:	4620      	mov	r0, r4
c0d03ba0:	f001 fef2 	bl	c0d05988 <USBD_LL_SetSpeed>
      USBD_LL_Reset(&USBD_Device);
c0d03ba4:	4620      	mov	r0, r4
c0d03ba6:	f001 fed0 	bl	c0d0594a <USBD_LL_Reset>
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
c0d03baa:	480d      	ldr	r0, [pc, #52]	; (c0d03be0 <io_seproxyhal_handle_usb_event+0x70>)
c0d03bac:	7800      	ldrb	r0, [r0, #0]
c0d03bae:	2800      	cmp	r0, #0
c0d03bb0:	d10f      	bne.n	c0d03bd2 <io_seproxyhal_handle_usb_event+0x62>
        THROW(EXCEPTION_IO_RESET);
      }
      os_memset(G_io_usb_ep_xfer_len, 0, sizeof(G_io_usb_ep_xfer_len));
c0d03bb2:	480c      	ldr	r0, [pc, #48]	; (c0d03be4 <io_seproxyhal_handle_usb_event+0x74>)
c0d03bb4:	2400      	movs	r4, #0
c0d03bb6:	2206      	movs	r2, #6
c0d03bb8:	4621      	mov	r1, r4
c0d03bba:	f7ff fedf 	bl	c0d0397c <os_memset>
      os_memset(G_io_usb_ep_timeouts, 0, sizeof(G_io_usb_ep_timeouts));
c0d03bbe:	480a      	ldr	r0, [pc, #40]	; (c0d03be8 <io_seproxyhal_handle_usb_event+0x78>)
c0d03bc0:	220c      	movs	r2, #12
c0d03bc2:	4621      	mov	r1, r4
c0d03bc4:	f7ff feda 	bl	c0d0397c <os_memset>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d03bc8:	bd10      	pop	{r4, pc}
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SOF:
      USBD_LL_SOF(&USBD_Device);
      break;
    case SEPROXYHAL_TAG_USB_EVENT_SUSPENDED:
      USBD_LL_Suspend(&USBD_Device);
c0d03bca:	4804      	ldr	r0, [pc, #16]	; (c0d03bdc <io_seproxyhal_handle_usb_event+0x6c>)
c0d03bcc:	f001 fedf 	bl	c0d0598e <USBD_LL_Suspend>
      break;
    case SEPROXYHAL_TAG_USB_EVENT_RESUMED:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}
c0d03bd0:	bd10      	pop	{r4, pc}
c0d03bd2:	2010      	movs	r0, #16
    case SEPROXYHAL_TAG_USB_EVENT_RESET:
      USBD_LL_SetSpeed(&USBD_Device, USBD_SPEED_FULL);  
      USBD_LL_Reset(&USBD_Device);
      // ongoing APDU detected, throw a reset, even if not the media. to avoid potential troubles.
      if (G_io_apdu_media != IO_APDU_MEDIA_NONE) {
        THROW(EXCEPTION_IO_RESET);
c0d03bd4:	f7ff ffaa 	bl	c0d03b2c <os_longjmp>
c0d03bd8:	20001800 	.word	0x20001800
c0d03bdc:	200023b8 	.word	0x200023b8
c0d03be0:	200022c8 	.word	0x200022c8
c0d03be4:	200022c9 	.word	0x200022c9
c0d03be8:	200022d0 	.word	0x200022d0

c0d03bec <io_seproxyhal_get_ep_rx_size>:
      USBD_LL_Resume(&USBD_Device);
      break;
  }
}

uint16_t io_seproxyhal_get_ep_rx_size(uint8_t epnum) {
c0d03bec:	217f      	movs	r1, #127	; 0x7f
  return G_io_usb_ep_xfer_len[epnum&0x7F];
c0d03bee:	4001      	ands	r1, r0
c0d03bf0:	4801      	ldr	r0, [pc, #4]	; (c0d03bf8 <io_seproxyhal_get_ep_rx_size+0xc>)
c0d03bf2:	5c40      	ldrb	r0, [r0, r1]
c0d03bf4:	4770      	bx	lr
c0d03bf6:	46c0      	nop			; (mov r8, r8)
c0d03bf8:	200022c9 	.word	0x200022c9

c0d03bfc <io_seproxyhal_handle_usb_ep_xfer_event>:
}

void io_seproxyhal_handle_usb_ep_xfer_event(void) {
c0d03bfc:	b510      	push	{r4, lr}
  switch(G_io_seproxyhal_spi_buffer[4]) {
c0d03bfe:	4814      	ldr	r0, [pc, #80]	; (c0d03c50 <io_seproxyhal_handle_usb_ep_xfer_event+0x54>)
c0d03c00:	7901      	ldrb	r1, [r0, #4]
c0d03c02:	2904      	cmp	r1, #4
c0d03c04:	d016      	beq.n	c0d03c34 <io_seproxyhal_handle_usb_ep_xfer_event+0x38>
c0d03c06:	2902      	cmp	r1, #2
c0d03c08:	d006      	beq.n	c0d03c18 <io_seproxyhal_handle_usb_ep_xfer_event+0x1c>
c0d03c0a:	2901      	cmp	r1, #1
c0d03c0c:	d11e      	bne.n	c0d03c4c <io_seproxyhal_handle_usb_ep_xfer_event+0x50>
    /* This event is received when a new SETUP token had been received on a control endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_SETUP:
      // assume length of setup packet, and that it is on endpoint 0
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
c0d03c0e:	1d81      	adds	r1, r0, #6
c0d03c10:	4811      	ldr	r0, [pc, #68]	; (c0d03c58 <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d03c12:	f001 fda0 	bl	c0d05756 <USBD_LL_SetupStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d03c16:	bd10      	pop	{r4, pc}
      USBD_LL_SetupStage(&USBD_Device, &G_io_seproxyhal_spi_buffer[6]);
      break;

    /* This event is received after the prepare data packet has been flushed to the usb host */
    case SEPROXYHAL_TAG_USB_EP_XFER_IN:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d03c18:	78c2      	ldrb	r2, [r0, #3]
c0d03c1a:	217f      	movs	r1, #127	; 0x7f
c0d03c1c:	4011      	ands	r1, r2
c0d03c1e:	2905      	cmp	r1, #5
c0d03c20:	d814      	bhi.n	c0d03c4c <io_seproxyhal_handle_usb_ep_xfer_event+0x50>
        // discard ep timeout as we received the sent packet confirmation
        G_io_usb_ep_timeouts[G_io_seproxyhal_spi_buffer[3]&0x7F].timeout = 0;
c0d03c22:	004a      	lsls	r2, r1, #1
c0d03c24:	4b0d      	ldr	r3, [pc, #52]	; (c0d03c5c <io_seproxyhal_handle_usb_ep_xfer_event+0x60>)
c0d03c26:	2400      	movs	r4, #0
c0d03c28:	529c      	strh	r4, [r3, r2]
        // propagate sending ack of the data
        USBD_LL_DataInStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d03c2a:	1d82      	adds	r2, r0, #6
c0d03c2c:	480a      	ldr	r0, [pc, #40]	; (c0d03c58 <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d03c2e:	f001 fe18 	bl	c0d05862 <USBD_LL_DataInStage>
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
      }
      break;
  }
}
c0d03c32:	bd10      	pop	{r4, pc}
      }
      break;

    /* This event is received when a new DATA token is received on an endpoint */
    case SEPROXYHAL_TAG_USB_EP_XFER_OUT:
      if ((G_io_seproxyhal_spi_buffer[3]&0x7F) < IO_USB_MAX_ENDPOINTS) {
c0d03c34:	78c2      	ldrb	r2, [r0, #3]
c0d03c36:	217f      	movs	r1, #127	; 0x7f
c0d03c38:	4011      	ands	r1, r2
c0d03c3a:	2905      	cmp	r1, #5
c0d03c3c:	d806      	bhi.n	c0d03c4c <io_seproxyhal_handle_usb_ep_xfer_event+0x50>
        // saved just in case it is needed ...
        G_io_usb_ep_xfer_len[G_io_seproxyhal_spi_buffer[3]&0x7F] = G_io_seproxyhal_spi_buffer[5];
c0d03c3e:	7942      	ldrb	r2, [r0, #5]
c0d03c40:	4b04      	ldr	r3, [pc, #16]	; (c0d03c54 <io_seproxyhal_handle_usb_ep_xfer_event+0x58>)
c0d03c42:	545a      	strb	r2, [r3, r1]
        // prepare reception
        USBD_LL_DataOutStage(&USBD_Device, G_io_seproxyhal_spi_buffer[3]&0x7F, &G_io_seproxyhal_spi_buffer[6]);
c0d03c44:	1d82      	adds	r2, r0, #6
c0d03c46:	4804      	ldr	r0, [pc, #16]	; (c0d03c58 <io_seproxyhal_handle_usb_ep_xfer_event+0x5c>)
c0d03c48:	f001 fdb3 	bl	c0d057b2 <USBD_LL_DataOutStage>
      }
      break;
  }
}
c0d03c4c:	bd10      	pop	{r4, pc}
c0d03c4e:	46c0      	nop			; (mov r8, r8)
c0d03c50:	20001800 	.word	0x20001800
c0d03c54:	200022c9 	.word	0x200022c9
c0d03c58:	200023b8 	.word	0x200023b8
c0d03c5c:	200022d0 	.word	0x200022d0

c0d03c60 <io_usb_send_ep>:
#endif // HAVE_L4_USBLIB

// TODO, refactor this using the USB DataIn event like for the U2F tunnel
// TODO add a blocking parameter, for HID KBD sending, or use a USB busy flag per channel to know if 
// the transfer has been processed or not. and move on to the next transfer on the same endpoint
void io_usb_send_ep(unsigned int ep, unsigned char* buffer, unsigned short length, unsigned int timeout) {
c0d03c60:	b570      	push	{r4, r5, r6, lr}
  if (timeout) {
    timeout++;
  }

  // won't send if overflowing seproxyhal buffer format
  if (length > 255) {
c0d03c62:	2aff      	cmp	r2, #255	; 0xff
c0d03c64:	d81d      	bhi.n	c0d03ca2 <io_usb_send_ep+0x42>
c0d03c66:	4615      	mov	r5, r2
c0d03c68:	460e      	mov	r6, r1
c0d03c6a:	4604      	mov	r4, r0
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d03c6c:	480d      	ldr	r0, [pc, #52]	; (c0d03ca4 <io_usb_send_ep+0x44>)
c0d03c6e:	2150      	movs	r1, #80	; 0x50
c0d03c70:	7001      	strb	r1, [r0, #0]
c0d03c72:	2120      	movs	r1, #32
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
  G_io_seproxyhal_spi_buffer[2] = (3+length);
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d03c74:	7101      	strb	r1, [r0, #4]
  G_io_seproxyhal_spi_buffer[5] = length;
c0d03c76:	7142      	strb	r2, [r0, #5]
  if (length > 255) {
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d03c78:	1cd1      	adds	r1, r2, #3
  G_io_seproxyhal_spi_buffer[2] = (3+length);
c0d03c7a:	7081      	strb	r1, [r0, #2]
c0d03c7c:	2280      	movs	r2, #128	; 0x80
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
c0d03c7e:	4322      	orrs	r2, r4
c0d03c80:	70c2      	strb	r2, [r0, #3]
  if (length > 255) {
    return;
  }
  
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  G_io_seproxyhal_spi_buffer[1] = (3+length)>>8;
c0d03c82:	0a09      	lsrs	r1, r1, #8
c0d03c84:	7041      	strb	r1, [r0, #1]
c0d03c86:	2106      	movs	r1, #6
  G_io_seproxyhal_spi_buffer[2] = (3+length);
  G_io_seproxyhal_spi_buffer[3] = ep|0x80;
  G_io_seproxyhal_spi_buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
  G_io_seproxyhal_spi_buffer[5] = length;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 6);
c0d03c88:	f000 ffce 	bl	c0d04c28 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(buffer, length);
c0d03c8c:	4630      	mov	r0, r6
c0d03c8e:	4629      	mov	r1, r5
c0d03c90:	f000 ffca 	bl	c0d04c28 <io_seproxyhal_spi_send>
c0d03c94:	207f      	movs	r0, #127	; 0x7f
  // setup timeout of the endpoint
  G_io_usb_ep_timeouts[ep&0x7F].timeout = IO_RAPDU_TRANSMIT_TIMEOUT_MS;
c0d03c96:	4020      	ands	r0, r4
c0d03c98:	0040      	lsls	r0, r0, #1
c0d03c9a:	217d      	movs	r1, #125	; 0x7d
c0d03c9c:	0109      	lsls	r1, r1, #4
c0d03c9e:	4a02      	ldr	r2, [pc, #8]	; (c0d03ca8 <io_usb_send_ep+0x48>)
c0d03ca0:	5211      	strh	r1, [r2, r0]

}
c0d03ca2:	bd70      	pop	{r4, r5, r6, pc}
c0d03ca4:	20001800 	.word	0x20001800
c0d03ca8:	200022d0 	.word	0x200022d0

c0d03cac <io_usb_send_apdu_data>:

void io_usb_send_apdu_data(unsigned char* buffer, unsigned short length) {
c0d03cac:	b580      	push	{r7, lr}
c0d03cae:	460a      	mov	r2, r1
c0d03cb0:	4601      	mov	r1, r0
c0d03cb2:	2082      	movs	r0, #130	; 0x82
c0d03cb4:	2314      	movs	r3, #20
  // wait for 20 events before hanging up and timeout (~2 seconds of timeout)
  io_usb_send_ep(0x82, buffer, length, 20);
c0d03cb6:	f7ff ffd3 	bl	c0d03c60 <io_usb_send_ep>
}
c0d03cba:	bd80      	pop	{r7, pc}

c0d03cbc <io_seproxyhal_handle_capdu_event>:

}
#endif


void io_seproxyhal_handle_capdu_event(void) {
c0d03cbc:	b580      	push	{r7, lr}
  if(G_io_apdu_state == APDU_IDLE) 
c0d03cbe:	480e      	ldr	r0, [pc, #56]	; (c0d03cf8 <io_seproxyhal_handle_capdu_event+0x3c>)
c0d03cc0:	7801      	ldrb	r1, [r0, #0]
c0d03cc2:	2900      	cmp	r1, #0
c0d03cc4:	d000      	beq.n	c0d03cc8 <io_seproxyhal_handle_capdu_event+0xc>
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
    G_io_apdu_length = MIN(U2BE(G_io_seproxyhal_spi_buffer, 1), sizeof(G_io_apdu_buffer)); 
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
  }
}
c0d03cc6:	bd80      	pop	{r7, pc}


void io_seproxyhal_handle_capdu_event(void) {
  if(G_io_apdu_state == APDU_IDLE) 
  {
    G_io_apdu_media = IO_APDU_MEDIA_RAW; // for application code
c0d03cc8:	490c      	ldr	r1, [pc, #48]	; (c0d03cfc <io_seproxyhal_handle_capdu_event+0x40>)
c0d03cca:	2206      	movs	r2, #6
c0d03ccc:	700a      	strb	r2, [r1, #0]
c0d03cce:	210a      	movs	r1, #10
    G_io_apdu_state = APDU_RAW; // for next call to io_exchange
c0d03cd0:	7001      	strb	r1, [r0, #0]
    G_io_apdu_length = MIN(U2BE(G_io_seproxyhal_spi_buffer, 1), sizeof(G_io_apdu_buffer)); 
c0d03cd2:	480b      	ldr	r0, [pc, #44]	; (c0d03d00 <io_seproxyhal_handle_capdu_event+0x44>)
c0d03cd4:	7881      	ldrb	r1, [r0, #2]
c0d03cd6:	7842      	ldrb	r2, [r0, #1]
c0d03cd8:	0212      	lsls	r2, r2, #8
c0d03cda:	1851      	adds	r1, r2, r1
c0d03cdc:	22ff      	movs	r2, #255	; 0xff
c0d03cde:	3252      	adds	r2, #82	; 0x52
c0d03ce0:	4291      	cmp	r1, r2
c0d03ce2:	d300      	bcc.n	c0d03ce6 <io_seproxyhal_handle_capdu_event+0x2a>
c0d03ce4:	4611      	mov	r1, r2
c0d03ce6:	4a07      	ldr	r2, [pc, #28]	; (c0d03d04 <io_seproxyhal_handle_capdu_event+0x48>)
c0d03ce8:	8011      	strh	r1, [r2, #0]
    // copy apdu to apdu buffer
    os_memmove(G_io_apdu_buffer, G_io_seproxyhal_spi_buffer+3, G_io_apdu_length);
c0d03cea:	8812      	ldrh	r2, [r2, #0]
c0d03cec:	1cc1      	adds	r1, r0, #3
c0d03cee:	4806      	ldr	r0, [pc, #24]	; (c0d03d08 <io_seproxyhal_handle_capdu_event+0x4c>)
c0d03cf0:	f7ff fe4d 	bl	c0d0398e <os_memmove>
  }
}
c0d03cf4:	bd80      	pop	{r7, pc}
c0d03cf6:	46c0      	nop			; (mov r8, r8)
c0d03cf8:	200022dc 	.word	0x200022dc
c0d03cfc:	200022c8 	.word	0x200022c8
c0d03d00:	20001800 	.word	0x20001800
c0d03d04:	200022de 	.word	0x200022de
c0d03d08:	2000216c 	.word	0x2000216c

c0d03d0c <io_seproxyhal_handle_event>:

unsigned int io_seproxyhal_handle_event(void) {
c0d03d0c:	b510      	push	{r4, lr}
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);
c0d03d0e:	481f      	ldr	r0, [pc, #124]	; (c0d03d8c <io_seproxyhal_handle_event+0x80>)
c0d03d10:	7881      	ldrb	r1, [r0, #2]
c0d03d12:	7842      	ldrb	r2, [r0, #1]
c0d03d14:	0212      	lsls	r2, r2, #8
c0d03d16:	1851      	adds	r1, r2, r1

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d03d18:	7800      	ldrb	r0, [r0, #0]
c0d03d1a:	280f      	cmp	r0, #15
c0d03d1c:	dc0a      	bgt.n	c0d03d34 <io_seproxyhal_handle_event+0x28>
c0d03d1e:	280e      	cmp	r0, #14
c0d03d20:	d010      	beq.n	c0d03d44 <io_seproxyhal_handle_event+0x38>
c0d03d22:	280f      	cmp	r0, #15
c0d03d24:	d120      	bne.n	c0d03d68 <io_seproxyhal_handle_event+0x5c>
c0d03d26:	2000      	movs	r0, #0
  #ifdef HAVE_IO_USB
    case SEPROXYHAL_TAG_USB_EVENT:
      if (rx_len != 1) {
c0d03d28:	2901      	cmp	r1, #1
c0d03d2a:	d124      	bne.n	c0d03d76 <io_seproxyhal_handle_event+0x6a>
        return 0;
      }
      io_seproxyhal_handle_usb_event();
c0d03d2c:	f7ff ff20 	bl	c0d03b70 <io_seproxyhal_handle_usb_event>
c0d03d30:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03d32:	bd10      	pop	{r4, pc}
}

unsigned int io_seproxyhal_handle_event(void) {
  unsigned int rx_len = U2BE(G_io_seproxyhal_spi_buffer, 1);

  switch(G_io_seproxyhal_spi_buffer[0]) {
c0d03d34:	2810      	cmp	r0, #16
c0d03d36:	d01b      	beq.n	c0d03d70 <io_seproxyhal_handle_event+0x64>
c0d03d38:	2816      	cmp	r0, #22
c0d03d3a:	d115      	bne.n	c0d03d68 <io_seproxyhal_handle_event+0x5c>
      }
      return 1;
  #endif // HAVE_BLE

    case SEPROXYHAL_TAG_CAPDU_EVENT:
      io_seproxyhal_handle_capdu_event();
c0d03d3c:	f7ff ffbe 	bl	c0d03cbc <io_seproxyhal_handle_capdu_event>
c0d03d40:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03d42:	bd10      	pop	{r4, pc}
c0d03d44:	210a      	movs	r1, #10
c0d03d46:	4812      	ldr	r0, [pc, #72]	; (c0d03d90 <io_seproxyhal_handle_event+0x84>)
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
c0d03d48:	5a42      	ldrh	r2, [r0, r1]
c0d03d4a:	2a00      	cmp	r2, #0
c0d03d4c:	d008      	beq.n	c0d03d60 <io_seproxyhal_handle_event+0x54>
c0d03d4e:	2364      	movs	r3, #100	; 0x64
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
c0d03d50:	2a64      	cmp	r2, #100	; 0x64
c0d03d52:	4614      	mov	r4, r2
c0d03d54:	d300      	bcc.n	c0d03d58 <io_seproxyhal_handle_event+0x4c>
c0d03d56:	461c      	mov	r4, r3
c0d03d58:	1b12      	subs	r2, r2, r4
c0d03d5a:	5242      	strh	r2, [r0, r1]
            if (!G_io_usb_ep_timeouts[i].timeout) {
c0d03d5c:	0412      	lsls	r2, r2, #16
c0d03d5e:	d00f      	beq.n	c0d03d80 <io_seproxyhal_handle_event+0x74>
    case SEPROXYHAL_TAG_TICKER_EVENT:
      // process ticker events to timeout the IO transfers, and forward to the user io_event function too
#ifdef HAVE_IO_USB
      {
        unsigned int i = IO_USB_MAX_ENDPOINTS;
        while(i--) {
c0d03d60:	1e8a      	subs	r2, r1, #2
c0d03d62:	2900      	cmp	r1, #0
c0d03d64:	4611      	mov	r1, r2
c0d03d66:	d1ef      	bne.n	c0d03d48 <io_seproxyhal_handle_event+0x3c>
c0d03d68:	2002      	movs	r0, #2
        }
      }
#endif // HAVE_IO_USB
      // no break is intentional
    default:
      return io_event(CHANNEL_SPI);
c0d03d6a:	f7fe f9a7 	bl	c0d020bc <io_event>
  }
  // defaultly return as not processed
  return 0;
}
c0d03d6e:	bd10      	pop	{r4, pc}
c0d03d70:	2000      	movs	r0, #0
      }
      io_seproxyhal_handle_usb_event();
      return 1;

    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3) {
c0d03d72:	2903      	cmp	r1, #3
c0d03d74:	d200      	bcs.n	c0d03d78 <io_seproxyhal_handle_event+0x6c>
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03d76:	bd10      	pop	{r4, pc}
    case SEPROXYHAL_TAG_USB_EP_XFER_EVENT:
      if (rx_len < 3) {
        // error !
        return 0;
      }
      io_seproxyhal_handle_usb_ep_xfer_event();
c0d03d78:	f7ff ff40 	bl	c0d03bfc <io_seproxyhal_handle_usb_ep_xfer_event>
c0d03d7c:	2001      	movs	r0, #1
    default:
      return io_event(CHANNEL_SPI);
  }
  // defaultly return as not processed
  return 0;
}
c0d03d7e:	bd10      	pop	{r4, pc}
        while(i--) {
          if (G_io_usb_ep_timeouts[i].timeout) {
            G_io_usb_ep_timeouts[i].timeout-=MIN(G_io_usb_ep_timeouts[i].timeout, 100);
            if (!G_io_usb_ep_timeouts[i].timeout) {
              // timeout !
              G_io_apdu_state = APDU_IDLE;
c0d03d80:	4804      	ldr	r0, [pc, #16]	; (c0d03d94 <io_seproxyhal_handle_event+0x88>)
c0d03d82:	2100      	movs	r1, #0
c0d03d84:	7001      	strb	r1, [r0, #0]
c0d03d86:	2010      	movs	r0, #16
              THROW(EXCEPTION_IO_RESET);
c0d03d88:	f7ff fed0 	bl	c0d03b2c <os_longjmp>
c0d03d8c:	20001800 	.word	0x20001800
c0d03d90:	200022d0 	.word	0x200022d0
c0d03d94:	200022dc 	.word	0x200022dc

c0d03d98 <io_seproxyhal_init>:
#ifdef HAVE_BOLOS_APP_STACK_CANARY
#define APP_STACK_CANARY_MAGIC 0xDEAD0031
extern unsigned int app_stack_canary;
#endif // HAVE_BOLOS_APP_STACK_CANARY

void io_seproxyhal_init(void) {
c0d03d98:	b510      	push	{r4, lr}
c0d03d9a:	2009      	movs	r0, #9
  // Enforce OS compatibility
  check_api_level(CX_COMPAT_APILEVEL);
c0d03d9c:	f000 fcfc 	bl	c0d04798 <check_api_level>

#ifdef HAVE_BOLOS_APP_STACK_CANARY
  app_stack_canary = APP_STACK_CANARY_MAGIC;
#endif // HAVE_BOLOS_APP_STACK_CANARY  

  G_io_apdu_state = APDU_IDLE;
c0d03da0:	4807      	ldr	r0, [pc, #28]	; (c0d03dc0 <io_seproxyhal_init+0x28>)
c0d03da2:	2400      	movs	r4, #0
c0d03da4:	7004      	strb	r4, [r0, #0]
  G_io_apdu_length = 0;
c0d03da6:	4807      	ldr	r0, [pc, #28]	; (c0d03dc4 <io_seproxyhal_init+0x2c>)
c0d03da8:	8004      	strh	r4, [r0, #0]
  G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d03daa:	4807      	ldr	r0, [pc, #28]	; (c0d03dc8 <io_seproxyhal_init+0x30>)
c0d03dac:	7004      	strb	r4, [r0, #0]
  debug_apdus_offset = 0;
  #endif // DEBUG_APDU


  #ifdef HAVE_USB_APDU
  io_usb_hid_init();
c0d03dae:	f7ff fe05 	bl	c0d039bc <io_usb_hid_init>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d03db2:	4806      	ldr	r0, [pc, #24]	; (c0d03dcc <io_seproxyhal_init+0x34>)
c0d03db4:	6004      	str	r4, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d03db6:	4806      	ldr	r0, [pc, #24]	; (c0d03dd0 <io_seproxyhal_init+0x38>)
c0d03db8:	6004      	str	r4, [r0, #0]
  G_button_same_mask_counter = 0;
c0d03dba:	4806      	ldr	r0, [pc, #24]	; (c0d03dd4 <io_seproxyhal_init+0x3c>)
c0d03dbc:	6004      	str	r4, [r0, #0]
  io_usb_hid_init();
  #endif // HAVE_USB_APDU

  io_seproxyhal_init_ux();
  io_seproxyhal_init_button();
}
c0d03dbe:	bd10      	pop	{r4, pc}
c0d03dc0:	200022dc 	.word	0x200022dc
c0d03dc4:	200022de 	.word	0x200022de
c0d03dc8:	200022c8 	.word	0x200022c8
c0d03dcc:	200022e0 	.word	0x200022e0
c0d03dd0:	200022e4 	.word	0x200022e4
c0d03dd4:	200022e8 	.word	0x200022e8

c0d03dd8 <io_seproxyhal_init_ux>:

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d03dd8:	4801      	ldr	r0, [pc, #4]	; (c0d03de0 <io_seproxyhal_init_ux+0x8>)
c0d03dda:	2100      	movs	r1, #0
c0d03ddc:	6001      	str	r1, [r0, #0]
}
c0d03dde:	4770      	bx	lr
c0d03de0:	200022e0 	.word	0x200022e0

c0d03de4 <io_seproxyhal_init_button>:

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d03de4:	4802      	ldr	r0, [pc, #8]	; (c0d03df0 <io_seproxyhal_init_button+0xc>)
c0d03de6:	2100      	movs	r1, #0
c0d03de8:	6001      	str	r1, [r0, #0]
  G_button_same_mask_counter = 0;
c0d03dea:	4802      	ldr	r0, [pc, #8]	; (c0d03df4 <io_seproxyhal_init_button+0x10>)
c0d03dec:	6001      	str	r1, [r0, #0]
}
c0d03dee:	4770      	bx	lr
c0d03df0:	200022e4 	.word	0x200022e4
c0d03df4:	200022e8 	.word	0x200022e8

c0d03df8 <io_seproxyhal_touch_out>:

#ifdef HAVE_BAGL

unsigned int io_seproxyhal_touch_out(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d03df8:	b5b0      	push	{r4, r5, r7, lr}
c0d03dfa:	460d      	mov	r5, r1
c0d03dfc:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->out != NULL) {
c0d03dfe:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d03e00:	2800      	cmp	r0, #0
c0d03e02:	d00b      	beq.n	c0d03e1c <io_seproxyhal_touch_out+0x24>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->out))(element));
c0d03e04:	f000 fcb0 	bl	c0d04768 <pic>
c0d03e08:	4601      	mov	r1, r0
c0d03e0a:	4620      	mov	r0, r4
c0d03e0c:	4788      	blx	r1
c0d03e0e:	f000 fcab 	bl	c0d04768 <pic>
    // backward compatible with samples and such
    if (! el) {
c0d03e12:	2800      	cmp	r0, #0
c0d03e14:	d00f      	beq.n	c0d03e36 <io_seproxyhal_touch_out+0x3e>
c0d03e16:	2801      	cmp	r0, #1
c0d03e18:	d000      	beq.n	c0d03e1c <io_seproxyhal_touch_out+0x24>
c0d03e1a:	4604      	mov	r4, r0
      element = el;
    }
  }

  // out function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d03e1c:	2d00      	cmp	r5, #0
c0d03e1e:	d006      	beq.n	c0d03e2e <io_seproxyhal_touch_out+0x36>
    el = before_display(element);
c0d03e20:	4620      	mov	r0, r4
c0d03e22:	47a8      	blx	r5
    if (!el) {
c0d03e24:	2800      	cmp	r0, #0
c0d03e26:	d006      	beq.n	c0d03e36 <io_seproxyhal_touch_out+0x3e>
c0d03e28:	2801      	cmp	r0, #1
c0d03e2a:	d000      	beq.n	c0d03e2e <io_seproxyhal_touch_out+0x36>
c0d03e2c:	4604      	mov	r4, r0
    if ((unsigned int)el != 1) {
      element = el;
    }
  }

  io_seproxyhal_display(element);
c0d03e2e:	4620      	mov	r0, r4
c0d03e30:	f7ff fb18 	bl	c0d03464 <io_seproxyhal_display>
c0d03e34:	2001      	movs	r0, #1
  return 1;
}
c0d03e36:	bdb0      	pop	{r4, r5, r7, pc}

c0d03e38 <io_seproxyhal_touch_over>:

unsigned int io_seproxyhal_touch_over(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d03e38:	b5b0      	push	{r4, r5, r7, lr}
c0d03e3a:	b08e      	sub	sp, #56	; 0x38
c0d03e3c:	460d      	mov	r5, r1
c0d03e3e:	4604      	mov	r4, r0
  bagl_element_t e;
  const bagl_element_t* el;
  if (element->over != NULL) {
c0d03e40:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d03e42:	2800      	cmp	r0, #0
c0d03e44:	d00b      	beq.n	c0d03e5e <io_seproxyhal_touch_over+0x26>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->over))(element));
c0d03e46:	f000 fc8f 	bl	c0d04768 <pic>
c0d03e4a:	4601      	mov	r1, r0
c0d03e4c:	4620      	mov	r0, r4
c0d03e4e:	4788      	blx	r1
c0d03e50:	f000 fc8a 	bl	c0d04768 <pic>
    // backward compatible with samples and such
    if (!el) {
c0d03e54:	2800      	cmp	r0, #0
c0d03e56:	d01a      	beq.n	c0d03e8e <io_seproxyhal_touch_over+0x56>
c0d03e58:	2801      	cmp	r0, #1
c0d03e5a:	d000      	beq.n	c0d03e5e <io_seproxyhal_touch_over+0x26>
c0d03e5c:	4604      	mov	r4, r0
      element = el;
    }
  }

  // over function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d03e5e:	2d00      	cmp	r5, #0
c0d03e60:	d007      	beq.n	c0d03e72 <io_seproxyhal_touch_over+0x3a>
    el = before_display(element);
c0d03e62:	4620      	mov	r0, r4
c0d03e64:	47a8      	blx	r5
c0d03e66:	466c      	mov	r4, sp
    element = &e;
    if (!el) {
c0d03e68:	2800      	cmp	r0, #0
c0d03e6a:	d010      	beq.n	c0d03e8e <io_seproxyhal_touch_over+0x56>
c0d03e6c:	2801      	cmp	r0, #1
c0d03e6e:	d000      	beq.n	c0d03e72 <io_seproxyhal_touch_over+0x3a>
c0d03e70:	4604      	mov	r4, r0
c0d03e72:	466d      	mov	r5, sp
c0d03e74:	2238      	movs	r2, #56	; 0x38
      element = el;
    }
  }

  // swap colors
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
c0d03e76:	4628      	mov	r0, r5
c0d03e78:	4621      	mov	r1, r4
c0d03e7a:	f7ff fd88 	bl	c0d0398e <os_memmove>
  e.component.fgcolor = element->overfgcolor;
c0d03e7e:	6a60      	ldr	r0, [r4, #36]	; 0x24
  e.component.bgcolor = element->overbgcolor;
c0d03e80:	6aa1      	ldr	r1, [r4, #40]	; 0x28
    }
  }

  // swap colors
  os_memmove(&e, (void*)element, sizeof(bagl_element_t));
  e.component.fgcolor = element->overfgcolor;
c0d03e82:	9004      	str	r0, [sp, #16]
  e.component.bgcolor = element->overbgcolor;
c0d03e84:	9105      	str	r1, [sp, #20]

  io_seproxyhal_display(&e);
c0d03e86:	4628      	mov	r0, r5
c0d03e88:	f7ff faec 	bl	c0d03464 <io_seproxyhal_display>
c0d03e8c:	2001      	movs	r0, #1
  return 1;
}
c0d03e8e:	b00e      	add	sp, #56	; 0x38
c0d03e90:	bdb0      	pop	{r4, r5, r7, pc}

c0d03e92 <io_seproxyhal_touch_tap>:

unsigned int io_seproxyhal_touch_tap(const bagl_element_t* element, bagl_element_callback_t before_display) {
c0d03e92:	b5b0      	push	{r4, r5, r7, lr}
c0d03e94:	460d      	mov	r5, r1
c0d03e96:	4604      	mov	r4, r0
  const bagl_element_t* el;
  if (element->tap != NULL) {
c0d03e98:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d03e9a:	2800      	cmp	r0, #0
c0d03e9c:	d00b      	beq.n	c0d03eb6 <io_seproxyhal_touch_tap+0x24>
    el = (const bagl_element_t*)PIC(((bagl_element_callback_t)PIC(element->tap))(element));
c0d03e9e:	f000 fc63 	bl	c0d04768 <pic>
c0d03ea2:	4601      	mov	r1, r0
c0d03ea4:	4620      	mov	r0, r4
c0d03ea6:	4788      	blx	r1
c0d03ea8:	f000 fc5e 	bl	c0d04768 <pic>
    // backward compatible with samples and such
    if (!el) {
c0d03eac:	2800      	cmp	r0, #0
c0d03eae:	d00f      	beq.n	c0d03ed0 <io_seproxyhal_touch_tap+0x3e>
c0d03eb0:	2801      	cmp	r0, #1
c0d03eb2:	d000      	beq.n	c0d03eb6 <io_seproxyhal_touch_tap+0x24>
c0d03eb4:	4604      	mov	r4, r0
      element = el;
    }
  }

  // tap function might have triggered a draw of its own during a display callback
  if (before_display) {
c0d03eb6:	2d00      	cmp	r5, #0
c0d03eb8:	d006      	beq.n	c0d03ec8 <io_seproxyhal_touch_tap+0x36>
    el = before_display(element);
c0d03eba:	4620      	mov	r0, r4
c0d03ebc:	47a8      	blx	r5
    if (!el) {
c0d03ebe:	2800      	cmp	r0, #0
c0d03ec0:	d006      	beq.n	c0d03ed0 <io_seproxyhal_touch_tap+0x3e>
c0d03ec2:	2801      	cmp	r0, #1
c0d03ec4:	d000      	beq.n	c0d03ec8 <io_seproxyhal_touch_tap+0x36>
c0d03ec6:	4604      	mov	r4, r0
    }
    if ((unsigned int)el != 1) {
      element = el;
    }
  }
  io_seproxyhal_display(element);
c0d03ec8:	4620      	mov	r0, r4
c0d03eca:	f7ff facb 	bl	c0d03464 <io_seproxyhal_display>
c0d03ece:	2001      	movs	r0, #1
  return 1;
}
c0d03ed0:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0d03ed4 <io_seproxyhal_touch_element_callback>:
  io_seproxyhal_touch_element_callback(elements, element_count, x, y, event_kind, NULL);  
}

// browse all elements and until an element has changed state, continue browsing
// return if processed or not
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
c0d03ed4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03ed6:	b087      	sub	sp, #28
c0d03ed8:	9302      	str	r3, [sp, #8]
c0d03eda:	9203      	str	r2, [sp, #12]
c0d03edc:	9105      	str	r1, [sp, #20]
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d03ede:	2900      	cmp	r1, #0
c0d03ee0:	d076      	beq.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
c0d03ee2:	9004      	str	r0, [sp, #16]
c0d03ee4:	980d      	ldr	r0, [sp, #52]	; 0x34
c0d03ee6:	9001      	str	r0, [sp, #4]
c0d03ee8:	980c      	ldr	r0, [sp, #48]	; 0x30
c0d03eea:	9000      	str	r0, [sp, #0]
c0d03eec:	2500      	movs	r5, #0
c0d03eee:	4b3c      	ldr	r3, [pc, #240]	; (c0d03fe0 <io_seproxyhal_touch_element_callback+0x10c>)
c0d03ef0:	9506      	str	r5, [sp, #24]
c0d03ef2:	462f      	mov	r7, r5
c0d03ef4:	461e      	mov	r6, r3
    // process all components matching the x/y/w/h (no break) => fishy for the released out of zone
    // continue processing only if a status has not been sent
    if (io_seproxyhal_spi_is_status_sent()) {
c0d03ef6:	f000 fead 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d03efa:	2800      	cmp	r0, #0
c0d03efc:	d155      	bne.n	c0d03faa <io_seproxyhal_touch_element_callback+0xd6>
c0d03efe:	2038      	movs	r0, #56	; 0x38
      // continue instead of return to process all elemnts and therefore discard last touched element
      break;
    }

    // only perform out callback when element was in the current array, else, leave it be
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
c0d03f00:	4368      	muls	r0, r5
c0d03f02:	9c04      	ldr	r4, [sp, #16]
c0d03f04:	1825      	adds	r5, r4, r0
c0d03f06:	4633      	mov	r3, r6
c0d03f08:	6832      	ldr	r2, [r6, #0]
c0d03f0a:	2101      	movs	r1, #1
c0d03f0c:	4295      	cmp	r5, r2
c0d03f0e:	d000      	beq.n	c0d03f12 <io_seproxyhal_touch_element_callback+0x3e>
c0d03f10:	9906      	ldr	r1, [sp, #24]
c0d03f12:	9106      	str	r1, [sp, #24]
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d03f14:	5620      	ldrsb	r0, [r4, r0]
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
c0d03f16:	2800      	cmp	r0, #0
c0d03f18:	da41      	bge.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
c0d03f1a:	2020      	movs	r0, #32
c0d03f1c:	5c28      	ldrb	r0, [r5, r0]
c0d03f1e:	2102      	movs	r1, #2
c0d03f20:	5e69      	ldrsh	r1, [r5, r1]
c0d03f22:	1a0a      	subs	r2, r1, r0
c0d03f24:	9c03      	ldr	r4, [sp, #12]
c0d03f26:	42a2      	cmp	r2, r4
c0d03f28:	dc39      	bgt.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
c0d03f2a:	1841      	adds	r1, r0, r1
c0d03f2c:	88ea      	ldrh	r2, [r5, #6]
c0d03f2e:	1889      	adds	r1, r1, r2
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {
c0d03f30:	9a03      	ldr	r2, [sp, #12]
c0d03f32:	4291      	cmp	r1, r2
c0d03f34:	dd33      	ble.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
c0d03f36:	2104      	movs	r1, #4
c0d03f38:	5e6c      	ldrsh	r4, [r5, r1]
c0d03f3a:	1a22      	subs	r2, r4, r0
c0d03f3c:	9902      	ldr	r1, [sp, #8]
c0d03f3e:	428a      	cmp	r2, r1
c0d03f40:	dc2d      	bgt.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
c0d03f42:	1820      	adds	r0, r4, r0
c0d03f44:	8929      	ldrh	r1, [r5, #8]
c0d03f46:	1840      	adds	r0, r0, r1
    if (&elements[comp_idx] == G_bagl_last_touched_not_released_component) {
      last_touched_not_released_component_was_in_current_array = 1;
    }

    // the first component drawn with a 
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
c0d03f48:	9902      	ldr	r1, [sp, #8]
c0d03f4a:	4288      	cmp	r0, r1
c0d03f4c:	dd27      	ble.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d03f4e:	6818      	ldr	r0, [r3, #0]
              && G_bagl_last_touched_not_released_component != NULL) {
c0d03f50:	4285      	cmp	r5, r0
c0d03f52:	d010      	beq.n	c0d03f76 <io_seproxyhal_touch_element_callback+0xa2>
c0d03f54:	6818      	ldr	r0, [r3, #0]
    if ((elements[comp_idx].component.type & BAGL_FLAG_TOUCHABLE) 
        && elements[comp_idx].component.x-elements[comp_idx].touch_area_brim <= x && x<elements[comp_idx].component.x+elements[comp_idx].component.width+elements[comp_idx].touch_area_brim
        && elements[comp_idx].component.y-elements[comp_idx].touch_area_brim <= y && y<elements[comp_idx].component.y+elements[comp_idx].component.height+elements[comp_idx].touch_area_brim) {

      // outing the previous over'ed component
      if (&elements[comp_idx] != G_bagl_last_touched_not_released_component 
c0d03f56:	2800      	cmp	r0, #0
c0d03f58:	d00d      	beq.n	c0d03f76 <io_seproxyhal_touch_element_callback+0xa2>
              && G_bagl_last_touched_not_released_component != NULL) {
        // only out the previous element if the newly matching will be displayed 
        if (!before_display || before_display(&elements[comp_idx])) {
c0d03f5a:	9801      	ldr	r0, [sp, #4]
c0d03f5c:	2800      	cmp	r0, #0
c0d03f5e:	d005      	beq.n	c0d03f6c <io_seproxyhal_touch_element_callback+0x98>
c0d03f60:	4628      	mov	r0, r5
c0d03f62:	9901      	ldr	r1, [sp, #4]
c0d03f64:	4788      	blx	r1
c0d03f66:	4633      	mov	r3, r6
c0d03f68:	2800      	cmp	r0, #0
c0d03f6a:	d018      	beq.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
          if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d03f6c:	6818      	ldr	r0, [r3, #0]
c0d03f6e:	9901      	ldr	r1, [sp, #4]
c0d03f70:	f7ff ff42 	bl	c0d03df8 <io_seproxyhal_touch_out>
c0d03f74:	e008      	b.n	c0d03f88 <io_seproxyhal_touch_element_callback+0xb4>
c0d03f76:	9800      	ldr	r0, [sp, #0]
        continue;
      }
      */
      
      // callback the hal to notify the component impacted by the user input
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_RELEASE) {
c0d03f78:	2801      	cmp	r0, #1
c0d03f7a:	d009      	beq.n	c0d03f90 <io_seproxyhal_touch_element_callback+0xbc>
c0d03f7c:	2802      	cmp	r0, #2
c0d03f7e:	d10e      	bne.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
        if (io_seproxyhal_touch_tap(&elements[comp_idx], before_display)) {
c0d03f80:	4628      	mov	r0, r5
c0d03f82:	9901      	ldr	r1, [sp, #4]
c0d03f84:	f7ff ff85 	bl	c0d03e92 <io_seproxyhal_touch_tap>
c0d03f88:	4633      	mov	r3, r6
c0d03f8a:	2800      	cmp	r0, #0
c0d03f8c:	d007      	beq.n	c0d03f9e <io_seproxyhal_touch_element_callback+0xca>
c0d03f8e:	e021      	b.n	c0d03fd4 <io_seproxyhal_touch_element_callback+0x100>
          return;
        }
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
c0d03f90:	4628      	mov	r0, r5
c0d03f92:	9901      	ldr	r1, [sp, #4]
c0d03f94:	f7ff ff50 	bl	c0d03e38 <io_seproxyhal_touch_over>
c0d03f98:	4633      	mov	r3, r6
c0d03f9a:	2800      	cmp	r0, #0
c0d03f9c:	d11d      	bne.n	c0d03fda <io_seproxyhal_touch_element_callback+0x106>
void io_seproxyhal_touch_element_callback(const bagl_element_t* elements, unsigned short element_count, unsigned short x, unsigned short y, unsigned char event_kind, bagl_element_callback_t before_display) {
  unsigned char comp_idx;
  unsigned char last_touched_not_released_component_was_in_current_array = 0;

  // find the first empty entry
  for (comp_idx=0; comp_idx < element_count; comp_idx++) {
c0d03f9e:	1c7f      	adds	r7, r7, #1
c0d03fa0:	b2fd      	uxtb	r5, r7
c0d03fa2:	9805      	ldr	r0, [sp, #20]
c0d03fa4:	4285      	cmp	r5, r0
c0d03fa6:	d3a5      	bcc.n	c0d03ef4 <io_seproxyhal_touch_element_callback+0x20>
c0d03fa8:	e000      	b.n	c0d03fac <io_seproxyhal_touch_element_callback+0xd8>
c0d03faa:	4633      	mov	r3, r6
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
    && G_bagl_last_touched_not_released_component != NULL) {
c0d03fac:	9806      	ldr	r0, [sp, #24]
c0d03fae:	0600      	lsls	r0, r0, #24
c0d03fb0:	d00e      	beq.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
c0d03fb2:	6818      	ldr	r0, [r3, #0]
      }
    }
  }

  // if overing out of component or over another component, the out event is sent after the over event of the previous component
  if(last_touched_not_released_component_was_in_current_array 
c0d03fb4:	2800      	cmp	r0, #0
c0d03fb6:	d00b      	beq.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
    && G_bagl_last_touched_not_released_component != NULL) {

    // we won't be able to notify the out, don't do it, in case a diplay refused the dra of the relased element and the position matched another element of the array (in autocomplete for example)
    if (io_seproxyhal_spi_is_status_sent()) {
c0d03fb8:	f000 fe4c 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d03fbc:	2800      	cmp	r0, #0
c0d03fbe:	d107      	bne.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
      return;
    }
    
    if (io_seproxyhal_touch_out(G_bagl_last_touched_not_released_component, before_display)) {
c0d03fc0:	6830      	ldr	r0, [r6, #0]
c0d03fc2:	9901      	ldr	r1, [sp, #4]
c0d03fc4:	f7ff ff18 	bl	c0d03df8 <io_seproxyhal_touch_out>
c0d03fc8:	2800      	cmp	r0, #0
c0d03fca:	d001      	beq.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
c0d03fcc:	2000      	movs	r0, #0
      // ok component out has been emitted
      G_bagl_last_touched_not_released_component = NULL;
c0d03fce:	6030      	str	r0, [r6, #0]
    }
  }

  // not processed
}
c0d03fd0:	b007      	add	sp, #28
c0d03fd2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d03fd4:	2000      	movs	r0, #0
c0d03fd6:	6018      	str	r0, [r3, #0]
c0d03fd8:	e7fa      	b.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
      }
      else if (event_kind == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) {
        // ask for overing
        if (io_seproxyhal_touch_over(&elements[comp_idx], before_display)) {
          // remember the last touched component
          G_bagl_last_touched_not_released_component = (bagl_element_t*)&elements[comp_idx];
c0d03fda:	601d      	str	r5, [r3, #0]
c0d03fdc:	e7f8      	b.n	c0d03fd0 <io_seproxyhal_touch_element_callback+0xfc>
c0d03fde:	46c0      	nop			; (mov r8, r8)
c0d03fe0:	200022e0 	.word	0x200022e0

c0d03fe4 <io_seproxyhal_display_icon>:
  // remaining length of bitmap bits to be displayed
  return len;
}
#endif // SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
c0d03fe4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d03fe6:	b089      	sub	sp, #36	; 0x24
c0d03fe8:	460c      	mov	r4, r1
c0d03fea:	4601      	mov	r1, r0
c0d03fec:	ad02      	add	r5, sp, #8
c0d03fee:	221c      	movs	r2, #28
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
c0d03ff0:	4628      	mov	r0, r5
c0d03ff2:	9201      	str	r2, [sp, #4]
c0d03ff4:	f7ff fccb 	bl	c0d0398e <os_memmove>
  icon_component_mod.width = icon_details->width;
c0d03ff8:	cc06      	ldmia	r4!, {r1, r2}
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d03ffa:	6820      	ldr	r0, [r4, #0]

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
  icon_component_mod.width = icon_details->width;
c0d03ffc:	80e9      	strh	r1, [r5, #6]
  icon_component_mod.height = icon_details->height;
c0d03ffe:	812a      	strh	r2, [r5, #8]
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d04000:	4f19      	ldr	r7, [pc, #100]	; (c0d04068 <io_seproxyhal_display_icon+0x84>)
c0d04002:	2365      	movs	r3, #101	; 0x65
c0d04004:	703b      	strb	r3, [r7, #0]


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d04006:	b289      	uxth	r1, r1
c0d04008:	b292      	uxth	r2, r2
c0d0400a:	434a      	muls	r2, r1
c0d0400c:	4342      	muls	r2, r0
c0d0400e:	0753      	lsls	r3, r2, #29
c0d04010:	08d1      	lsrs	r1, r2, #3
c0d04012:	1c4a      	adds	r2, r1, #1

void io_seproxyhal_display_icon(bagl_component_t* icon_component, bagl_icon_details_t* icon_details) {
  bagl_component_t icon_component_mod;
  // ensure not being out of bounds in the icon component agianst the declared icon real size
  os_memmove(&icon_component_mod, icon_component, sizeof(bagl_component_t));
  icon_component_mod.width = icon_details->width;
c0d04014:	3c08      	subs	r4, #8


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
c0d04016:	2b00      	cmp	r3, #0
c0d04018:	d100      	bne.n	c0d0401c <io_seproxyhal_display_icon+0x38>
c0d0401a:	460a      	mov	r2, r1
c0d0401c:	9200      	str	r2, [sp, #0]
c0d0401e:	2604      	movs	r6, #4
  // component type = ICON, provided bitmap
  // => bitmap transmitted


  // color index size
  unsigned int h = (1<<(icon_details->bpp))*sizeof(unsigned int); 
c0d04020:	4086      	lsls	r6, r0
  // bitmap size
  unsigned int w = ((icon_component->width*icon_component->height*icon_details->bpp)/8)+((icon_component->width*icon_component->height*icon_details->bpp)%8?1:0);
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
c0d04022:	18b0      	adds	r0, r6, r2
                          +w; /* image bitmap size */
c0d04024:	301d      	adds	r0, #29
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
  G_io_seproxyhal_spi_buffer[2] = length;
c0d04026:	70b8      	strb	r0, [r7, #2]
  unsigned short length = sizeof(bagl_component_t)
                          +1 /* bpp */
                          +h /* color index */
                          +w; /* image bitmap size */
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
  G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d04028:	0a00      	lsrs	r0, r0, #8
c0d0402a:	7078      	strb	r0, [r7, #1]
c0d0402c:	2103      	movs	r1, #3
  G_io_seproxyhal_spi_buffer[2] = length;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0402e:	4638      	mov	r0, r7
c0d04030:	f000 fdfa 	bl	c0d04c28 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)icon_component, sizeof(bagl_component_t));
c0d04034:	4628      	mov	r0, r5
c0d04036:	9901      	ldr	r1, [sp, #4]
c0d04038:	f000 fdf6 	bl	c0d04c28 <io_seproxyhal_spi_send>
  G_io_seproxyhal_spi_buffer[0] = icon_details->bpp;
c0d0403c:	68a0      	ldr	r0, [r4, #8]
c0d0403e:	7038      	strb	r0, [r7, #0]
c0d04040:	2101      	movs	r1, #1
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 1);
c0d04042:	4638      	mov	r0, r7
c0d04044:	f000 fdf0 	bl	c0d04c28 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->colors), h);
c0d04048:	68e0      	ldr	r0, [r4, #12]
c0d0404a:	f000 fb8d 	bl	c0d04768 <pic>
c0d0404e:	b2b1      	uxth	r1, r6
c0d04050:	f000 fdea 	bl	c0d04c28 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send((unsigned char*)PIC(icon_details->bitmap), w);
c0d04054:	9800      	ldr	r0, [sp, #0]
c0d04056:	b285      	uxth	r5, r0
c0d04058:	6920      	ldr	r0, [r4, #16]
c0d0405a:	f000 fb85 	bl	c0d04768 <pic>
c0d0405e:	4629      	mov	r1, r5
c0d04060:	f000 fde2 	bl	c0d04c28 <io_seproxyhal_spi_send>
#endif // !SEPROXYHAL_TAG_SCREEN_DISPLAY_RAW_STATUS
}
c0d04064:	b009      	add	sp, #36	; 0x24
c0d04066:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d04068:	20001800 	.word	0x20001800

c0d0406c <io_seproxyhal_display_default>:

void io_seproxyhal_display_default(const bagl_element_t * element) {
c0d0406c:	b570      	push	{r4, r5, r6, lr}
c0d0406e:	4604      	mov	r4, r0
  // process automagically address from rom and from ram
  unsigned int type = (element->component.type & ~(BAGL_FLAG_TOUCHABLE));
c0d04070:	7800      	ldrb	r0, [r0, #0]
c0d04072:	267f      	movs	r6, #127	; 0x7f
c0d04074:	4006      	ands	r6, r0

  // avoid sending another status :), fixes a lot of bugs in the end
  if (io_seproxyhal_spi_is_status_sent()) {
c0d04076:	f000 fded 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d0407a:	2800      	cmp	r0, #0
c0d0407c:	d130      	bne.n	c0d040e0 <io_seproxyhal_display_default+0x74>
c0d0407e:	2e00      	cmp	r6, #0
c0d04080:	d02e      	beq.n	c0d040e0 <io_seproxyhal_display_default+0x74>
    return;
  }

  if (type != BAGL_NONE) {
    if (element->text != NULL) {
c0d04082:	69e0      	ldr	r0, [r4, #28]
c0d04084:	2800      	cmp	r0, #0
c0d04086:	d01d      	beq.n	c0d040c4 <io_seproxyhal_display_default+0x58>
      unsigned int text_adr = PIC((unsigned int)element->text);
c0d04088:	f000 fb6e 	bl	c0d04768 <pic>
c0d0408c:	4605      	mov	r5, r0
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
c0d0408e:	2e05      	cmp	r6, #5
c0d04090:	d102      	bne.n	c0d04098 <io_seproxyhal_display_default+0x2c>
c0d04092:	7ea0      	ldrb	r0, [r4, #26]
c0d04094:	2800      	cmp	r0, #0
c0d04096:	d024      	beq.n	c0d040e2 <io_seproxyhal_display_default+0x76>
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d04098:	4628      	mov	r0, r5
c0d0409a:	f002 fb6b 	bl	c0d06774 <strlen>
c0d0409e:	4606      	mov	r6, r0
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d040a0:	4812      	ldr	r0, [pc, #72]	; (c0d040ec <io_seproxyhal_display_default+0x80>)
c0d040a2:	2165      	movs	r1, #101	; 0x65
c0d040a4:	7001      	strb	r1, [r0, #0]
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
c0d040a6:	4631      	mov	r1, r6
c0d040a8:	311c      	adds	r1, #28
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
        G_io_seproxyhal_spi_buffer[2] = length;
c0d040aa:	7081      	strb	r1, [r0, #2]
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
      }
      else {
        unsigned short length = sizeof(bagl_component_t)+strlen((const char*)text_adr);
        G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
        G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d040ac:	0a09      	lsrs	r1, r1, #8
c0d040ae:	7041      	strb	r1, [r0, #1]
c0d040b0:	2103      	movs	r1, #3
        G_io_seproxyhal_spi_buffer[2] = length;
        io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d040b2:	f000 fdb9 	bl	c0d04c28 <io_seproxyhal_spi_send>
c0d040b6:	211c      	movs	r1, #28
        io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d040b8:	4620      	mov	r0, r4
c0d040ba:	f000 fdb5 	bl	c0d04c28 <io_seproxyhal_spi_send>
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
c0d040be:	b2b1      	uxth	r1, r6
c0d040c0:	4628      	mov	r0, r5
c0d040c2:	e00b      	b.n	c0d040dc <io_seproxyhal_display_default+0x70>
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d040c4:	4809      	ldr	r0, [pc, #36]	; (c0d040ec <io_seproxyhal_display_default+0x80>)
c0d040c6:	2100      	movs	r1, #0
      G_io_seproxyhal_spi_buffer[1] = length>>8;
c0d040c8:	7041      	strb	r1, [r0, #1]
c0d040ca:	2165      	movs	r1, #101	; 0x65
        io_seproxyhal_spi_send((unsigned char*)text_adr, length-sizeof(bagl_component_t));
      }
    }
    else {
      unsigned short length = sizeof(bagl_component_t);
      G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_SCREEN_DISPLAY_STATUS;
c0d040cc:	7001      	strb	r1, [r0, #0]
c0d040ce:	251c      	movs	r5, #28
      G_io_seproxyhal_spi_buffer[1] = length>>8;
      G_io_seproxyhal_spi_buffer[2] = length;
c0d040d0:	7085      	strb	r5, [r0, #2]
c0d040d2:	2103      	movs	r1, #3
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d040d4:	f000 fda8 	bl	c0d04c28 <io_seproxyhal_spi_send>
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
c0d040d8:	4620      	mov	r0, r4
c0d040da:	4629      	mov	r1, r5
c0d040dc:	f000 fda4 	bl	c0d04c28 <io_seproxyhal_spi_send>
    }
  }
}
c0d040e0:	bd70      	pop	{r4, r5, r6, pc}
  if (type != BAGL_NONE) {
    if (element->text != NULL) {
      unsigned int text_adr = PIC((unsigned int)element->text);
      // consider an icon details descriptor is pointed by the context
      if (type == BAGL_ICON && element->component.icon_id == 0) {
        io_seproxyhal_display_icon((bagl_component_t*)&element->component, (bagl_icon_details_t*)text_adr);
c0d040e2:	4620      	mov	r0, r4
c0d040e4:	4629      	mov	r1, r5
c0d040e6:	f7ff ff7d 	bl	c0d03fe4 <io_seproxyhal_display_icon>
      G_io_seproxyhal_spi_buffer[2] = length;
      io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
      io_seproxyhal_spi_send((unsigned char*)&element->component, sizeof(bagl_component_t));
    }
  }
}
c0d040ea:	bd70      	pop	{r4, r5, r6, pc}
c0d040ec:	20001800 	.word	0x20001800

c0d040f0 <io_seproxyhal_button_push>:
  G_io_seproxyhal_spi_buffer[3] = (backlight_percentage?0x80:0)|(flags & 0x7F); // power on
  G_io_seproxyhal_spi_buffer[4] = backlight_percentage;
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 5);
}

void io_seproxyhal_button_push(button_push_callback_t button_callback, unsigned int new_button_mask) {
c0d040f0:	b570      	push	{r4, r5, r6, lr}
  if (button_callback) {
c0d040f2:	2800      	cmp	r0, #0
c0d040f4:	d02d      	beq.n	c0d04152 <io_seproxyhal_button_push+0x62>
c0d040f6:	4604      	mov	r4, r0
    unsigned int button_mask;
    unsigned int button_same_mask_counter;
    // enable speeded up long push
    if (new_button_mask == G_button_mask) {
c0d040f8:	4816      	ldr	r0, [pc, #88]	; (c0d04154 <io_seproxyhal_button_push+0x64>)
c0d040fa:	6802      	ldr	r2, [r0, #0]
c0d040fc:	428a      	cmp	r2, r1
c0d040fe:	d103      	bne.n	c0d04108 <io_seproxyhal_button_push+0x18>
      // each 100ms ~
      G_button_same_mask_counter++;
c0d04100:	4a15      	ldr	r2, [pc, #84]	; (c0d04158 <io_seproxyhal_button_push+0x68>)
c0d04102:	6813      	ldr	r3, [r2, #0]
c0d04104:	1c5b      	adds	r3, r3, #1
c0d04106:	6013      	str	r3, [r2, #0]
    }

    // append the button mask
    button_mask = G_button_mask | new_button_mask;
c0d04108:	6806      	ldr	r6, [r0, #0]
c0d0410a:	430e      	orrs	r6, r1

    // pre reset variable due to os_sched_exit
    button_same_mask_counter = G_button_same_mask_counter;
c0d0410c:	4a12      	ldr	r2, [pc, #72]	; (c0d04158 <io_seproxyhal_button_push+0x68>)
c0d0410e:	6815      	ldr	r5, [r2, #0]

    // reset button mask
    if (new_button_mask == 0) {
c0d04110:	2900      	cmp	r1, #0
c0d04112:	d001      	beq.n	c0d04118 <io_seproxyhal_button_push+0x28>

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
    }
    else {
      G_button_mask = button_mask;
c0d04114:	6006      	str	r6, [r0, #0]
c0d04116:	e005      	b.n	c0d04124 <io_seproxyhal_button_push+0x34>
c0d04118:	2300      	movs	r3, #0
    button_same_mask_counter = G_button_same_mask_counter;

    // reset button mask
    if (new_button_mask == 0) {
      // reset next state when button are released
      G_button_mask = 0;
c0d0411a:	6003      	str	r3, [r0, #0]
      G_button_same_mask_counter=0;
c0d0411c:	6013      	str	r3, [r2, #0]
c0d0411e:	4b0f      	ldr	r3, [pc, #60]	; (c0d0415c <io_seproxyhal_button_push+0x6c>)

      // notify button released event
      button_mask |= BUTTON_EVT_RELEASED;
c0d04120:	1c5b      	adds	r3, r3, #1
c0d04122:	431e      	orrs	r6, r3
    else {
      G_button_mask = button_mask;
    }

    // reset counter when button mask changes
    if (new_button_mask != G_button_mask) {
c0d04124:	6800      	ldr	r0, [r0, #0]
c0d04126:	4288      	cmp	r0, r1
c0d04128:	d001      	beq.n	c0d0412e <io_seproxyhal_button_push+0x3e>
c0d0412a:	2000      	movs	r0, #0
      G_button_same_mask_counter=0;
c0d0412c:	6010      	str	r0, [r2, #0]
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
c0d0412e:	2d08      	cmp	r5, #8
c0d04130:	d30c      	bcc.n	c0d0414c <io_seproxyhal_button_push+0x5c>
c0d04132:	2103      	movs	r1, #3
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d04134:	4628      	mov	r0, r5
c0d04136:	f002 f925 	bl	c0d06384 <__aeabi_uidivmod>
c0d0413a:	2201      	movs	r2, #1
c0d0413c:	0790      	lsls	r0, r2, #30
        button_mask |= BUTTON_EVT_FAST;
c0d0413e:	4330      	orrs	r0, r6
      G_button_same_mask_counter=0;
    }

    if (button_same_mask_counter >= BUTTON_FAST_THRESHOLD_CS) {
      // fast bit when pressing and timing is right
      if ((button_same_mask_counter%BUTTON_FAST_ACTION_CS) == 0) {
c0d04140:	2900      	cmp	r1, #0
c0d04142:	d000      	beq.n	c0d04146 <io_seproxyhal_button_push+0x56>
c0d04144:	4630      	mov	r0, r6
c0d04146:	07d1      	lsls	r1, r2, #31
      }
      */

      // discard the release event after a fastskip has been detected, to avoid strange at release behavior
      // and also to enable user to cancel an operation by starting triggering the fast skip
      button_mask &= ~BUTTON_EVT_RELEASED;
c0d04148:	4388      	bics	r0, r1
c0d0414a:	e000      	b.n	c0d0414e <io_seproxyhal_button_push+0x5e>
c0d0414c:	4630      	mov	r0, r6
    }

    // indicate if button have been released
    button_callback(button_mask, button_same_mask_counter);
c0d0414e:	4629      	mov	r1, r5
c0d04150:	47a0      	blx	r4
  }
}
c0d04152:	bd70      	pop	{r4, r5, r6, pc}
c0d04154:	200022e4 	.word	0x200022e4
c0d04158:	200022e8 	.word	0x200022e8
c0d0415c:	7fffffff 	.word	0x7fffffff

c0d04160 <os_io_seproxyhal_get_app_name_and_version>:
#ifdef HAVE_IO_U2F
u2f_service_t G_io_u2f;
#endif // HAVE_IO_U2F

unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
c0d04160:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04162:	b081      	sub	sp, #4
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d04164:	4e0f      	ldr	r6, [pc, #60]	; (c0d041a4 <os_io_seproxyhal_get_app_name_and_version+0x44>)
c0d04166:	2401      	movs	r4, #1
c0d04168:	7034      	strb	r4, [r6, #0]

  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d0416a:	1cb1      	adds	r1, r6, #2
c0d0416c:	27ff      	movs	r7, #255	; 0xff
c0d0416e:	3750      	adds	r7, #80	; 0x50
c0d04170:	1c7a      	adds	r2, r7, #1
c0d04172:	4620      	mov	r0, r4
c0d04174:	f000 fd40 	bl	c0d04bf8 <os_registry_get_current_app_tag>
c0d04178:	4605      	mov	r5, r0
  G_io_apdu_buffer[tx_len++] = len;
c0d0417a:	7070      	strb	r0, [r6, #1]
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d0417c:	1a3a      	subs	r2, r7, r0
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d0417e:	1837      	adds	r7, r6, r0
  // append app name
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
c0d04180:	1cf9      	adds	r1, r7, #3
c0d04182:	2002      	movs	r0, #2
c0d04184:	f000 fd38 	bl	c0d04bf8 <os_registry_get_current_app_tag>
  G_io_apdu_buffer[tx_len++] = len;
c0d04188:	70b8      	strb	r0, [r7, #2]
c0d0418a:	182d      	adds	r5, r5, r0
unsigned int os_io_seproxyhal_get_app_name_and_version(void) __attribute__((weak));
unsigned int os_io_seproxyhal_get_app_name_and_version(void) {
  unsigned int tx_len, len;
  // build the get app name and version reply
  tx_len = 0;
  G_io_apdu_buffer[tx_len++] = 1; // format ID
c0d0418c:	1976      	adds	r6, r6, r5
  // append app version
  len = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION, G_io_apdu_buffer+tx_len+1, sizeof(G_io_apdu_buffer)-tx_len);
  G_io_apdu_buffer[tx_len++] = len;
  tx_len += len;
  // return OS flags to notify of platform's global state (pin lock etc)
  G_io_apdu_buffer[tx_len++] = 1; // flags length
c0d0418e:	70f4      	strb	r4, [r6, #3]
  G_io_apdu_buffer[tx_len++] = os_flags();
c0d04190:	f000 fd1c 	bl	c0d04bcc <os_flags>
c0d04194:	7130      	strb	r0, [r6, #4]
c0d04196:	2090      	movs	r0, #144	; 0x90

  // status words
  G_io_apdu_buffer[tx_len++] = 0x90;
c0d04198:	7170      	strb	r0, [r6, #5]
c0d0419a:	2000      	movs	r0, #0
  G_io_apdu_buffer[tx_len++] = 0x00;
c0d0419c:	71b0      	strb	r0, [r6, #6]
c0d0419e:	1de8      	adds	r0, r5, #7
  return tx_len;
c0d041a0:	b001      	add	sp, #4
c0d041a2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d041a4:	2000216c 	.word	0x2000216c

c0d041a8 <io_exchange>:
}


unsigned short io_exchange(unsigned char channel, unsigned short tx_len) {
c0d041a8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d041aa:	b085      	sub	sp, #20
c0d041ac:	460b      	mov	r3, r1
c0d041ae:	4601      	mov	r1, r0
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d041b0:	0740      	lsls	r0, r0, #29
c0d041b2:	d007      	beq.n	c0d041c4 <io_exchange+0x1c>
c0d041b4:	460a      	mov	r2, r1
      }
    }
    break;

  default:
    return io_exchange_al(channel, tx_len);
c0d041b6:	b2d0      	uxtb	r0, r2
c0d041b8:	b299      	uxth	r1, r3
c0d041ba:	f7fe fa57 	bl	c0d0266c <io_exchange_al>
  }
}
c0d041be:	b280      	uxth	r0, r0
c0d041c0:	b005      	add	sp, #20
c0d041c2:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d041c4:	2080      	movs	r0, #128	; 0x80
c0d041c6:	9001      	str	r0, [sp, #4]
c0d041c8:	4f6c      	ldr	r7, [pc, #432]	; (c0d0437c <io_exchange+0x1d4>)
c0d041ca:	4e72      	ldr	r6, [pc, #456]	; (c0d04394 <io_exchange+0x1ec>)
c0d041cc:	4c6f      	ldr	r4, [pc, #444]	; (c0d0438c <io_exchange+0x1e4>)
c0d041ce:	460a      	mov	r2, r1
c0d041d0:	9203      	str	r2, [sp, #12]
c0d041d2:	2010      	movs	r0, #16
reply_apdu:
  switch(channel&~(IO_FLAGS)) {
  case CHANNEL_APDU:
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
c0d041d4:	4008      	ands	r0, r1
c0d041d6:	b29d      	uxth	r5, r3
c0d041d8:	2d00      	cmp	r5, #0
c0d041da:	d075      	beq.n	c0d042c8 <io_exchange+0x120>
c0d041dc:	2800      	cmp	r0, #0
c0d041de:	d173      	bne.n	c0d042c8 <io_exchange+0x120>
c0d041e0:	9002      	str	r0, [sp, #8]
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d041e2:	7838      	ldrb	r0, [r7, #0]
c0d041e4:	2808      	cmp	r0, #8
c0d041e6:	9104      	str	r1, [sp, #16]
c0d041e8:	dd1a      	ble.n	c0d04220 <io_exchange+0x78>
c0d041ea:	2809      	cmp	r0, #9
c0d041ec:	d020      	beq.n	c0d04230 <io_exchange+0x88>
c0d041ee:	280a      	cmp	r0, #10
c0d041f0:	d143      	bne.n	c0d0427a <io_exchange+0xd2>
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
            break;

          case APDU_RAW:
            if (tx_len > sizeof(G_io_apdu_buffer)) {
c0d041f2:	4618      	mov	r0, r3
c0d041f4:	4964      	ldr	r1, [pc, #400]	; (c0d04388 <io_exchange+0x1e0>)
c0d041f6:	4008      	ands	r0, r1
c0d041f8:	0840      	lsrs	r0, r0, #1
c0d041fa:	28a9      	cmp	r0, #169	; 0xa9
c0d041fc:	d300      	bcc.n	c0d04200 <io_exchange+0x58>
c0d041fe:	e0ba      	b.n	c0d04376 <io_exchange+0x1ce>
c0d04200:	2053      	movs	r0, #83	; 0x53
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
c0d04202:	7020      	strb	r0, [r4, #0]
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
c0d04204:	70a3      	strb	r3, [r4, #2]
            if (tx_len > sizeof(G_io_apdu_buffer)) {
              THROW(INVALID_PARAMETER);
            }
            // reply the RAW APDU over SEPROXYHAL protocol
            G_io_seproxyhal_spi_buffer[0]  = SEPROXYHAL_TAG_RAPDU;
            G_io_seproxyhal_spi_buffer[1]  = (tx_len)>>8;
c0d04206:	0a18      	lsrs	r0, r3, #8
c0d04208:	7060      	strb	r0, [r4, #1]
c0d0420a:	2103      	movs	r1, #3
            G_io_seproxyhal_spi_buffer[2]  = (tx_len);
            io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 3);
c0d0420c:	4620      	mov	r0, r4
c0d0420e:	f000 fd0b 	bl	c0d04c28 <io_seproxyhal_spi_send>
            io_seproxyhal_spi_send(G_io_apdu_buffer, tx_len);
c0d04212:	485b      	ldr	r0, [pc, #364]	; (c0d04380 <io_exchange+0x1d8>)
c0d04214:	4629      	mov	r1, r5
c0d04216:	f000 fd07 	bl	c0d04c28 <io_seproxyhal_spi_send>
c0d0421a:	2000      	movs	r0, #0

            // isngle packet reply, mark immediate idle
            G_io_apdu_state = APDU_IDLE;
c0d0421c:	7038      	strb	r0, [r7, #0]
c0d0421e:	e03d      	b.n	c0d0429c <io_exchange+0xf4>
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d04220:	2807      	cmp	r0, #7
c0d04222:	d128      	bne.n	c0d04276 <io_exchange+0xce>
            goto break_send;

#ifdef HAVE_USB_APDU
          case APDU_USB_HID:
            // only send, don't perform synchronous reception of the next command (will be done later by the seproxyhal packet processing)
            io_usb_hid_send(io_usb_send_apdu_data, tx_len);
c0d04224:	485c      	ldr	r0, [pc, #368]	; (c0d04398 <io_exchange+0x1f0>)
c0d04226:	4478      	add	r0, pc
c0d04228:	4629      	mov	r1, r5
c0d0422a:	f7ff fc51 	bl	c0d03ad0 <io_usb_hid_send>
c0d0422e:	e035      	b.n	c0d0429c <io_exchange+0xf4>
          // case to handle U2F channels. u2f apdu to be dispatched in the upper layers
          case APDU_U2F:
            // prepare reply, the remaining segments will be pumped during USB/BLE events handling while waiting for the next APDU

            // user presence + counter + rapdu + sw must fit the apdu buffer
            if (1U+ 4U+ tx_len +2U > sizeof(G_io_apdu_buffer)) {
c0d04230:	1de8      	adds	r0, r5, #7
c0d04232:	0840      	lsrs	r0, r0, #1
c0d04234:	28a9      	cmp	r0, #169	; 0xa9
c0d04236:	d300      	bcc.n	c0d0423a <io_exchange+0x92>
c0d04238:	e09d      	b.n	c0d04376 <io_exchange+0x1ce>
              THROW(INVALID_PARAMETER);
            }

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
c0d0423a:	9801      	ldr	r0, [sp, #4]
c0d0423c:	3010      	adds	r0, #16
c0d0423e:	4950      	ldr	r1, [pc, #320]	; (c0d04380 <io_exchange+0x1d8>)
c0d04240:	5548      	strb	r0, [r1, r5]
c0d04242:	1948      	adds	r0, r1, r5
c0d04244:	2500      	movs	r5, #0
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
c0d04246:	7045      	strb	r5, [r0, #1]
            tx_len += 2;
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d04248:	1d48      	adds	r0, r1, #5

            // u2F tunnel needs the status words to be included in the signature response BLOB, do it now.
            // always return 9000 in the signature to avoid error @ transport level in u2f layers. 
            G_io_apdu_buffer[tx_len] = 0x90; //G_io_apdu_buffer[tx_len-2];
            G_io_apdu_buffer[tx_len+1] = 0x00; //G_io_apdu_buffer[tx_len-1];
            tx_len += 2;
c0d0424a:	1c99      	adds	r1, r3, #2
            os_memmove(G_io_apdu_buffer+5, G_io_apdu_buffer, tx_len);
c0d0424c:	b28a      	uxth	r2, r1
c0d0424e:	494c      	ldr	r1, [pc, #304]	; (c0d04380 <io_exchange+0x1d8>)
c0d04250:	9300      	str	r3, [sp, #0]
c0d04252:	f7ff fb9c 	bl	c0d0398e <os_memmove>
c0d04256:	2205      	movs	r2, #5
c0d04258:	4849      	ldr	r0, [pc, #292]	; (c0d04380 <io_exchange+0x1d8>)
            // zeroize user presence and counter
            os_memset(G_io_apdu_buffer, 0, 5);
c0d0425a:	4629      	mov	r1, r5
c0d0425c:	f7ff fb8e 	bl	c0d0397c <os_memset>
            u2f_message_reply(&G_io_u2f, U2F_CMD_MSG, G_io_apdu_buffer, tx_len+5);
c0d04260:	9801      	ldr	r0, [sp, #4]
c0d04262:	1cc0      	adds	r0, r0, #3
c0d04264:	b2c1      	uxtb	r1, r0
c0d04266:	9800      	ldr	r0, [sp, #0]
c0d04268:	1dc0      	adds	r0, r0, #7
c0d0426a:	b283      	uxth	r3, r0
c0d0426c:	4845      	ldr	r0, [pc, #276]	; (c0d04384 <io_exchange+0x1dc>)
c0d0426e:	4a44      	ldr	r2, [pc, #272]	; (c0d04380 <io_exchange+0x1d8>)
c0d04270:	f001 f8be 	bl	c0d053f0 <u2f_message_reply>
c0d04274:	e012      	b.n	c0d0429c <io_exchange+0xf4>
    // TODO work up the spi state machine over the HAL proxy until an APDU is available

    if (tx_len && !(channel&IO_ASYNCH_REPLY)) {
      // until the whole RAPDU is transmitted, send chunks using the current mode for communication
      for (;;) {
        switch(G_io_apdu_state) {
c0d04276:	2800      	cmp	r0, #0
c0d04278:	d07a      	beq.n	c0d04370 <io_exchange+0x1c8>
          default: 
            // delegate to the hal in case of not generic transport mode (or asynch)
            if (io_exchange_al(channel, tx_len) == 0) {
c0d0427a:	9803      	ldr	r0, [sp, #12]
c0d0427c:	b2c0      	uxtb	r0, r0
c0d0427e:	4629      	mov	r1, r5
c0d04280:	f7fe f9f4 	bl	c0d0266c <io_exchange_al>
c0d04284:	2800      	cmp	r0, #0
c0d04286:	d009      	beq.n	c0d0429c <io_exchange+0xf4>
c0d04288:	e072      	b.n	c0d04370 <io_exchange+0x1c8>
        // wait end of reply transmission
        while (G_io_apdu_state != APDU_IDLE) {
#ifdef HAVE_TINY_COROUTINE
          tcr_yield();
#else // HAVE_TINY_COROUTINE
          io_seproxyhal_general_status();
c0d0428a:	f7ff fc5b 	bl	c0d03b44 <io_seproxyhal_general_status>
c0d0428e:	2180      	movs	r1, #128	; 0x80
c0d04290:	2200      	movs	r2, #0
          io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d04292:	4620      	mov	r0, r4
c0d04294:	f000 fcf4 	bl	c0d04c80 <io_seproxyhal_spi_recv>
          // if packet is not well formed, then too bad ...
          io_seproxyhal_handle_event();
c0d04298:	f7ff fd38 	bl	c0d03d0c <io_seproxyhal_handle_event>
        continue;

      break_send:

        // wait end of reply transmission
        while (G_io_apdu_state != APDU_IDLE) {
c0d0429c:	7838      	ldrb	r0, [r7, #0]
c0d0429e:	2800      	cmp	r0, #0
c0d042a0:	d1f3      	bne.n	c0d0428a <io_exchange+0xe2>
c0d042a2:	2000      	movs	r0, #0
          io_seproxyhal_handle_event();
#endif // HAVE_TINY_COROUTINE
        }

        // reset apdu state
        G_io_apdu_state = APDU_IDLE;
c0d042a4:	7038      	strb	r0, [r7, #0]
        G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d042a6:	493a      	ldr	r1, [pc, #232]	; (c0d04390 <io_exchange+0x1e8>)
c0d042a8:	7008      	strb	r0, [r1, #0]

        G_io_apdu_length = 0;
c0d042aa:	8030      	strh	r0, [r6, #0]

        // continue sending commands, don't issue status yet
        if (channel & IO_RETURN_AFTER_TX) {
c0d042ac:	9904      	ldr	r1, [sp, #16]
c0d042ae:	0689      	lsls	r1, r1, #26
c0d042b0:	d485      	bmi.n	c0d041be <io_exchange+0x16>
          return 0;
        }
        // acknowledge the write request (general status OK) and no more command to follow (wait until another APDU container is received to continue unwrapping)
        io_seproxyhal_general_status();
c0d042b2:	f7ff fc47 	bl	c0d03b44 <io_seproxyhal_general_status>
c0d042b6:	9904      	ldr	r1, [sp, #16]
        break;
      }

      // perform reset after io exchange
      if (channel & IO_RESET_AFTER_REPLIED) {
c0d042b8:	0608      	lsls	r0, r1, #24
c0d042ba:	9802      	ldr	r0, [sp, #8]
c0d042bc:	d504      	bpl.n	c0d042c8 <io_exchange+0x120>
c0d042be:	2001      	movs	r0, #1
        os_sched_exit(1);
c0d042c0:	f000 fc58 	bl	c0d04b74 <os_sched_exit>
c0d042c4:	9802      	ldr	r0, [sp, #8]
c0d042c6:	9904      	ldr	r1, [sp, #16]
        //reset();
      }
    }

#ifndef HAVE_TINY_COROUTINE
    if (!(channel&IO_ASYNCH_REPLY)) {
c0d042c8:	2800      	cmp	r0, #0
c0d042ca:	d105      	bne.n	c0d042d8 <io_exchange+0x130>
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
c0d042cc:	0648      	lsls	r0, r1, #25
c0d042ce:	d44c      	bmi.n	c0d0436a <io_exchange+0x1c2>
c0d042d0:	2000      	movs	r0, #0
        // return apdu data - header
        return G_io_apdu_length-5;
      }

      // reply has ended, proceed to next apdu reception (reset status only after asynch reply)
      G_io_apdu_state = APDU_IDLE;
c0d042d2:	7038      	strb	r0, [r7, #0]
      G_io_apdu_media = IO_APDU_MEDIA_NONE;
c0d042d4:	492e      	ldr	r1, [pc, #184]	; (c0d04390 <io_exchange+0x1e8>)
c0d042d6:	7008      	strb	r0, [r1, #0]
c0d042d8:	2000      	movs	r0, #0
c0d042da:	8030      	strh	r0, [r6, #0]
#ifdef HAVE_TINY_COROUTINE
      // give back hand to the seph task which interprets all incoming events first
      tcr_yield();
#else // HAVE_TINY_COROUTINE

      if (!io_seproxyhal_spi_is_status_sent()) {
c0d042dc:	f000 fcba 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d042e0:	2800      	cmp	r0, #0
c0d042e2:	d101      	bne.n	c0d042e8 <io_exchange+0x140>
        io_seproxyhal_general_status();
c0d042e4:	f7ff fc2e 	bl	c0d03b44 <io_seproxyhal_general_status>
c0d042e8:	2180      	movs	r1, #128	; 0x80
c0d042ea:	2500      	movs	r5, #0
      }
      // wait until a SPI packet is available
      // NOTE: on ST31, dual wait ISO & RF (ISO instead of SPI)
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);
c0d042ec:	4620      	mov	r0, r4
c0d042ee:	462a      	mov	r2, r5
c0d042f0:	f000 fcc6 	bl	c0d04c80 <io_seproxyhal_spi_recv>

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
c0d042f4:	2802      	cmp	r0, #2
c0d042f6:	d806      	bhi.n	c0d04306 <io_exchange+0x15e>
c0d042f8:	78a1      	ldrb	r1, [r4, #2]
c0d042fa:	7862      	ldrb	r2, [r4, #1]
c0d042fc:	0212      	lsls	r2, r2, #8
c0d042fe:	1851      	adds	r1, r2, r1
c0d04300:	1ec0      	subs	r0, r0, #3
c0d04302:	4288      	cmp	r0, r1
c0d04304:	d108      	bne.n	c0d04318 <io_exchange+0x170>
        G_io_apdu_state = APDU_IDLE;
        G_io_apdu_length = 0;
        continue;
      }

        io_seproxyhal_handle_event();
c0d04306:	f7ff fd01 	bl	c0d03d0c <io_seproxyhal_handle_event>
#endif // HAVE_TINY_COROUTINE

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
c0d0430a:	7838      	ldrb	r0, [r7, #0]
c0d0430c:	2800      	cmp	r0, #0
c0d0430e:	d0e5      	beq.n	c0d042dc <io_exchange+0x134>
c0d04310:	8830      	ldrh	r0, [r6, #0]
c0d04312:	2800      	cmp	r0, #0
c0d04314:	d0e2      	beq.n	c0d042dc <io_exchange+0x134>
c0d04316:	e002      	b.n	c0d0431e <io_exchange+0x176>
c0d04318:	2000      	movs	r0, #0
      rx_len = io_seproxyhal_spi_recv(G_io_seproxyhal_spi_buffer, sizeof(G_io_seproxyhal_spi_buffer), 0);

      // can't process split TLV, continue
      if (rx_len < 3 && rx_len-3 != U2(G_io_seproxyhal_spi_buffer[1],G_io_seproxyhal_spi_buffer[2])) {
        LOG("invalid TLV format\n");
        G_io_apdu_state = APDU_IDLE;
c0d0431a:	7038      	strb	r0, [r7, #0]
c0d0431c:	e7dd      	b.n	c0d042da <io_exchange+0x132>

      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
c0d0431e:	491f      	ldr	r1, [pc, #124]	; (c0d0439c <io_exchange+0x1f4>)
c0d04320:	4479      	add	r1, pc
c0d04322:	2204      	movs	r2, #4
c0d04324:	4816      	ldr	r0, [pc, #88]	; (c0d04380 <io_exchange+0x1d8>)
c0d04326:	f7ff fbed 	bl	c0d03b04 <os_memcmp>
c0d0432a:	2800      	cmp	r0, #0
c0d0432c:	d012      	beq.n	c0d04354 <io_exchange+0x1ac>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
c0d0432e:	491c      	ldr	r1, [pc, #112]	; (c0d043a0 <io_exchange+0x1f8>)
c0d04330:	4479      	add	r1, pc
c0d04332:	2204      	movs	r2, #4
c0d04334:	4812      	ldr	r0, [pc, #72]	; (c0d04380 <io_exchange+0x1d8>)
c0d04336:	f7ff fbe5 	bl	c0d03b04 <os_memcmp>
c0d0433a:	2800      	cmp	r0, #0
c0d0433c:	d113      	bne.n	c0d04366 <io_exchange+0x1be>
c0d0433e:	4810      	ldr	r0, [pc, #64]	; (c0d04380 <io_exchange+0x1d8>)
c0d04340:	4602      	mov	r2, r0
          tx_len = 0;
          G_io_apdu_buffer[tx_len++] = 0x90;
          G_io_apdu_buffer[tx_len++] = 0x00;
c0d04342:	7045      	strb	r5, [r0, #1]
c0d04344:	9901      	ldr	r1, [sp, #4]
          goto reply_apdu; 
        }
        // exit app after replied
        else if (os_memcmp(G_io_apdu_buffer, "\xB0\xA7\x00\x00", 4) == 0) {
          tx_len = 0;
          G_io_apdu_buffer[tx_len++] = 0x90;
c0d04346:	4608      	mov	r0, r1
c0d04348:	3010      	adds	r0, #16
c0d0434a:	7010      	strb	r0, [r2, #0]
c0d0434c:	9a03      	ldr	r2, [sp, #12]
          G_io_apdu_buffer[tx_len++] = 0x00;
          // exit app after replied
          channel |= IO_RESET_AFTER_REPLIED;
c0d0434e:	430a      	orrs	r2, r1
c0d04350:	2302      	movs	r3, #2
c0d04352:	e003      	b.n	c0d0435c <io_exchange+0x1b4>
      // an apdu has been received asynchroneously, return it
      if (G_io_apdu_state != APDU_IDLE && G_io_apdu_length > 0) {
        // handle reserved apdus
        // get name and version
        if (os_memcmp(G_io_apdu_buffer, "\xB0\x01\x00\x00", 4) == 0) {
          tx_len = os_io_seproxyhal_get_app_name_and_version();
c0d04354:	f7ff ff04 	bl	c0d04160 <os_io_seproxyhal_get_app_name_and_version>
c0d04358:	4603      	mov	r3, r0
c0d0435a:	2200      	movs	r2, #0
  }
  after_debug:
#endif // DEBUG_APDU

reply_apdu:
  switch(channel&~(IO_FLAGS)) {
c0d0435c:	b2d1      	uxtb	r1, r2
c0d0435e:	0750      	lsls	r0, r2, #29
c0d04360:	d100      	bne.n	c0d04364 <io_exchange+0x1bc>
c0d04362:	e735      	b.n	c0d041d0 <io_exchange+0x28>
c0d04364:	e727      	b.n	c0d041b6 <io_exchange+0xe>
          // disable 'return after tx' and 'asynch reply' flags
          channel &= ~IO_FLAGS;
          goto reply_apdu; 
        }
#endif // HAVE_BOLOS_WITH_VIRGIN_ATTESTATION
        return G_io_apdu_length;
c0d04366:	8830      	ldrh	r0, [r6, #0]
c0d04368:	e729      	b.n	c0d041be <io_exchange+0x16>
    if (!(channel&IO_ASYNCH_REPLY)) {
      
      // already received the data of the apdu when received the whole apdu
      if ((channel & (CHANNEL_APDU|IO_RECEIVE_DATA)) == (CHANNEL_APDU|IO_RECEIVE_DATA)) {
        // return apdu data - header
        return G_io_apdu_length-5;
c0d0436a:	8830      	ldrh	r0, [r6, #0]
c0d0436c:	1f40      	subs	r0, r0, #5
c0d0436e:	e726      	b.n	c0d041be <io_exchange+0x16>
c0d04370:	2009      	movs	r0, #9
            if (io_exchange_al(channel, tx_len) == 0) {
              goto break_send;
            }
          case APDU_IDLE:
            LOG("invalid state for APDU reply\n");
            THROW(INVALID_STATE);
c0d04372:	f7ff fbdb 	bl	c0d03b2c <os_longjmp>
c0d04376:	2002      	movs	r0, #2
c0d04378:	f7ff fbd8 	bl	c0d03b2c <os_longjmp>
c0d0437c:	200022dc 	.word	0x200022dc
c0d04380:	2000216c 	.word	0x2000216c
c0d04384:	200022ec 	.word	0x200022ec
c0d04388:	0000fffe 	.word	0x0000fffe
c0d0438c:	20001800 	.word	0x20001800
c0d04390:	200022c8 	.word	0x200022c8
c0d04394:	200022de 	.word	0x200022de
c0d04398:	fffffa83 	.word	0xfffffa83
c0d0439c:	000034d8 	.word	0x000034d8
c0d043a0:	000034cd 	.word	0x000034cd

c0d043a4 <ux_menu_element_preprocessor>:
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
} 

const bagl_element_t* ux_menu_element_preprocessor(const bagl_element_t* element) {
c0d043a4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d043a6:	b081      	sub	sp, #4
c0d043a8:	4607      	mov	r7, r0
  //todo avoid center alignment when text_x or icon_x AND text_x are not 0
  os_memmove(&ux_menu.tmp_element, element, sizeof(bagl_element_t));
c0d043aa:	4c5d      	ldr	r4, [pc, #372]	; (c0d04520 <ux_menu_element_preprocessor+0x17c>)
c0d043ac:	4625      	mov	r5, r4
c0d043ae:	3514      	adds	r5, #20
c0d043b0:	2238      	movs	r2, #56	; 0x38
c0d043b2:	4628      	mov	r0, r5
c0d043b4:	4639      	mov	r1, r7
c0d043b6:	f7ff faea 	bl	c0d0398e <os_memmove>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d043ba:	6921      	ldr	r1, [r4, #16]
const bagl_element_t* ux_menu_element_preprocessor(const bagl_element_t* element) {
  //todo avoid center alignment when text_x or icon_x AND text_x are not 0
  os_memmove(&ux_menu.tmp_element, element, sizeof(bagl_element_t));

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d043bc:	68a0      	ldr	r0, [r4, #8]
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d043be:	2900      	cmp	r1, #0
c0d043c0:	d003      	beq.n	c0d043ca <ux_menu_element_preprocessor+0x26>
    return ux_menu.menu_iterator(entry_idx);
c0d043c2:	4788      	blx	r1
c0d043c4:	4603      	mov	r3, r0

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
c0d043c6:	68a0      	ldr	r0, [r4, #8]
c0d043c8:	e003      	b.n	c0d043d2 <ux_menu_element_preprocessor+0x2e>
c0d043ca:	211c      	movs	r1, #28

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d043cc:	4341      	muls	r1, r0
c0d043ce:	6822      	ldr	r2, [r4, #0]
c0d043d0:	1853      	adds	r3, r2, r1
c0d043d2:	2600      	movs	r6, #0

  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
c0d043d4:	2800      	cmp	r0, #0
c0d043d6:	d010      	beq.n	c0d043fa <ux_menu_element_preprocessor+0x56>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d043d8:	6922      	ldr	r2, [r4, #16]
  // ask the current entry first, to setup other entries
  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
c0d043da:	1e41      	subs	r1, r0, #1
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d043dc:	2a00      	cmp	r2, #0
c0d043de:	d00f      	beq.n	c0d04400 <ux_menu_element_preprocessor+0x5c>
    return ux_menu.menu_iterator(entry_idx);
c0d043e0:	4608      	mov	r0, r1
c0d043e2:	9700      	str	r7, [sp, #0]
c0d043e4:	4637      	mov	r7, r6
c0d043e6:	462e      	mov	r6, r5
c0d043e8:	461d      	mov	r5, r3
c0d043ea:	4790      	blx	r2
c0d043ec:	462b      	mov	r3, r5
c0d043ee:	4635      	mov	r5, r6
c0d043f0:	463e      	mov	r6, r7
c0d043f2:	9f00      	ldr	r7, [sp, #0]
c0d043f4:	4602      	mov	r2, r0
  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
c0d043f6:	68a0      	ldr	r0, [r4, #8]
c0d043f8:	e006      	b.n	c0d04408 <ux_menu_element_preprocessor+0x64>
c0d043fa:	4630      	mov	r0, r6
c0d043fc:	4632      	mov	r2, r6
c0d043fe:	e003      	b.n	c0d04408 <ux_menu_element_preprocessor+0x64>
c0d04400:	221c      	movs	r2, #28

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
    return ux_menu.menu_iterator(entry_idx);
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d04402:	434a      	muls	r2, r1
c0d04404:	6821      	ldr	r1, [r4, #0]
c0d04406:	188a      	adds	r2, r1, r2
  const ux_menu_entry_t* previous_entry = NULL;
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
c0d04408:	6861      	ldr	r1, [r4, #4]
c0d0440a:	1e49      	subs	r1, r1, #1
c0d0440c:	4288      	cmp	r0, r1
c0d0440e:	d210      	bcs.n	c0d04432 <ux_menu_element_preprocessor+0x8e>
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04410:	6921      	ldr	r1, [r4, #16]
  if (ux_menu.current_entry) {
    previous_entry = ux_menu_get_entry(ux_menu.current_entry-1);
  }
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
c0d04412:	1c40      	adds	r0, r0, #1
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04414:	2900      	cmp	r1, #0
c0d04416:	d008      	beq.n	c0d0442a <ux_menu_element_preprocessor+0x86>
c0d04418:	9500      	str	r5, [sp, #0]
c0d0441a:	461d      	mov	r5, r3
c0d0441c:	4616      	mov	r6, r2
    return ux_menu.menu_iterator(entry_idx);
c0d0441e:	4788      	blx	r1
c0d04420:	4632      	mov	r2, r6
c0d04422:	462b      	mov	r3, r5
c0d04424:	9d00      	ldr	r5, [sp, #0]
c0d04426:	4606      	mov	r6, r0
c0d04428:	e003      	b.n	c0d04432 <ux_menu_element_preprocessor+0x8e>
c0d0442a:	211c      	movs	r1, #28
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d0442c:	4341      	muls	r1, r0
c0d0442e:	6820      	ldr	r0, [r4, #0]
c0d04430:	1846      	adds	r6, r0, r1
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04432:	7878      	ldrb	r0, [r7, #1]
c0d04434:	2840      	cmp	r0, #64	; 0x40
c0d04436:	dc0a      	bgt.n	c0d0444e <ux_menu_element_preprocessor+0xaa>
c0d04438:	2820      	cmp	r0, #32
c0d0443a:	dc21      	bgt.n	c0d04480 <ux_menu_element_preprocessor+0xdc>
c0d0443c:	2810      	cmp	r0, #16
c0d0443e:	d032      	beq.n	c0d044a6 <ux_menu_element_preprocessor+0x102>
c0d04440:	2820      	cmp	r0, #32
c0d04442:	d162      	bne.n	c0d0450a <ux_menu_element_preprocessor+0x166>
      if (current_entry->icon_x) {
        ux_menu.tmp_element.component.x = current_entry->icon_x;
      }
      break;
    case 0x20:
      if (current_entry->line2 != NULL) {
c0d04444:	6959      	ldr	r1, [r3, #20]
c0d04446:	2000      	movs	r0, #0
c0d04448:	2900      	cmp	r1, #0
c0d0444a:	d166      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d0444c:	e04e      	b.n	c0d044ec <ux_menu_element_preprocessor+0x148>
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d0444e:	2880      	cmp	r0, #128	; 0x80
c0d04450:	dc20      	bgt.n	c0d04494 <ux_menu_element_preprocessor+0xf0>
c0d04452:	2841      	cmp	r0, #65	; 0x41
c0d04454:	d030      	beq.n	c0d044b8 <ux_menu_element_preprocessor+0x114>
c0d04456:	2842      	cmp	r0, #66	; 0x42
c0d04458:	d157      	bne.n	c0d0450a <ux_menu_element_preprocessor+0x166>
      }
      ux_menu.tmp_element.text = previous_entry->line1;
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
c0d0445a:	6959      	ldr	r1, [r3, #20]
c0d0445c:	2000      	movs	r0, #0
        || current_entry->icon != NULL
c0d0445e:	2900      	cmp	r1, #0
c0d04460:	d15b      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d04462:	68d9      	ldr	r1, [r3, #12]
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
c0d04464:	2900      	cmp	r1, #0
c0d04466:	d158      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d04468:	6862      	ldr	r2, [r4, #4]
c0d0446a:	1e51      	subs	r1, r2, #1
        || ux_menu.menu_entries_count == 1
c0d0446c:	2a01      	cmp	r2, #1
c0d0446e:	d054      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d04470:	68a2      	ldr	r2, [r4, #8]
c0d04472:	428a      	cmp	r2, r1
c0d04474:	d051      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        || next_entry->icon != NULL) {
c0d04476:	68f1      	ldr	r1, [r6, #12]
      }
      ux_menu.tmp_element.text = previous_entry->line1;
      break;
    // next setting name
    case 0x42:
      if (current_entry->line2 != NULL 
c0d04478:	2900      	cmp	r1, #0
c0d0447a:	d14e      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        || ux_menu.current_entry == ux_menu.menu_entries_count-1
        || ux_menu.menu_entries_count == 1
        || next_entry->icon != NULL) {
        return NULL;
      }
      ux_menu.tmp_element.text = next_entry->line1;
c0d0447c:	6930      	ldr	r0, [r6, #16]
c0d0447e:	e02f      	b.n	c0d044e0 <ux_menu_element_preprocessor+0x13c>
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04480:	2821      	cmp	r0, #33	; 0x21
c0d04482:	d02f      	beq.n	c0d044e4 <ux_menu_element_preprocessor+0x140>
c0d04484:	2822      	cmp	r0, #34	; 0x22
c0d04486:	d140      	bne.n	c0d0450a <ux_menu_element_preprocessor+0x166>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line1;
      goto adjust_text_x;
    case 0x22:
      if (current_entry->line2 == NULL) {
c0d04488:	6959      	ldr	r1, [r3, #20]
c0d0448a:	2000      	movs	r0, #0
c0d0448c:	2900      	cmp	r1, #0
c0d0448e:	d044      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line2;
c0d04490:	6321      	str	r1, [r4, #48]	; 0x30
c0d04492:	e02d      	b.n	c0d044f0 <ux_menu_element_preprocessor+0x14c>
  const ux_menu_entry_t* next_entry = NULL;
  if (ux_menu.current_entry < ux_menu.menu_entries_count-1) {
    next_entry = ux_menu_get_entry(ux_menu.current_entry+1);
  }

  switch(element->component.userid) {
c0d04494:	2882      	cmp	r0, #130	; 0x82
c0d04496:	d032      	beq.n	c0d044fe <ux_menu_element_preprocessor+0x15a>
c0d04498:	2881      	cmp	r0, #129	; 0x81
c0d0449a:	d136      	bne.n	c0d0450a <ux_menu_element_preprocessor+0x166>
    case 0x81:
      if (ux_menu.current_entry == 0) {
c0d0449c:	68a1      	ldr	r1, [r4, #8]
c0d0449e:	2000      	movs	r0, #0
c0d044a0:	2900      	cmp	r1, #0
c0d044a2:	d132      	bne.n	c0d0450a <ux_menu_element_preprocessor+0x166>
c0d044a4:	e039      	b.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        return NULL;
      }
      ux_menu.tmp_element.text = next_entry->line1;
      break;
    case 0x10:
      if (current_entry->icon == NULL) {
c0d044a6:	68d9      	ldr	r1, [r3, #12]
c0d044a8:	2000      	movs	r0, #0
c0d044aa:	2900      	cmp	r1, #0
c0d044ac:	d035      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        return NULL;
      }
      ux_menu.tmp_element.text = (const char*)current_entry->icon;
c0d044ae:	6321      	str	r1, [r4, #48]	; 0x30
      if (current_entry->icon_x) {
c0d044b0:	7e58      	ldrb	r0, [r3, #25]
c0d044b2:	2800      	cmp	r0, #0
c0d044b4:	d121      	bne.n	c0d044fa <ux_menu_element_preprocessor+0x156>
c0d044b6:	e028      	b.n	c0d0450a <ux_menu_element_preprocessor+0x166>
        return NULL;
      }
      break;
    // previous setting name
    case 0x41:
      if (current_entry->line2 != NULL 
c0d044b8:	6959      	ldr	r1, [r3, #20]
c0d044ba:	2000      	movs	r0, #0
        || current_entry->icon != NULL
c0d044bc:	2900      	cmp	r1, #0
c0d044be:	d12c      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d044c0:	68d9      	ldr	r1, [r3, #12]
        || ux_menu.current_entry == 0
c0d044c2:	2900      	cmp	r1, #0
c0d044c4:	d129      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d044c6:	68a1      	ldr	r1, [r4, #8]
c0d044c8:	2900      	cmp	r1, #0
c0d044ca:	d026      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d044cc:	6861      	ldr	r1, [r4, #4]
c0d044ce:	2901      	cmp	r1, #1
c0d044d0:	d023      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        || ux_menu.menu_entries_count == 1 
        || previous_entry->icon != NULL
c0d044d2:	68d1      	ldr	r1, [r2, #12]
        || previous_entry->line2 != NULL) {
c0d044d4:	2900      	cmp	r1, #0
c0d044d6:	d120      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d044d8:	6951      	ldr	r1, [r2, #20]
        return NULL;
      }
      break;
    // previous setting name
    case 0x41:
      if (current_entry->line2 != NULL 
c0d044da:	2900      	cmp	r1, #0
c0d044dc:	d11d      	bne.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        || ux_menu.menu_entries_count == 1 
        || previous_entry->icon != NULL
        || previous_entry->line2 != NULL) {
        return 0;
      }
      ux_menu.tmp_element.text = previous_entry->line1;
c0d044de:	6910      	ldr	r0, [r2, #16]
c0d044e0:	6320      	str	r0, [r4, #48]	; 0x30
c0d044e2:	e012      	b.n	c0d0450a <ux_menu_element_preprocessor+0x166>
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line1;
      goto adjust_text_x;
    case 0x21:
      if (current_entry->line2 == NULL) {
c0d044e4:	6959      	ldr	r1, [r3, #20]
c0d044e6:	2000      	movs	r0, #0
c0d044e8:	2900      	cmp	r1, #0
c0d044ea:	d016      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
c0d044ec:	6918      	ldr	r0, [r3, #16]
c0d044ee:	6320      	str	r0, [r4, #48]	; 0x30
      if (current_entry->line2 == NULL) {
        return NULL;
      }
      ux_menu.tmp_element.text = current_entry->line2;
    adjust_text_x:
      if (current_entry->text_x) {
c0d044f0:	7e18      	ldrb	r0, [r3, #24]
c0d044f2:	2800      	cmp	r0, #0
c0d044f4:	d009      	beq.n	c0d0450a <ux_menu_element_preprocessor+0x166>
c0d044f6:	2108      	movs	r1, #8
        ux_menu.tmp_element.component.x = current_entry->text_x;
        // discard the 'center' flag
        ux_menu.tmp_element.component.font_id = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px;
c0d044f8:	85a1      	strh	r1, [r4, #44]	; 0x2c
c0d044fa:	82e0      	strh	r0, [r4, #22]
c0d044fc:	e005      	b.n	c0d0450a <ux_menu_element_preprocessor+0x166>
      if (ux_menu.current_entry == 0) {
        return NULL;
      }
      break;
    case 0x82:
      if (ux_menu.current_entry == ux_menu.menu_entries_count-1) {
c0d044fe:	6860      	ldr	r0, [r4, #4]
c0d04500:	68a1      	ldr	r1, [r4, #8]
c0d04502:	1e42      	subs	r2, r0, #1
c0d04504:	2000      	movs	r0, #0
c0d04506:	4291      	cmp	r1, r2
c0d04508:	d007      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
        ux_menu.tmp_element.component.font_id = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px;
      }
      break;
  }
  // ensure prepro agrees to the element to be displayed
  if (ux_menu.menu_entry_preprocessor) {
c0d0450a:	68e2      	ldr	r2, [r4, #12]
c0d0450c:	2a00      	cmp	r2, #0
c0d0450e:	4628      	mov	r0, r5
c0d04510:	d003      	beq.n	c0d0451a <ux_menu_element_preprocessor+0x176>
    // menu is denied by the menu entry preprocessor
    return ux_menu.menu_entry_preprocessor(current_entry, &ux_menu.tmp_element);
c0d04512:	3414      	adds	r4, #20
c0d04514:	4618      	mov	r0, r3
c0d04516:	4621      	mov	r1, r4
c0d04518:	4790      	blx	r2
  }

  return &ux_menu.tmp_element;
}
c0d0451a:	b001      	add	sp, #4
c0d0451c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0451e:	46c0      	nop			; (mov r8, r8)
c0d04520:	20002324 	.word	0x20002324

c0d04524 <ux_menu_elements_button>:

unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
c0d04524:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04526:	b081      	sub	sp, #4
c0d04528:	4605      	mov	r5, r0
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d0452a:	4f3c      	ldr	r7, [pc, #240]	; (c0d0461c <ux_menu_elements_button+0xf8>)
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d0452c:	6939      	ldr	r1, [r7, #16]
}

unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);
c0d0452e:	68b8      	ldr	r0, [r7, #8]
  {{BAGL_LABELINE                       , 0x22,  14,  26, 100,  12, 0, 0, 0        , 0xFFFFFF, 0x000000, BAGL_FONT_OPEN_SANS_EXTRABOLD_11px|BAGL_FONT_ALIGNMENT_CENTER, 0  }, NULL, 0, 0, 0, NULL, NULL, NULL },

};

const ux_menu_entry_t* ux_menu_get_entry (unsigned int entry_idx) {
  if (ux_menu.menu_iterator) {
c0d04530:	2900      	cmp	r1, #0
c0d04532:	d002      	beq.n	c0d0453a <ux_menu_elements_button+0x16>
    return ux_menu.menu_iterator(entry_idx);
c0d04534:	4788      	blx	r1
c0d04536:	4606      	mov	r6, r0
c0d04538:	e003      	b.n	c0d04542 <ux_menu_elements_button+0x1e>
c0d0453a:	211c      	movs	r1, #28
  } 
  return &ux_menu.menu_entries[entry_idx];
c0d0453c:	4341      	muls	r1, r0
c0d0453e:	6838      	ldr	r0, [r7, #0]
c0d04540:	1846      	adds	r6, r0, r1
c0d04542:	2401      	movs	r4, #1
c0d04544:	4836      	ldr	r0, [pc, #216]	; (c0d04620 <ux_menu_elements_button+0xfc>)
unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  switch (button_mask) {
c0d04546:	4285      	cmp	r5, r0
c0d04548:	dd14      	ble.n	c0d04574 <ux_menu_elements_button+0x50>
c0d0454a:	4836      	ldr	r0, [pc, #216]	; (c0d04624 <ux_menu_elements_button+0x100>)
c0d0454c:	4285      	cmp	r5, r0
c0d0454e:	d016      	beq.n	c0d0457e <ux_menu_elements_button+0x5a>
c0d04550:	4835      	ldr	r0, [pc, #212]	; (c0d04628 <ux_menu_elements_button+0x104>)
c0d04552:	4285      	cmp	r5, r0
c0d04554:	d01b      	beq.n	c0d0458e <ux_menu_elements_button+0x6a>
c0d04556:	4835      	ldr	r0, [pc, #212]	; (c0d0462c <ux_menu_elements_button+0x108>)
c0d04558:	4285      	cmp	r5, r0
c0d0455a:	d15c      	bne.n	c0d04616 <ux_menu_elements_button+0xf2>
    // enter menu or exit menu
    case BUTTON_EVT_RELEASED|BUTTON_LEFT|BUTTON_RIGHT:
      // menu is priority 1
      if (current_entry->menu) {
c0d0455c:	6830      	ldr	r0, [r6, #0]
c0d0455e:	2800      	cmp	r0, #0
c0d04560:	d050      	beq.n	c0d04604 <ux_menu_elements_button+0xe0>
        // use userid as the pointer to current entry in the parent menu
        UX_MENU_DISPLAY(current_entry->userid, (const ux_menu_entry_t*)PIC(current_entry->menu), ux_menu.menu_entry_preprocessor);
c0d04562:	68b4      	ldr	r4, [r6, #8]
c0d04564:	f000 f900 	bl	c0d04768 <pic>
c0d04568:	4601      	mov	r1, r0
c0d0456a:	68fa      	ldr	r2, [r7, #12]
c0d0456c:	4620      	mov	r0, r4
c0d0456e:	f000 f86b 	bl	c0d04648 <ux_menu_display>
c0d04572:	e04f      	b.n	c0d04614 <ux_menu_elements_button+0xf0>
c0d04574:	492e      	ldr	r1, [pc, #184]	; (c0d04630 <ux_menu_elements_button+0x10c>)
unsigned int ux_menu_elements_button (unsigned int button_mask, unsigned int button_mask_counter) {
  UNUSED(button_mask_counter);

  const ux_menu_entry_t* current_entry = ux_menu_get_entry(ux_menu.current_entry);

  switch (button_mask) {
c0d04576:	428d      	cmp	r5, r1
c0d04578:	d009      	beq.n	c0d0458e <ux_menu_elements_button+0x6a>
c0d0457a:	4285      	cmp	r5, r0
c0d0457c:	d14b      	bne.n	c0d04616 <ux_menu_elements_button+0xf2>
      goto redraw;

    case BUTTON_EVT_FAST|BUTTON_RIGHT:
    case BUTTON_EVT_RELEASED|BUTTON_RIGHT:
      // entry 0 is the number of entries in the menu list
      if (ux_menu.current_entry >= ux_menu.menu_entries_count-1) {
c0d0457e:	6879      	ldr	r1, [r7, #4]
c0d04580:	68b8      	ldr	r0, [r7, #8]
c0d04582:	1e49      	subs	r1, r1, #1
c0d04584:	2400      	movs	r4, #0
c0d04586:	4288      	cmp	r0, r1
c0d04588:	d245      	bcs.n	c0d04616 <ux_menu_elements_button+0xf2>
        return 0;
      }
      ux_menu.current_entry++;
c0d0458a:	1c40      	adds	r0, r0, #1
c0d0458c:	e004      	b.n	c0d04598 <ux_menu_elements_button+0x74>
      break;

    case BUTTON_EVT_FAST|BUTTON_LEFT:
    case BUTTON_EVT_RELEASED|BUTTON_LEFT:
      // entry 0 is the number of entries in the menu list
      if (ux_menu.current_entry == 0) {
c0d0458e:	68b8      	ldr	r0, [r7, #8]
c0d04590:	2400      	movs	r4, #0
c0d04592:	2800      	cmp	r0, #0
c0d04594:	d03f      	beq.n	c0d04616 <ux_menu_elements_button+0xf2>
        return 0;
      }
      ux_menu.current_entry--;
c0d04596:	1e40      	subs	r0, r0, #1
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d04598:	4926      	ldr	r1, [pc, #152]	; (c0d04634 <ux_menu_elements_button+0x110>)
c0d0459a:	2400      	movs	r4, #0
c0d0459c:	600c      	str	r4, [r1, #0]
c0d0459e:	60b8      	str	r0, [r7, #8]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d045a0:	4825      	ldr	r0, [pc, #148]	; (c0d04638 <ux_menu_elements_button+0x114>)
c0d045a2:	6004      	str	r4, [r0, #0]
      ux_menu.current_entry++;
    redraw:
#ifdef HAVE_BOLOS_UX
      screen_display_init(0);
#else
      UX_REDISPLAY();
c0d045a4:	4d25      	ldr	r5, [pc, #148]	; (c0d0463c <ux_menu_elements_button+0x118>)
c0d045a6:	60ac      	str	r4, [r5, #8]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
  G_button_same_mask_counter = 0;
c0d045a8:	4825      	ldr	r0, [pc, #148]	; (c0d04640 <ux_menu_elements_button+0x11c>)
c0d045aa:	6004      	str	r4, [r0, #0]
      ux_menu.current_entry++;
    redraw:
#ifdef HAVE_BOLOS_UX
      screen_display_init(0);
#else
      UX_REDISPLAY();
c0d045ac:	6828      	ldr	r0, [r5, #0]
c0d045ae:	2800      	cmp	r0, #0
c0d045b0:	d031      	beq.n	c0d04616 <ux_menu_elements_button+0xf2>
c0d045b2:	69e8      	ldr	r0, [r5, #28]
c0d045b4:	4923      	ldr	r1, [pc, #140]	; (c0d04644 <ux_menu_elements_button+0x120>)
c0d045b6:	4288      	cmp	r0, r1
c0d045b8:	d02d      	beq.n	c0d04616 <ux_menu_elements_button+0xf2>
c0d045ba:	2800      	cmp	r0, #0
c0d045bc:	d02b      	beq.n	c0d04616 <ux_menu_elements_button+0xf2>
c0d045be:	2400      	movs	r4, #0
c0d045c0:	4620      	mov	r0, r4
c0d045c2:	6869      	ldr	r1, [r5, #4]
c0d045c4:	4288      	cmp	r0, r1
c0d045c6:	d226      	bcs.n	c0d04616 <ux_menu_elements_button+0xf2>
c0d045c8:	f000 fb44 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d045cc:	2800      	cmp	r0, #0
c0d045ce:	d122      	bne.n	c0d04616 <ux_menu_elements_button+0xf2>
c0d045d0:	68a8      	ldr	r0, [r5, #8]
c0d045d2:	68e9      	ldr	r1, [r5, #12]
c0d045d4:	2638      	movs	r6, #56	; 0x38
c0d045d6:	4370      	muls	r0, r6
c0d045d8:	682a      	ldr	r2, [r5, #0]
c0d045da:	1810      	adds	r0, r2, r0
c0d045dc:	2900      	cmp	r1, #0
c0d045de:	d002      	beq.n	c0d045e6 <ux_menu_elements_button+0xc2>
c0d045e0:	4788      	blx	r1
c0d045e2:	2800      	cmp	r0, #0
c0d045e4:	d007      	beq.n	c0d045f6 <ux_menu_elements_button+0xd2>
c0d045e6:	2801      	cmp	r0, #1
c0d045e8:	d103      	bne.n	c0d045f2 <ux_menu_elements_button+0xce>
c0d045ea:	68a8      	ldr	r0, [r5, #8]
c0d045ec:	4346      	muls	r6, r0
c0d045ee:	6828      	ldr	r0, [r5, #0]
c0d045f0:	1980      	adds	r0, r0, r6
c0d045f2:	f7fe ff37 	bl	c0d03464 <io_seproxyhal_display>
c0d045f6:	68a8      	ldr	r0, [r5, #8]
c0d045f8:	1c40      	adds	r0, r0, #1
c0d045fa:	60a8      	str	r0, [r5, #8]
c0d045fc:	6829      	ldr	r1, [r5, #0]
c0d045fe:	2900      	cmp	r1, #0
c0d04600:	d1df      	bne.n	c0d045c2 <ux_menu_elements_button+0x9e>
c0d04602:	e008      	b.n	c0d04616 <ux_menu_elements_button+0xf2>
        // use userid as the pointer to current entry in the parent menu
        UX_MENU_DISPLAY(current_entry->userid, (const ux_menu_entry_t*)PIC(current_entry->menu), ux_menu.menu_entry_preprocessor);
        return 0;
      }
      // else callback
      else if (current_entry->callback) {
c0d04604:	6870      	ldr	r0, [r6, #4]
c0d04606:	2800      	cmp	r0, #0
c0d04608:	d005      	beq.n	c0d04616 <ux_menu_elements_button+0xf2>
        ((ux_menu_callback_t)PIC(current_entry->callback))(current_entry->userid);
c0d0460a:	f000 f8ad 	bl	c0d04768 <pic>
c0d0460e:	4601      	mov	r1, r0
c0d04610:	68b0      	ldr	r0, [r6, #8]
c0d04612:	4788      	blx	r1
c0d04614:	2400      	movs	r4, #0
      UX_REDISPLAY();
#endif
      return 0;
  }
  return 1;
}
c0d04616:	4620      	mov	r0, r4
c0d04618:	b001      	add	sp, #4
c0d0461a:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0461c:	20002324 	.word	0x20002324
c0d04620:	80000002 	.word	0x80000002
c0d04624:	40000002 	.word	0x40000002
c0d04628:	40000001 	.word	0x40000001
c0d0462c:	80000003 	.word	0x80000003
c0d04630:	80000001 	.word	0x80000001
c0d04634:	200022e0 	.word	0x200022e0
c0d04638:	200022e4 	.word	0x200022e4
c0d0463c:	20001880 	.word	0x20001880
c0d04640:	200022e8 	.word	0x200022e8
c0d04644:	b0105044 	.word	0xb0105044

c0d04648 <ux_menu_display>:

const ux_menu_entry_t UX_MENU_END_ENTRY = UX_MENU_END;

void ux_menu_display(unsigned int current_entry, 
                     const ux_menu_entry_t* menu_entries,
                     ux_menu_preprocessor_t menu_entry_preprocessor) {
c0d04648:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0464a:	b083      	sub	sp, #12
c0d0464c:	9202      	str	r2, [sp, #8]
c0d0464e:	460d      	mov	r5, r1
c0d04650:	9001      	str	r0, [sp, #4]
  // reset to first entry
  ux_menu.menu_entries_count = 0;
c0d04652:	4e39      	ldr	r6, [pc, #228]	; (c0d04738 <ux_menu_display+0xf0>)
c0d04654:	2000      	movs	r0, #0
c0d04656:	9000      	str	r0, [sp, #0]
c0d04658:	6070      	str	r0, [r6, #4]

  // count entries
  if (menu_entries) {
c0d0465a:	2900      	cmp	r1, #0
c0d0465c:	d015      	beq.n	c0d0468a <ux_menu_display+0x42>
    for(;;) {
      if (os_memcmp(&menu_entries[ux_menu.menu_entries_count], &UX_MENU_END_ENTRY, sizeof(ux_menu_entry_t)) == 0) {
c0d0465e:	493c      	ldr	r1, [pc, #240]	; (c0d04750 <ux_menu_display+0x108>)
c0d04660:	4479      	add	r1, pc
c0d04662:	271c      	movs	r7, #28
c0d04664:	4628      	mov	r0, r5
c0d04666:	463a      	mov	r2, r7
c0d04668:	f7ff fa4c 	bl	c0d03b04 <os_memcmp>
c0d0466c:	2800      	cmp	r0, #0
c0d0466e:	d00c      	beq.n	c0d0468a <ux_menu_display+0x42>
c0d04670:	4c38      	ldr	r4, [pc, #224]	; (c0d04754 <ux_menu_display+0x10c>)
c0d04672:	447c      	add	r4, pc
        break;
      }
      ux_menu.menu_entries_count++;
c0d04674:	6870      	ldr	r0, [r6, #4]
c0d04676:	1c40      	adds	r0, r0, #1
c0d04678:	6070      	str	r0, [r6, #4]
  ux_menu.menu_entries_count = 0;

  // count entries
  if (menu_entries) {
    for(;;) {
      if (os_memcmp(&menu_entries[ux_menu.menu_entries_count], &UX_MENU_END_ENTRY, sizeof(ux_menu_entry_t)) == 0) {
c0d0467a:	4378      	muls	r0, r7
c0d0467c:	1828      	adds	r0, r5, r0
c0d0467e:	4621      	mov	r1, r4
c0d04680:	463a      	mov	r2, r7
c0d04682:	f7ff fa3f 	bl	c0d03b04 <os_memcmp>
c0d04686:	2800      	cmp	r0, #0
c0d04688:	d1f4      	bne.n	c0d04674 <ux_menu_display+0x2c>
c0d0468a:	9901      	ldr	r1, [sp, #4]
      }
      ux_menu.menu_entries_count++;
    }
  }

  if (current_entry != UX_MENU_UNCHANGED_ENTRY) {
c0d0468c:	1c48      	adds	r0, r1, #1
c0d0468e:	d005      	beq.n	c0d0469c <ux_menu_display+0x54>
    ux_menu.current_entry = current_entry;
    if (ux_menu.current_entry > ux_menu.menu_entries_count) {
c0d04690:	6870      	ldr	r0, [r6, #4]
c0d04692:	4288      	cmp	r0, r1
c0d04694:	9800      	ldr	r0, [sp, #0]
c0d04696:	d300      	bcc.n	c0d0469a <ux_menu_display+0x52>
c0d04698:	4608      	mov	r0, r1
c0d0469a:	60b0      	str	r0, [r6, #8]
      ux_menu.current_entry = 0;
    }
  }
  ux_menu.menu_entries = menu_entries;
c0d0469c:	6035      	str	r5, [r6, #0]
c0d0469e:	2500      	movs	r5, #0
  ux_menu.menu_entry_preprocessor = menu_entry_preprocessor;
c0d046a0:	9802      	ldr	r0, [sp, #8]
c0d046a2:	60f0      	str	r0, [r6, #12]
  ux_menu.menu_iterator = NULL;
c0d046a4:	6135      	str	r5, [r6, #16]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d046a6:	4c25      	ldr	r4, [pc, #148]	; (c0d0473c <ux_menu_display+0xf4>)
c0d046a8:	482b      	ldr	r0, [pc, #172]	; (c0d04758 <ux_menu_display+0x110>)
c0d046aa:	4478      	add	r0, pc
c0d046ac:	2109      	movs	r1, #9
c0d046ae:	c403      	stmia	r4!, {r0, r1}
c0d046b0:	482a      	ldr	r0, [pc, #168]	; (c0d0475c <ux_menu_display+0x114>)
c0d046b2:	4478      	add	r0, pc
c0d046b4:	492a      	ldr	r1, [pc, #168]	; (c0d04760 <ux_menu_display+0x118>)
c0d046b6:	4479      	add	r1, pc
c0d046b8:	6061      	str	r1, [r4, #4]
c0d046ba:	60a0      	str	r0, [r4, #8]
c0d046bc:	2003      	movs	r0, #3
c0d046be:	7420      	strb	r0, [r4, #16]
c0d046c0:	6165      	str	r5, [r4, #20]
c0d046c2:	3c08      	subs	r4, #8
c0d046c4:	4620      	mov	r0, r4
c0d046c6:	3018      	adds	r0, #24
c0d046c8:	f000 fa6a 	bl	c0d04ba0 <os_ux>
c0d046cc:	61e0      	str	r0, [r4, #28]
c0d046ce:	f000 f849 	bl	c0d04764 <ux_check_status_default>
  io_seproxyhal_init_button();
}

void io_seproxyhal_init_ux(void) {
  // initialize the touch part
  G_bagl_last_touched_not_released_component = NULL;
c0d046d2:	481b      	ldr	r0, [pc, #108]	; (c0d04740 <ux_menu_display+0xf8>)
c0d046d4:	6005      	str	r5, [r0, #0]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
c0d046d6:	481b      	ldr	r0, [pc, #108]	; (c0d04744 <ux_menu_display+0xfc>)
c0d046d8:	6005      	str	r5, [r0, #0]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d046da:	60a5      	str	r5, [r4, #8]
}

void io_seproxyhal_init_button(void) {
  // no button push so far
  G_button_mask = 0;
  G_button_same_mask_counter = 0;
c0d046dc:	481a      	ldr	r0, [pc, #104]	; (c0d04748 <ux_menu_display+0x100>)
c0d046de:	6005      	str	r5, [r0, #0]
  G_bolos_ux_context.screen_stack[0].button_push_callback = ux_menu_elements_button;

  screen_display_init(0);
#else
  // display the menu current entry
  UX_DISPLAY(ux_menu_elements, ux_menu_element_preprocessor);
c0d046e0:	6820      	ldr	r0, [r4, #0]
c0d046e2:	2800      	cmp	r0, #0
c0d046e4:	d026      	beq.n	c0d04734 <ux_menu_display+0xec>
c0d046e6:	69e0      	ldr	r0, [r4, #28]
c0d046e8:	4918      	ldr	r1, [pc, #96]	; (c0d0474c <ux_menu_display+0x104>)
c0d046ea:	4288      	cmp	r0, r1
c0d046ec:	d022      	beq.n	c0d04734 <ux_menu_display+0xec>
c0d046ee:	2800      	cmp	r0, #0
c0d046f0:	d020      	beq.n	c0d04734 <ux_menu_display+0xec>
c0d046f2:	2000      	movs	r0, #0
c0d046f4:	6861      	ldr	r1, [r4, #4]
c0d046f6:	4288      	cmp	r0, r1
c0d046f8:	d21c      	bcs.n	c0d04734 <ux_menu_display+0xec>
c0d046fa:	f000 faab 	bl	c0d04c54 <io_seproxyhal_spi_is_status_sent>
c0d046fe:	2800      	cmp	r0, #0
c0d04700:	d118      	bne.n	c0d04734 <ux_menu_display+0xec>
c0d04702:	68a0      	ldr	r0, [r4, #8]
c0d04704:	68e1      	ldr	r1, [r4, #12]
c0d04706:	2538      	movs	r5, #56	; 0x38
c0d04708:	4368      	muls	r0, r5
c0d0470a:	6822      	ldr	r2, [r4, #0]
c0d0470c:	1810      	adds	r0, r2, r0
c0d0470e:	2900      	cmp	r1, #0
c0d04710:	d002      	beq.n	c0d04718 <ux_menu_display+0xd0>
c0d04712:	4788      	blx	r1
c0d04714:	2800      	cmp	r0, #0
c0d04716:	d007      	beq.n	c0d04728 <ux_menu_display+0xe0>
c0d04718:	2801      	cmp	r0, #1
c0d0471a:	d103      	bne.n	c0d04724 <ux_menu_display+0xdc>
c0d0471c:	68a0      	ldr	r0, [r4, #8]
c0d0471e:	4345      	muls	r5, r0
c0d04720:	6820      	ldr	r0, [r4, #0]
c0d04722:	1940      	adds	r0, r0, r5
c0d04724:	f7fe fe9e 	bl	c0d03464 <io_seproxyhal_display>
c0d04728:	68a0      	ldr	r0, [r4, #8]
c0d0472a:	1c40      	adds	r0, r0, #1
c0d0472c:	60a0      	str	r0, [r4, #8]
c0d0472e:	6821      	ldr	r1, [r4, #0]
c0d04730:	2900      	cmp	r1, #0
c0d04732:	d1df      	bne.n	c0d046f4 <ux_menu_display+0xac>
#endif
}
c0d04734:	b003      	add	sp, #12
c0d04736:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d04738:	20002324 	.word	0x20002324
c0d0473c:	20001880 	.word	0x20001880
c0d04740:	200022e0 	.word	0x200022e0
c0d04744:	200022e4 	.word	0x200022e4
c0d04748:	200022e8 	.word	0x200022e8
c0d0474c:	b0105044 	.word	0xb0105044
c0d04750:	0000339c 	.word	0x0000339c
c0d04754:	0000338a 	.word	0x0000338a
c0d04758:	0000315a 	.word	0x0000315a
c0d0475c:	fffffe6f 	.word	0xfffffe6f
c0d04760:	fffffceb 	.word	0xfffffceb

c0d04764 <ux_check_status_default>:
}

void ux_check_status_default(unsigned int status) {
  // nothing to be done here by default.
  UNUSED(status);
}
c0d04764:	4770      	bx	lr
	...

c0d04768 <pic>:

// only apply PIC conversion if link_address is in linked code (over 0xC0D00000 in our example)
// this way, PIC call are armless if the address is not meant to be converted
extern unsigned int _nvram;
extern unsigned int _envram;
unsigned int pic(unsigned int link_address) {
c0d04768:	b580      	push	{r7, lr}
//  screen_printf(" %08X", link_address);
	if (link_address >= ((unsigned int)&_nvram) && link_address < ((unsigned int)&_envram)) {
c0d0476a:	4904      	ldr	r1, [pc, #16]	; (c0d0477c <pic+0x14>)
c0d0476c:	4288      	cmp	r0, r1
c0d0476e:	d304      	bcc.n	c0d0477a <pic+0x12>
c0d04770:	4903      	ldr	r1, [pc, #12]	; (c0d04780 <pic+0x18>)
c0d04772:	4288      	cmp	r0, r1
c0d04774:	d201      	bcs.n	c0d0477a <pic+0x12>
		link_address = pic_internal(link_address);
c0d04776:	f000 f805 	bl	c0d04784 <pic_internal>
//    screen_printf(" -> %08X\n", link_address);
  }
	return link_address;
c0d0477a:	bd80      	pop	{r7, pc}
c0d0477c:	c0d00000 	.word	0xc0d00000
c0d04780:	c0d07e80 	.word	0xc0d07e80

c0d04784 <pic_internal>:

unsigned int pic_internal(unsigned int link_address) __attribute__((naked));
unsigned int pic_internal(unsigned int link_address) 
{
  // compute the delta offset between LinkMemAddr & ExecMemAddr
  __asm volatile ("mov r2, pc\n");          // r2 = 0x109004
c0d04784:	467a      	mov	r2, pc
  __asm volatile ("ldr r1, =pic_internal\n");        // r1 = 0xC0D00001
c0d04786:	4902      	ldr	r1, [pc, #8]	; (c0d04790 <pic_internal+0xc>)
  __asm volatile ("adds r1, r1, #3\n");     // r1 = 0xC0D00004
c0d04788:	1cc9      	adds	r1, r1, #3
  __asm volatile ("subs r1, r1, r2\n");     // r1 = 0xC0BF7000 (delta between load and exec address)
c0d0478a:	1a89      	subs	r1, r1, r2

  // adjust value of the given parameter
  __asm volatile ("subs r0, r0, r1\n");     // r0 = 0xC0D0C244 => r0 = 0x115244
c0d0478c:	1a40      	subs	r0, r0, r1
  __asm volatile ("bx lr\n");
c0d0478e:	4770      	bx	lr
c0d04790:	c0d04785 	.word	0xc0d04785

c0d04794 <SVC_Call>:
  // avoid a separate asm file, but avoid any intrusion from the compiler
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) __attribute__ ((naked));
  //                    r0                       r1
  unsigned int SVC_Call(unsigned int syscall_id, unsigned int * parameters) {
    // delegate svc
    asm volatile("svc #1":::"r0","r1");
c0d04794:	df01      	svc	1
    // directly return R0 value
    asm volatile("bx  lr");
c0d04796:	4770      	bx	lr

c0d04798 <check_api_level>:
  }
  void check_api_level ( unsigned int apiLevel ) 
{
c0d04798:	b580      	push	{r7, lr}
c0d0479a:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
c0d0479c:	9000      	str	r0, [sp, #0]
c0d0479e:	4807      	ldr	r0, [pc, #28]	; (c0d047bc <check_api_level+0x24>)
c0d047a0:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
c0d047a2:	f7ff fff7 	bl	c0d04794 <SVC_Call>
c0d047a6:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d047a8:	6011      	str	r1, [r2, #0]
c0d047aa:	4905      	ldr	r1, [pc, #20]	; (c0d047c0 <check_api_level+0x28>)
  if (retid != SYSCALL_check_api_level_ID_OUT) {
c0d047ac:	4288      	cmp	r0, r1
c0d047ae:	d101      	bne.n	c0d047b4 <check_api_level+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d047b0:	b002      	add	sp, #8
c0d047b2:	bd80      	pop	{r7, pc}
c0d047b4:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)apiLevel;
  retid = SVC_Call(SYSCALL_check_api_level_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_check_api_level_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d047b6:	f7ff f9b9 	bl	c0d03b2c <os_longjmp>
c0d047ba:	46c0      	nop			; (mov r8, r8)
c0d047bc:	60000137 	.word	0x60000137
c0d047c0:	900001c6 	.word	0x900001c6

c0d047c4 <reset>:
  }
}

void reset ( void ) 
{
c0d047c4:	b580      	push	{r7, lr}
c0d047c6:	b082      	sub	sp, #8
c0d047c8:	4806      	ldr	r0, [pc, #24]	; (c0d047e4 <reset+0x20>)
c0d047ca:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
c0d047cc:	f7ff ffe2 	bl	c0d04794 <SVC_Call>
c0d047d0:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d047d2:	6011      	str	r1, [r2, #0]
c0d047d4:	4904      	ldr	r1, [pc, #16]	; (c0d047e8 <reset+0x24>)
  if (retid != SYSCALL_reset_ID_OUT) {
c0d047d6:	4288      	cmp	r0, r1
c0d047d8:	d101      	bne.n	c0d047de <reset+0x1a>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d047da:	b002      	add	sp, #8
c0d047dc:	bd80      	pop	{r7, pc}
c0d047de:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_reset_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_reset_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d047e0:	f7ff f9a4 	bl	c0d03b2c <os_longjmp>
c0d047e4:	60000200 	.word	0x60000200
c0d047e8:	900002f1 	.word	0x900002f1

c0d047ec <nvm_write>:
  }
}

void nvm_write ( void * dst_adr, void * src_adr, unsigned int src_len ) 
{
c0d047ec:	b580      	push	{r7, lr}
c0d047ee:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)dst_adr;
c0d047f0:	ab00      	add	r3, sp, #0
c0d047f2:	c307      	stmia	r3!, {r0, r1, r2}
c0d047f4:	4806      	ldr	r0, [pc, #24]	; (c0d04810 <nvm_write+0x24>)
c0d047f6:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)src_adr;
  parameters[2] = (unsigned int)src_len;
  retid = SVC_Call(SYSCALL_nvm_write_ID_IN, parameters);
c0d047f8:	f7ff ffcc 	bl	c0d04794 <SVC_Call>
c0d047fc:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d047fe:	6011      	str	r1, [r2, #0]
c0d04800:	4904      	ldr	r1, [pc, #16]	; (c0d04814 <nvm_write+0x28>)
  if (retid != SYSCALL_nvm_write_ID_OUT) {
c0d04802:	4288      	cmp	r0, r1
c0d04804:	d101      	bne.n	c0d0480a <nvm_write+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04806:	b004      	add	sp, #16
c0d04808:	bd80      	pop	{r7, pc}
c0d0480a:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)src_adr;
  parameters[2] = (unsigned int)src_len;
  retid = SVC_Call(SYSCALL_nvm_write_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_nvm_write_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0480c:	f7ff f98e 	bl	c0d03b2c <os_longjmp>
c0d04810:	6000037f 	.word	0x6000037f
c0d04814:	900003bc 	.word	0x900003bc

c0d04818 <cx_rng>:
  }
  return (unsigned char)ret;
}

unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
c0d04818:	b580      	push	{r7, lr}
c0d0481a:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
c0d0481c:	9102      	str	r1, [sp, #8]
unsigned char * cx_rng ( unsigned char * buffer, unsigned int len ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d0481e:	9001      	str	r0, [sp, #4]
c0d04820:	4807      	ldr	r0, [pc, #28]	; (c0d04840 <cx_rng+0x28>)
c0d04822:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
c0d04824:	f7ff ffb6 	bl	c0d04794 <SVC_Call>
c0d04828:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d0482a:	6011      	str	r1, [r2, #0]
c0d0482c:	4905      	ldr	r1, [pc, #20]	; (c0d04844 <cx_rng+0x2c>)
  if (retid != SYSCALL_cx_rng_ID_OUT) {
c0d0482e:	4288      	cmp	r0, r1
c0d04830:	d102      	bne.n	c0d04838 <cx_rng+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned char *)ret;
c0d04832:	9803      	ldr	r0, [sp, #12]
c0d04834:	b004      	add	sp, #16
c0d04836:	bd80      	pop	{r7, pc}
c0d04838:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_rng_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_rng_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d0483a:	f7ff f977 	bl	c0d03b2c <os_longjmp>
c0d0483e:	46c0      	nop			; (mov r8, r8)
c0d04840:	6000052c 	.word	0x6000052c
c0d04844:	90000567 	.word	0x90000567

c0d04848 <cx_hash>:
  }
  return (int)ret;
}

int cx_hash ( cx_hash_t * hash, int mode, const unsigned char * in, unsigned int len, unsigned char * out, unsigned int out_len ) 
{
c0d04848:	b580      	push	{r7, lr}
c0d0484a:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)hash;
c0d0484c:	af01      	add	r7, sp, #4
c0d0484e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04850:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)mode;
  parameters[2] = (unsigned int)in;
  parameters[3] = (unsigned int)len;
  parameters[4] = (unsigned int)out;
c0d04852:	9005      	str	r0, [sp, #20]
c0d04854:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)out_len;
c0d04856:	9006      	str	r0, [sp, #24]
c0d04858:	4807      	ldr	r0, [pc, #28]	; (c0d04878 <cx_hash+0x30>)
c0d0485a:	a901      	add	r1, sp, #4
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
c0d0485c:	f7ff ff9a 	bl	c0d04794 <SVC_Call>
c0d04860:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04862:	6011      	str	r1, [r2, #0]
c0d04864:	4905      	ldr	r1, [pc, #20]	; (c0d0487c <cx_hash+0x34>)
  if (retid != SYSCALL_cx_hash_ID_OUT) {
c0d04866:	4288      	cmp	r0, r1
c0d04868:	d102      	bne.n	c0d04870 <cx_hash+0x28>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0486a:	9807      	ldr	r0, [sp, #28]
c0d0486c:	b008      	add	sp, #32
c0d0486e:	bd80      	pop	{r7, pc}
c0d04870:	2004      	movs	r0, #4
  parameters[4] = (unsigned int)out;
  parameters[5] = (unsigned int)out_len;
  retid = SVC_Call(SYSCALL_cx_hash_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_hash_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04872:	f7ff f95b 	bl	c0d03b2c <os_longjmp>
c0d04876:	46c0      	nop			; (mov r8, r8)
c0d04878:	6000073b 	.word	0x6000073b
c0d0487c:	900007ad 	.word	0x900007ad

c0d04880 <cx_sha256_init>:
  }
  return (int)ret;
}

int cx_sha256_init ( cx_sha256_t * hash ) 
{
c0d04880:	b580      	push	{r7, lr}
c0d04882:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
c0d04884:	9000      	str	r0, [sp, #0]
c0d04886:	4807      	ldr	r0, [pc, #28]	; (c0d048a4 <cx_sha256_init+0x24>)
c0d04888:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
c0d0488a:	f7ff ff83 	bl	c0d04794 <SVC_Call>
c0d0488e:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04890:	6011      	str	r1, [r2, #0]
c0d04892:	4905      	ldr	r1, [pc, #20]	; (c0d048a8 <cx_sha256_init+0x28>)
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
c0d04894:	4288      	cmp	r0, r1
c0d04896:	d102      	bne.n	c0d0489e <cx_sha256_init+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d04898:	9801      	ldr	r0, [sp, #4]
c0d0489a:	b002      	add	sp, #8
c0d0489c:	bd80      	pop	{r7, pc}
c0d0489e:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)hash;
  retid = SVC_Call(SYSCALL_cx_sha256_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_sha256_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d048a0:	f7ff f944 	bl	c0d03b2c <os_longjmp>
c0d048a4:	60000adb 	.word	0x60000adb
c0d048a8:	90000a64 	.word	0x90000a64

c0d048ac <cx_keccak_init>:
  }
  return (int)ret;
}

int cx_keccak_init ( cx_sha3_t * hash, unsigned int size ) 
{
c0d048ac:	b580      	push	{r7, lr}
c0d048ae:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)hash;
  parameters[1] = (unsigned int)size;
c0d048b0:	9102      	str	r1, [sp, #8]
int cx_keccak_init ( cx_sha3_t * hash, unsigned int size ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)hash;
c0d048b2:	9001      	str	r0, [sp, #4]
c0d048b4:	4807      	ldr	r0, [pc, #28]	; (c0d048d4 <cx_keccak_init+0x28>)
c0d048b6:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)size;
  retid = SVC_Call(SYSCALL_cx_keccak_init_ID_IN, parameters);
c0d048b8:	f7ff ff6c 	bl	c0d04794 <SVC_Call>
c0d048bc:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d048be:	6011      	str	r1, [r2, #0]
c0d048c0:	4905      	ldr	r1, [pc, #20]	; (c0d048d8 <cx_keccak_init+0x2c>)
  if (retid != SYSCALL_cx_keccak_init_ID_OUT) {
c0d048c2:	4288      	cmp	r0, r1
c0d048c4:	d102      	bne.n	c0d048cc <cx_keccak_init+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d048c6:	9803      	ldr	r0, [sp, #12]
c0d048c8:	b004      	add	sp, #16
c0d048ca:	bd80      	pop	{r7, pc}
c0d048cc:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)hash;
  parameters[1] = (unsigned int)size;
  retid = SVC_Call(SYSCALL_cx_keccak_init_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_keccak_init_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d048ce:	f7ff f92d 	bl	c0d03b2c <os_longjmp>
c0d048d2:	46c0      	nop			; (mov r8, r8)
c0d048d4:	600010cf 	.word	0x600010cf
c0d048d8:	900010d8 	.word	0x900010d8

c0d048dc <cx_aes_init_key>:
  }
  return (int)ret;
}

int cx_aes_init_key ( const unsigned char * rawkey, unsigned int key_len, cx_aes_key_t * key ) 
{
c0d048dc:	b580      	push	{r7, lr}
c0d048de:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)rawkey;
c0d048e0:	ab00      	add	r3, sp, #0
c0d048e2:	c307      	stmia	r3!, {r0, r1, r2}
c0d048e4:	4807      	ldr	r0, [pc, #28]	; (c0d04904 <cx_aes_init_key+0x28>)
c0d048e6:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)key_len;
  parameters[2] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_aes_init_key_ID_IN, parameters);
c0d048e8:	f7ff ff54 	bl	c0d04794 <SVC_Call>
c0d048ec:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d048ee:	6011      	str	r1, [r2, #0]
c0d048f0:	4905      	ldr	r1, [pc, #20]	; (c0d04908 <cx_aes_init_key+0x2c>)
  if (retid != SYSCALL_cx_aes_init_key_ID_OUT) {
c0d048f2:	4288      	cmp	r0, r1
c0d048f4:	d102      	bne.n	c0d048fc <cx_aes_init_key+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d048f6:	9803      	ldr	r0, [sp, #12]
c0d048f8:	b004      	add	sp, #16
c0d048fa:	bd80      	pop	{r7, pc}
c0d048fc:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)key_len;
  parameters[2] = (unsigned int)key;
  retid = SVC_Call(SYSCALL_cx_aes_init_key_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_aes_init_key_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d048fe:	f7ff f915 	bl	c0d03b2c <os_longjmp>
c0d04902:	46c0      	nop			; (mov r8, r8)
c0d04904:	60001f2b 	.word	0x60001f2b
c0d04908:	90001f31 	.word	0x90001f31

c0d0490c <cx_ecfp_add_point>:
  }
  return (int)ret;
}

int cx_ecfp_add_point ( cx_curve_t curve, unsigned char * R, const unsigned char * P, const unsigned char * Q, unsigned int X_len ) 
{
c0d0490c:	b580      	push	{r7, lr}
c0d0490e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d04910:	af00      	add	r7, sp, #0
c0d04912:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04914:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)R;
  parameters[2] = (unsigned int)P;
  parameters[3] = (unsigned int)Q;
  parameters[4] = (unsigned int)X_len;
c0d04916:	9004      	str	r0, [sp, #16]
c0d04918:	4807      	ldr	r0, [pc, #28]	; (c0d04938 <cx_ecfp_add_point+0x2c>)
c0d0491a:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_ecfp_add_point_ID_IN, parameters);
c0d0491c:	f7ff ff3a 	bl	c0d04794 <SVC_Call>
c0d04920:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04922:	6011      	str	r1, [r2, #0]
c0d04924:	4905      	ldr	r1, [pc, #20]	; (c0d0493c <cx_ecfp_add_point+0x30>)
  if (retid != SYSCALL_cx_ecfp_add_point_ID_OUT) {
c0d04926:	4288      	cmp	r0, r1
c0d04928:	d102      	bne.n	c0d04930 <cx_ecfp_add_point+0x24>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0492a:	9805      	ldr	r0, [sp, #20]
c0d0492c:	b006      	add	sp, #24
c0d0492e:	bd80      	pop	{r7, pc}
c0d04930:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)Q;
  parameters[4] = (unsigned int)X_len;
  retid = SVC_Call(SYSCALL_cx_ecfp_add_point_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_add_point_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04932:	f7ff f8fb 	bl	c0d03b2c <os_longjmp>
c0d04936:	46c0      	nop			; (mov r8, r8)
c0d04938:	60002b17 	.word	0x60002b17
c0d0493c:	90002bc7 	.word	0x90002bc7

c0d04940 <cx_ecfp_scalar_mult>:
  }
  return (int)ret;
}

int cx_ecfp_scalar_mult ( cx_curve_t curve, unsigned char * P, unsigned int P_len, const unsigned char * k, unsigned int k_len ) 
{
c0d04940:	b580      	push	{r7, lr}
c0d04942:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d04944:	af00      	add	r7, sp, #0
c0d04946:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04948:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  parameters[3] = (unsigned int)k;
  parameters[4] = (unsigned int)k_len;
c0d0494a:	9004      	str	r0, [sp, #16]
c0d0494c:	4807      	ldr	r0, [pc, #28]	; (c0d0496c <cx_ecfp_scalar_mult+0x2c>)
c0d0494e:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_ecfp_scalar_mult_ID_IN, parameters);
c0d04950:	f7ff ff20 	bl	c0d04794 <SVC_Call>
c0d04954:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04956:	6011      	str	r1, [r2, #0]
c0d04958:	4905      	ldr	r1, [pc, #20]	; (c0d04970 <cx_ecfp_scalar_mult+0x30>)
  if (retid != SYSCALL_cx_ecfp_scalar_mult_ID_OUT) {
c0d0495a:	4288      	cmp	r0, r1
c0d0495c:	d102      	bne.n	c0d04964 <cx_ecfp_scalar_mult+0x24>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d0495e:	9805      	ldr	r0, [sp, #20]
c0d04960:	b006      	add	sp, #24
c0d04962:	bd80      	pop	{r7, pc}
c0d04964:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)k;
  parameters[4] = (unsigned int)k_len;
  retid = SVC_Call(SYSCALL_cx_ecfp_scalar_mult_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_ecfp_scalar_mult_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04966:	f7ff f8e1 	bl	c0d03b2c <os_longjmp>
c0d0496a:	46c0      	nop			; (mov r8, r8)
c0d0496c:	60002cf3 	.word	0x60002cf3
c0d04970:	90002ce3 	.word	0x90002ce3

c0d04974 <cx_edward_compress_point>:
  }
  return (int)ret;
}

void cx_edward_compress_point ( cx_curve_t curve, unsigned char * P, unsigned int P_len ) 
{
c0d04974:	b580      	push	{r7, lr}
c0d04976:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)curve;
c0d04978:	ab00      	add	r3, sp, #0
c0d0497a:	c307      	stmia	r3!, {r0, r1, r2}
c0d0497c:	4806      	ldr	r0, [pc, #24]	; (c0d04998 <cx_edward_compress_point+0x24>)
c0d0497e:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_compress_point_ID_IN, parameters);
c0d04980:	f7ff ff08 	bl	c0d04794 <SVC_Call>
c0d04984:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04986:	6011      	str	r1, [r2, #0]
c0d04988:	4904      	ldr	r1, [pc, #16]	; (c0d0499c <cx_edward_compress_point+0x28>)
  if (retid != SYSCALL_cx_edward_compress_point_ID_OUT) {
c0d0498a:	4288      	cmp	r0, r1
c0d0498c:	d101      	bne.n	c0d04992 <cx_edward_compress_point+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d0498e:	b004      	add	sp, #16
c0d04990:	bd80      	pop	{r7, pc}
c0d04992:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_compress_point_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_edward_compress_point_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04994:	f7ff f8ca 	bl	c0d03b2c <os_longjmp>
c0d04998:	60003359 	.word	0x60003359
c0d0499c:	9000332b 	.word	0x9000332b

c0d049a0 <cx_edward_decompress_point>:
  }
}

void cx_edward_decompress_point ( cx_curve_t curve, unsigned char * P, unsigned int P_len ) 
{
c0d049a0:	b580      	push	{r7, lr}
c0d049a2:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)curve;
c0d049a4:	ab00      	add	r3, sp, #0
c0d049a6:	c307      	stmia	r3!, {r0, r1, r2}
c0d049a8:	4806      	ldr	r0, [pc, #24]	; (c0d049c4 <cx_edward_decompress_point+0x24>)
c0d049aa:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_decompress_point_ID_IN, parameters);
c0d049ac:	f7ff fef2 	bl	c0d04794 <SVC_Call>
c0d049b0:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d049b2:	6011      	str	r1, [r2, #0]
c0d049b4:	4904      	ldr	r1, [pc, #16]	; (c0d049c8 <cx_edward_decompress_point+0x28>)
  if (retid != SYSCALL_cx_edward_decompress_point_ID_OUT) {
c0d049b6:	4288      	cmp	r0, r1
c0d049b8:	d101      	bne.n	c0d049be <cx_edward_decompress_point+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d049ba:	b004      	add	sp, #16
c0d049bc:	bd80      	pop	{r7, pc}
c0d049be:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)P;
  parameters[2] = (unsigned int)P_len;
  retid = SVC_Call(SYSCALL_cx_edward_decompress_point_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_edward_decompress_point_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d049c0:	f7ff f8b4 	bl	c0d03b2c <os_longjmp>
c0d049c4:	60003431 	.word	0x60003431
c0d049c8:	900034ca 	.word	0x900034ca

c0d049cc <cx_math_is_zero>:
  }
  return (int)ret;
}

int cx_math_is_zero ( const unsigned char * a, unsigned int len ) 
{
c0d049cc:	b580      	push	{r7, lr}
c0d049ce:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)a;
  parameters[1] = (unsigned int)len;
c0d049d0:	9102      	str	r1, [sp, #8]
int cx_math_is_zero ( const unsigned char * a, unsigned int len ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)a;
c0d049d2:	9001      	str	r0, [sp, #4]
c0d049d4:	4807      	ldr	r0, [pc, #28]	; (c0d049f4 <cx_math_is_zero+0x28>)
c0d049d6:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_is_zero_ID_IN, parameters);
c0d049d8:	f7ff fedc 	bl	c0d04794 <SVC_Call>
c0d049dc:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d049de:	6011      	str	r1, [r2, #0]
c0d049e0:	4905      	ldr	r1, [pc, #20]	; (c0d049f8 <cx_math_is_zero+0x2c>)
  if (retid != SYSCALL_cx_math_is_zero_ID_OUT) {
c0d049e2:	4288      	cmp	r0, r1
c0d049e4:	d102      	bne.n	c0d049ec <cx_math_is_zero+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (int)ret;
c0d049e6:	9803      	ldr	r0, [sp, #12]
c0d049e8:	b004      	add	sp, #16
c0d049ea:	bd80      	pop	{r7, pc}
c0d049ec:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)a;
  parameters[1] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_is_zero_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_is_zero_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d049ee:	f7ff f89d 	bl	c0d03b2c <os_longjmp>
c0d049f2:	46c0      	nop			; (mov r8, r8)
c0d049f4:	60003e37 	.word	0x60003e37
c0d049f8:	90003e50 	.word	0x90003e50

c0d049fc <cx_math_addm>:
    THROW(EXCEPTION_SECURITY);
  }
}

void cx_math_addm ( unsigned char * r, const unsigned char * a, const unsigned char * b, const unsigned char * m, unsigned int len ) 
{
c0d049fc:	b580      	push	{r7, lr}
c0d049fe:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)r;
c0d04a00:	af00      	add	r7, sp, #0
c0d04a02:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04a04:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
c0d04a06:	9004      	str	r0, [sp, #16]
c0d04a08:	4806      	ldr	r0, [pc, #24]	; (c0d04a24 <cx_math_addm+0x28>)
c0d04a0a:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_math_addm_ID_IN, parameters);
c0d04a0c:	f7ff fec2 	bl	c0d04794 <SVC_Call>
c0d04a10:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a12:	6011      	str	r1, [r2, #0]
c0d04a14:	4904      	ldr	r1, [pc, #16]	; (c0d04a28 <cx_math_addm+0x2c>)
  if (retid != SYSCALL_cx_math_addm_ID_OUT) {
c0d04a16:	4288      	cmp	r0, r1
c0d04a18:	d101      	bne.n	c0d04a1e <cx_math_addm+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04a1a:	b006      	add	sp, #24
c0d04a1c:	bd80      	pop	{r7, pc}
c0d04a1e:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_addm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_addm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04a20:	f7ff f884 	bl	c0d03b2c <os_longjmp>
c0d04a24:	600042a6 	.word	0x600042a6
c0d04a28:	90004248 	.word	0x90004248

c0d04a2c <cx_math_subm>:
  }
}

void cx_math_subm ( unsigned char * r, const unsigned char * a, const unsigned char * b, const unsigned char * m, unsigned int len ) 
{
c0d04a2c:	b580      	push	{r7, lr}
c0d04a2e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)r;
c0d04a30:	af00      	add	r7, sp, #0
c0d04a32:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04a34:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
c0d04a36:	9004      	str	r0, [sp, #16]
c0d04a38:	4806      	ldr	r0, [pc, #24]	; (c0d04a54 <cx_math_subm+0x28>)
c0d04a3a:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_math_subm_ID_IN, parameters);
c0d04a3c:	f7ff feaa 	bl	c0d04794 <SVC_Call>
c0d04a40:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a42:	6011      	str	r1, [r2, #0]
c0d04a44:	4904      	ldr	r1, [pc, #16]	; (c0d04a58 <cx_math_subm+0x2c>)
  if (retid != SYSCALL_cx_math_subm_ID_OUT) {
c0d04a46:	4288      	cmp	r0, r1
c0d04a48:	d101      	bne.n	c0d04a4e <cx_math_subm+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04a4a:	b006      	add	sp, #24
c0d04a4c:	bd80      	pop	{r7, pc}
c0d04a4e:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_subm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_subm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04a50:	f7ff f86c 	bl	c0d03b2c <os_longjmp>
c0d04a54:	6000437d 	.word	0x6000437d
c0d04a58:	900043e0 	.word	0x900043e0

c0d04a5c <cx_math_multm>:
  }
}

void cx_math_multm ( unsigned char * r, const unsigned char * a, const unsigned char * b, const unsigned char * m, unsigned int len ) 
{
c0d04a5c:	b580      	push	{r7, lr}
c0d04a5e:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)r;
c0d04a60:	af00      	add	r7, sp, #0
c0d04a62:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04a64:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)b;
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
c0d04a66:	9004      	str	r0, [sp, #16]
c0d04a68:	4806      	ldr	r0, [pc, #24]	; (c0d04a84 <cx_math_multm+0x28>)
c0d04a6a:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_cx_math_multm_ID_IN, parameters);
c0d04a6c:	f7ff fe92 	bl	c0d04794 <SVC_Call>
c0d04a70:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04a72:	6011      	str	r1, [r2, #0]
c0d04a74:	4904      	ldr	r1, [pc, #16]	; (c0d04a88 <cx_math_multm+0x2c>)
  if (retid != SYSCALL_cx_math_multm_ID_OUT) {
c0d04a76:	4288      	cmp	r0, r1
c0d04a78:	d101      	bne.n	c0d04a7e <cx_math_multm+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04a7a:	b006      	add	sp, #24
c0d04a7c:	bd80      	pop	{r7, pc}
c0d04a7e:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)m;
  parameters[4] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_multm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_multm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04a80:	f7ff f854 	bl	c0d03b2c <os_longjmp>
c0d04a84:	60004445 	.word	0x60004445
c0d04a88:	900044f3 	.word	0x900044f3

c0d04a8c <cx_math_powm>:
  }
}

void cx_math_powm ( unsigned char * r, const unsigned char * a, const unsigned char * e, unsigned int len_e, const unsigned char * m, unsigned int len ) 
{
c0d04a8c:	b580      	push	{r7, lr}
c0d04a8e:	b088      	sub	sp, #32
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+6];
  parameters[0] = (unsigned int)r;
c0d04a90:	af01      	add	r7, sp, #4
c0d04a92:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04a94:	980a      	ldr	r0, [sp, #40]	; 0x28
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)e;
  parameters[3] = (unsigned int)len_e;
  parameters[4] = (unsigned int)m;
c0d04a96:	9005      	str	r0, [sp, #20]
c0d04a98:	980b      	ldr	r0, [sp, #44]	; 0x2c
  parameters[5] = (unsigned int)len;
c0d04a9a:	9006      	str	r0, [sp, #24]
c0d04a9c:	4806      	ldr	r0, [pc, #24]	; (c0d04ab8 <cx_math_powm+0x2c>)
c0d04a9e:	a901      	add	r1, sp, #4
  retid = SVC_Call(SYSCALL_cx_math_powm_ID_IN, parameters);
c0d04aa0:	f7ff fe78 	bl	c0d04794 <SVC_Call>
c0d04aa4:	aa07      	add	r2, sp, #28
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04aa6:	6011      	str	r1, [r2, #0]
c0d04aa8:	4904      	ldr	r1, [pc, #16]	; (c0d04abc <cx_math_powm+0x30>)
  if (retid != SYSCALL_cx_math_powm_ID_OUT) {
c0d04aaa:	4288      	cmp	r0, r1
c0d04aac:	d101      	bne.n	c0d04ab2 <cx_math_powm+0x26>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04aae:	b008      	add	sp, #32
c0d04ab0:	bd80      	pop	{r7, pc}
c0d04ab2:	2004      	movs	r0, #4
  parameters[4] = (unsigned int)m;
  parameters[5] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_powm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_powm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04ab4:	f7ff f83a 	bl	c0d03b2c <os_longjmp>
c0d04ab8:	6000454d 	.word	0x6000454d
c0d04abc:	9000453e 	.word	0x9000453e

c0d04ac0 <cx_math_modm>:
  }
}

void cx_math_modm ( unsigned char * v, unsigned int len_v, const unsigned char * m, unsigned int len_m ) 
{
c0d04ac0:	b580      	push	{r7, lr}
c0d04ac2:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)v;
c0d04ac4:	af01      	add	r7, sp, #4
c0d04ac6:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04ac8:	4806      	ldr	r0, [pc, #24]	; (c0d04ae4 <cx_math_modm+0x24>)
c0d04aca:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)len_v;
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len_m;
  retid = SVC_Call(SYSCALL_cx_math_modm_ID_IN, parameters);
c0d04acc:	f7ff fe62 	bl	c0d04794 <SVC_Call>
c0d04ad0:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04ad2:	6011      	str	r1, [r2, #0]
c0d04ad4:	4904      	ldr	r1, [pc, #16]	; (c0d04ae8 <cx_math_modm+0x28>)
  if (retid != SYSCALL_cx_math_modm_ID_OUT) {
c0d04ad6:	4288      	cmp	r0, r1
c0d04ad8:	d101      	bne.n	c0d04ade <cx_math_modm+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04ada:	b006      	add	sp, #24
c0d04adc:	bd80      	pop	{r7, pc}
c0d04ade:	2004      	movs	r0, #4
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len_m;
  retid = SVC_Call(SYSCALL_cx_math_modm_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_modm_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04ae0:	f7ff f824 	bl	c0d03b2c <os_longjmp>
c0d04ae4:	60004645 	.word	0x60004645
c0d04ae8:	9000468c 	.word	0x9000468c

c0d04aec <cx_math_invprimem>:
  }
}

void cx_math_invprimem ( unsigned char * r, const unsigned char * a, const unsigned char * m, unsigned int len ) 
{
c0d04aec:	b580      	push	{r7, lr}
c0d04aee:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+4];
  parameters[0] = (unsigned int)r;
c0d04af0:	af01      	add	r7, sp, #4
c0d04af2:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04af4:	4806      	ldr	r0, [pc, #24]	; (c0d04b10 <cx_math_invprimem+0x24>)
c0d04af6:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)a;
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_invprimem_ID_IN, parameters);
c0d04af8:	f7ff fe4c 	bl	c0d04794 <SVC_Call>
c0d04afc:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04afe:	6011      	str	r1, [r2, #0]
c0d04b00:	4904      	ldr	r1, [pc, #16]	; (c0d04b14 <cx_math_invprimem+0x28>)
  if (retid != SYSCALL_cx_math_invprimem_ID_OUT) {
c0d04b02:	4288      	cmp	r0, r1
c0d04b04:	d101      	bne.n	c0d04b0a <cx_math_invprimem+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04b06:	b006      	add	sp, #24
c0d04b08:	bd80      	pop	{r7, pc}
c0d04b0a:	2004      	movs	r0, #4
  parameters[2] = (unsigned int)m;
  parameters[3] = (unsigned int)len;
  retid = SVC_Call(SYSCALL_cx_math_invprimem_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_cx_math_invprimem_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b0c:	f7ff f80e 	bl	c0d03b2c <os_longjmp>
c0d04b10:	600047e9 	.word	0x600047e9
c0d04b14:	90004719 	.word	0x90004719

c0d04b18 <os_perso_derive_node_bip32>:
  }
  return (unsigned int)ret;
}

void os_perso_derive_node_bip32 ( cx_curve_t curve, const unsigned int * path, unsigned int pathLength, unsigned char * privateKey, unsigned char * chain ) 
{
c0d04b18:	b580      	push	{r7, lr}
c0d04b1a:	b086      	sub	sp, #24
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+5];
  parameters[0] = (unsigned int)curve;
c0d04b1c:	af00      	add	r7, sp, #0
c0d04b1e:	c70f      	stmia	r7!, {r0, r1, r2, r3}
c0d04b20:	9808      	ldr	r0, [sp, #32]
  parameters[1] = (unsigned int)path;
  parameters[2] = (unsigned int)pathLength;
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
c0d04b22:	9004      	str	r0, [sp, #16]
c0d04b24:	4806      	ldr	r0, [pc, #24]	; (c0d04b40 <os_perso_derive_node_bip32+0x28>)
c0d04b26:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
c0d04b28:	f7ff fe34 	bl	c0d04794 <SVC_Call>
c0d04b2c:	aa05      	add	r2, sp, #20
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04b2e:	6011      	str	r1, [r2, #0]
c0d04b30:	4904      	ldr	r1, [pc, #16]	; (c0d04b44 <os_perso_derive_node_bip32+0x2c>)
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
c0d04b32:	4288      	cmp	r0, r1
c0d04b34:	d101      	bne.n	c0d04b3a <os_perso_derive_node_bip32+0x22>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04b36:	b006      	add	sp, #24
c0d04b38:	bd80      	pop	{r7, pc}
c0d04b3a:	2004      	movs	r0, #4
  parameters[3] = (unsigned int)privateKey;
  parameters[4] = (unsigned int)chain;
  retid = SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_perso_derive_node_bip32_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b3c:	f7fe fff6 	bl	c0d03b2c <os_longjmp>
c0d04b40:	600053ba 	.word	0x600053ba
c0d04b44:	9000531e 	.word	0x9000531e

c0d04b48 <os_global_pin_is_validated>:
  }
  return (unsigned int)ret;
}

unsigned int os_global_pin_is_validated ( void ) 
{
c0d04b48:	b580      	push	{r7, lr}
c0d04b4a:	b082      	sub	sp, #8
c0d04b4c:	4807      	ldr	r0, [pc, #28]	; (c0d04b6c <os_global_pin_is_validated+0x24>)
c0d04b4e:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_global_pin_is_validated_ID_IN, parameters);
c0d04b50:	f7ff fe20 	bl	c0d04794 <SVC_Call>
c0d04b54:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04b56:	6011      	str	r1, [r2, #0]
c0d04b58:	4905      	ldr	r1, [pc, #20]	; (c0d04b70 <os_global_pin_is_validated+0x28>)
  if (retid != SYSCALL_os_global_pin_is_validated_ID_OUT) {
c0d04b5a:	4288      	cmp	r0, r1
c0d04b5c:	d102      	bne.n	c0d04b64 <os_global_pin_is_validated+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04b5e:	9800      	ldr	r0, [sp, #0]
c0d04b60:	b002      	add	sp, #8
c0d04b62:	bd80      	pop	{r7, pc}
c0d04b64:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_global_pin_is_validated_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_global_pin_is_validated_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b66:	f7fe ffe1 	bl	c0d03b2c <os_longjmp>
c0d04b6a:	46c0      	nop			; (mov r8, r8)
c0d04b6c:	60005b89 	.word	0x60005b89
c0d04b70:	90005b45 	.word	0x90005b45

c0d04b74 <os_sched_exit>:
  }
  return (unsigned int)ret;
}

void os_sched_exit ( unsigned int exit_code ) 
{
c0d04b74:	b580      	push	{r7, lr}
c0d04b76:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
c0d04b78:	9000      	str	r0, [sp, #0]
c0d04b7a:	4807      	ldr	r0, [pc, #28]	; (c0d04b98 <os_sched_exit+0x24>)
c0d04b7c:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
c0d04b7e:	f7ff fe09 	bl	c0d04794 <SVC_Call>
c0d04b82:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04b84:	6011      	str	r1, [r2, #0]
c0d04b86:	4905      	ldr	r1, [pc, #20]	; (c0d04b9c <os_sched_exit+0x28>)
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
c0d04b88:	4288      	cmp	r0, r1
c0d04b8a:	d101      	bne.n	c0d04b90 <os_sched_exit+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04b8c:	b002      	add	sp, #8
c0d04b8e:	bd80      	pop	{r7, pc}
c0d04b90:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)exit_code;
  retid = SVC_Call(SYSCALL_os_sched_exit_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_sched_exit_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04b92:	f7fe ffcb 	bl	c0d03b2c <os_longjmp>
c0d04b96:	46c0      	nop			; (mov r8, r8)
c0d04b98:	600062e1 	.word	0x600062e1
c0d04b9c:	9000626f 	.word	0x9000626f

c0d04ba0 <os_ux>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_ux ( bolos_ux_params_t * params ) 
{
c0d04ba0:	b580      	push	{r7, lr}
c0d04ba2:	b082      	sub	sp, #8
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
c0d04ba4:	9000      	str	r0, [sp, #0]
c0d04ba6:	4807      	ldr	r0, [pc, #28]	; (c0d04bc4 <os_ux+0x24>)
c0d04ba8:	4669      	mov	r1, sp
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
c0d04baa:	f7ff fdf3 	bl	c0d04794 <SVC_Call>
c0d04bae:	aa01      	add	r2, sp, #4
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04bb0:	6011      	str	r1, [r2, #0]
c0d04bb2:	4905      	ldr	r1, [pc, #20]	; (c0d04bc8 <os_ux+0x28>)
  if (retid != SYSCALL_os_ux_ID_OUT) {
c0d04bb4:	4288      	cmp	r0, r1
c0d04bb6:	d102      	bne.n	c0d04bbe <os_ux+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04bb8:	9801      	ldr	r0, [sp, #4]
c0d04bba:	b002      	add	sp, #8
c0d04bbc:	bd80      	pop	{r7, pc}
c0d04bbe:	2004      	movs	r0, #4
  unsigned int parameters [0+1];
  parameters[0] = (unsigned int)params;
  retid = SVC_Call(SYSCALL_os_ux_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_ux_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04bc0:	f7fe ffb4 	bl	c0d03b2c <os_longjmp>
c0d04bc4:	60006458 	.word	0x60006458
c0d04bc8:	9000641f 	.word	0x9000641f

c0d04bcc <os_flags>:
    THROW(EXCEPTION_SECURITY);
  }
}

unsigned int os_flags ( void ) 
{
c0d04bcc:	b580      	push	{r7, lr}
c0d04bce:	b082      	sub	sp, #8
c0d04bd0:	4807      	ldr	r0, [pc, #28]	; (c0d04bf0 <os_flags+0x24>)
c0d04bd2:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
c0d04bd4:	f7ff fdde 	bl	c0d04794 <SVC_Call>
c0d04bd8:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04bda:	6011      	str	r1, [r2, #0]
c0d04bdc:	4905      	ldr	r1, [pc, #20]	; (c0d04bf4 <os_flags+0x28>)
  if (retid != SYSCALL_os_flags_ID_OUT) {
c0d04bde:	4288      	cmp	r0, r1
c0d04be0:	d102      	bne.n	c0d04be8 <os_flags+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04be2:	9800      	ldr	r0, [sp, #0]
c0d04be4:	b002      	add	sp, #8
c0d04be6:	bd80      	pop	{r7, pc}
c0d04be8:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_os_flags_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_flags_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04bea:	f7fe ff9f 	bl	c0d03b2c <os_longjmp>
c0d04bee:	46c0      	nop			; (mov r8, r8)
c0d04bf0:	6000686e 	.word	0x6000686e
c0d04bf4:	9000687f 	.word	0x9000687f

c0d04bf8 <os_registry_get_current_app_tag>:
  }
  return (unsigned int)ret;
}

unsigned int os_registry_get_current_app_tag ( unsigned int tag, unsigned char * buffer, unsigned int maxlen ) 
{
c0d04bf8:	b580      	push	{r7, lr}
c0d04bfa:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)tag;
c0d04bfc:	ab00      	add	r3, sp, #0
c0d04bfe:	c307      	stmia	r3!, {r0, r1, r2}
c0d04c00:	4807      	ldr	r0, [pc, #28]	; (c0d04c20 <os_registry_get_current_app_tag+0x28>)
c0d04c02:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
c0d04c04:	f7ff fdc6 	bl	c0d04794 <SVC_Call>
c0d04c08:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c0a:	6011      	str	r1, [r2, #0]
c0d04c0c:	4905      	ldr	r1, [pc, #20]	; (c0d04c24 <os_registry_get_current_app_tag+0x2c>)
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
c0d04c0e:	4288      	cmp	r0, r1
c0d04c10:	d102      	bne.n	c0d04c18 <os_registry_get_current_app_tag+0x20>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04c12:	9803      	ldr	r0, [sp, #12]
c0d04c14:	b004      	add	sp, #16
c0d04c16:	bd80      	pop	{r7, pc}
c0d04c18:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)buffer;
  parameters[2] = (unsigned int)maxlen;
  retid = SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_os_registry_get_current_app_tag_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04c1a:	f7fe ff87 	bl	c0d03b2c <os_longjmp>
c0d04c1e:	46c0      	nop			; (mov r8, r8)
c0d04c20:	600070d4 	.word	0x600070d4
c0d04c24:	90007087 	.word	0x90007087

c0d04c28 <io_seproxyhal_spi_send>:
  }
  return (unsigned int)ret;
}

void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
c0d04c28:	b580      	push	{r7, lr}
c0d04c2a:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
c0d04c2c:	9102      	str	r1, [sp, #8]
void io_seproxyhal_spi_send ( const unsigned char * buffer, unsigned short length ) 
{
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+2];
  parameters[0] = (unsigned int)buffer;
c0d04c2e:	9001      	str	r0, [sp, #4]
c0d04c30:	4806      	ldr	r0, [pc, #24]	; (c0d04c4c <io_seproxyhal_spi_send+0x24>)
c0d04c32:	a901      	add	r1, sp, #4
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
c0d04c34:	f7ff fdae 	bl	c0d04794 <SVC_Call>
c0d04c38:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c3a:	6011      	str	r1, [r2, #0]
c0d04c3c:	4904      	ldr	r1, [pc, #16]	; (c0d04c50 <io_seproxyhal_spi_send+0x28>)
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
c0d04c3e:	4288      	cmp	r0, r1
c0d04c40:	d101      	bne.n	c0d04c46 <io_seproxyhal_spi_send+0x1e>
    THROW(EXCEPTION_SECURITY);
  }
}
c0d04c42:	b004      	add	sp, #16
c0d04c44:	bd80      	pop	{r7, pc}
c0d04c46:	2004      	movs	r0, #4
  parameters[0] = (unsigned int)buffer;
  parameters[1] = (unsigned int)length;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_send_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_send_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04c48:	f7fe ff70 	bl	c0d03b2c <os_longjmp>
c0d04c4c:	6000721c 	.word	0x6000721c
c0d04c50:	900072f3 	.word	0x900072f3

c0d04c54 <io_seproxyhal_spi_is_status_sent>:
  }
}

unsigned int io_seproxyhal_spi_is_status_sent ( void ) 
{
c0d04c54:	b580      	push	{r7, lr}
c0d04c56:	b082      	sub	sp, #8
c0d04c58:	4807      	ldr	r0, [pc, #28]	; (c0d04c78 <io_seproxyhal_spi_is_status_sent+0x24>)
c0d04c5a:	a901      	add	r1, sp, #4
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
c0d04c5c:	f7ff fd9a 	bl	c0d04794 <SVC_Call>
c0d04c60:	466a      	mov	r2, sp
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c62:	6011      	str	r1, [r2, #0]
c0d04c64:	4905      	ldr	r1, [pc, #20]	; (c0d04c7c <io_seproxyhal_spi_is_status_sent+0x28>)
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
c0d04c66:	4288      	cmp	r0, r1
c0d04c68:	d102      	bne.n	c0d04c70 <io_seproxyhal_spi_is_status_sent+0x1c>
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned int)ret;
c0d04c6a:	9800      	ldr	r0, [sp, #0]
c0d04c6c:	b002      	add	sp, #8
c0d04c6e:	bd80      	pop	{r7, pc}
c0d04c70:	2004      	movs	r0, #4
  unsigned int retid;
  unsigned int parameters [0];
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_is_status_sent_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_is_status_sent_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04c72:	f7fe ff5b 	bl	c0d03b2c <os_longjmp>
c0d04c76:	46c0      	nop			; (mov r8, r8)
c0d04c78:	600073cf 	.word	0x600073cf
c0d04c7c:	9000737f 	.word	0x9000737f

c0d04c80 <io_seproxyhal_spi_recv>:
  }
  return (unsigned int)ret;
}

unsigned short io_seproxyhal_spi_recv ( unsigned char * buffer, unsigned short maxlength, unsigned int flags ) 
{
c0d04c80:	b580      	push	{r7, lr}
c0d04c82:	b084      	sub	sp, #16
  unsigned int ret;
  unsigned int retid;
  unsigned int parameters [0+3];
  parameters[0] = (unsigned int)buffer;
c0d04c84:	ab00      	add	r3, sp, #0
c0d04c86:	c307      	stmia	r3!, {r0, r1, r2}
c0d04c88:	4807      	ldr	r0, [pc, #28]	; (c0d04ca8 <io_seproxyhal_spi_recv+0x28>)
c0d04c8a:	4669      	mov	r1, sp
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
c0d04c8c:	f7ff fd82 	bl	c0d04794 <SVC_Call>
c0d04c90:	aa03      	add	r2, sp, #12
  asm volatile("str r1, %0":"=m"(ret)::"r1");
c0d04c92:	6011      	str	r1, [r2, #0]
c0d04c94:	4905      	ldr	r1, [pc, #20]	; (c0d04cac <io_seproxyhal_spi_recv+0x2c>)
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
c0d04c96:	4288      	cmp	r0, r1
c0d04c98:	d103      	bne.n	c0d04ca2 <io_seproxyhal_spi_recv+0x22>
c0d04c9a:	a803      	add	r0, sp, #12
    THROW(EXCEPTION_SECURITY);
  }
  return (unsigned short)ret;
c0d04c9c:	8800      	ldrh	r0, [r0, #0]
c0d04c9e:	b004      	add	sp, #16
c0d04ca0:	bd80      	pop	{r7, pc}
c0d04ca2:	2004      	movs	r0, #4
  parameters[1] = (unsigned int)maxlength;
  parameters[2] = (unsigned int)flags;
  retid = SVC_Call(SYSCALL_io_seproxyhal_spi_recv_ID_IN, parameters);
  asm volatile("str r1, %0":"=m"(ret)::"r1");
  if (retid != SYSCALL_io_seproxyhal_spi_recv_ID_OUT) {
    THROW(EXCEPTION_SECURITY);
c0d04ca4:	f7fe ff42 	bl	c0d03b2c <os_longjmp>
c0d04ca8:	600074d1 	.word	0x600074d1
c0d04cac:	9000742b 	.word	0x9000742b

c0d04cb0 <u2f_apdu_sign>:

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
}

void u2f_apdu_sign(u2f_service_t *service, uint8_t p1, uint8_t p2,
                     uint8_t *buffer, uint16_t length) {
c0d04cb0:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04cb2:	b081      	sub	sp, #4
c0d04cb4:	4604      	mov	r4, r0
    UNUSED(p2);
    uint8_t keyHandleLength;
    uint8_t i;

    // can't process the apdu if another one is already scheduled in
    if (G_io_apdu_state != APDU_IDLE) {
c0d04cb6:	4833      	ldr	r0, [pc, #204]	; (c0d04d84 <u2f_apdu_sign+0xd4>)
c0d04cb8:	7800      	ldrb	r0, [r0, #0]
c0d04cba:	2800      	cmp	r0, #0
c0d04cbc:	d003      	beq.n	c0d04cc6 <u2f_apdu_sign+0x16>
c0d04cbe:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04cc0:	4a34      	ldr	r2, [pc, #208]	; (c0d04d94 <u2f_apdu_sign+0xe4>)
c0d04cc2:	447a      	add	r2, pc
c0d04cc4:	e043      	b.n	c0d04d4e <u2f_apdu_sign+0x9e>
c0d04cc6:	9806      	ldr	r0, [sp, #24]
                  (uint8_t *)SW_BUSY,
                  sizeof(SW_BUSY));
        return;        
    }

    if (length < U2F_HANDLE_SIGN_HEADER_SIZE + 5 /*at least an apdu header*/) {
c0d04cc8:	2845      	cmp	r0, #69	; 0x45
c0d04cca:	d803      	bhi.n	c0d04cd4 <u2f_apdu_sign+0x24>
c0d04ccc:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04cce:	4a32      	ldr	r2, [pc, #200]	; (c0d04d98 <u2f_apdu_sign+0xe8>)
c0d04cd0:	447a      	add	r2, pc
c0d04cd2:	e03c      	b.n	c0d04d4e <u2f_apdu_sign+0x9e>
                  sizeof(SW_WRONG_LENGTH));
        return;
    }
    
    // Confirm immediately if it's just a validation call
    if (p1 == P1_SIGN_CHECK_ONLY) {
c0d04cd4:	2907      	cmp	r1, #7
c0d04cd6:	d103      	bne.n	c0d04ce0 <u2f_apdu_sign+0x30>
c0d04cd8:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04cda:	4a30      	ldr	r2, [pc, #192]	; (c0d04d9c <u2f_apdu_sign+0xec>)
c0d04cdc:	447a      	add	r2, pc
c0d04cde:	e036      	b.n	c0d04d4e <u2f_apdu_sign+0x9e>
c0d04ce0:	461d      	mov	r5, r3
c0d04ce2:	9000      	str	r0, [sp, #0]
c0d04ce4:	2040      	movs	r0, #64	; 0x40
                  sizeof(SW_PROOF_OF_PRESENCE_REQUIRED));
        return;
    }

    // Unwrap magic
    keyHandleLength = buffer[U2F_HANDLE_SIGN_HEADER_SIZE-1];
c0d04ce6:	5c1e      	ldrb	r6, [r3, r0]
    
    // reply to the "get magic" question of the host
    if (keyHandleLength == 5) {
c0d04ce8:	2e00      	cmp	r6, #0
c0d04cea:	d018      	beq.n	c0d04d1e <u2f_apdu_sign+0x6e>
c0d04cec:	2e05      	cmp	r6, #5
c0d04cee:	d108      	bne.n	c0d04d02 <u2f_apdu_sign+0x52>
        // GET U2F PROXY PARAMETERS
        // this apdu is not subject to proxy magic masking
        // APDU is F1 D0 00 00 00 to get the magic proxy
        // RAPDU: <>
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
c0d04cf0:	4628      	mov	r0, r5
c0d04cf2:	3041      	adds	r0, #65	; 0x41
c0d04cf4:	492a      	ldr	r1, [pc, #168]	; (c0d04da0 <u2f_apdu_sign+0xf0>)
c0d04cf6:	4479      	add	r1, pc
c0d04cf8:	2205      	movs	r2, #5
c0d04cfa:	f7fe ff03 	bl	c0d03b04 <os_memcmp>
c0d04cfe:	2800      	cmp	r0, #0
c0d04d00:	d02b      	beq.n	c0d04d5a <u2f_apdu_sign+0xaa>
        }
    }
    

    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
c0d04d02:	4628      	mov	r0, r5
c0d04d04:	3041      	adds	r0, #65	; 0x41
c0d04d06:	2100      	movs	r1, #0
c0d04d08:	4a26      	ldr	r2, [pc, #152]	; (c0d04da4 <u2f_apdu_sign+0xf4>)
c0d04d0a:	447a      	add	r2, pc
c0d04d0c:	5c43      	ldrb	r3, [r0, r1]
c0d04d0e:	2703      	movs	r7, #3
c0d04d10:	400f      	ands	r7, r1
c0d04d12:	5dd7      	ldrb	r7, [r2, r7]
c0d04d14:	405f      	eors	r7, r3
c0d04d16:	5447      	strb	r7, [r0, r1]
            return;
        }
    }
    

    for (i = 0; i < keyHandleLength; i++) {
c0d04d18:	1c49      	adds	r1, r1, #1
c0d04d1a:	428e      	cmp	r6, r1
c0d04d1c:	d1f6      	bne.n	c0d04d0c <u2f_apdu_sign+0x5c>
c0d04d1e:	2045      	movs	r0, #69	; 0x45
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
c0d04d20:	5c28      	ldrb	r0, [r5, r0]
c0d04d22:	3046      	adds	r0, #70	; 0x46
c0d04d24:	9900      	ldr	r1, [sp, #0]
c0d04d26:	4288      	cmp	r0, r1
c0d04d28:	d10e      	bne.n	c0d04d48 <u2f_apdu_sign+0x98>
                  sizeof(SW_BAD_KEY_HANDLE));
        return;
    }

    // make the apdu available to higher layers
    os_memmove(G_io_apdu_buffer, buffer + U2F_HANDLE_SIGN_HEADER_SIZE, keyHandleLength);
c0d04d2a:	3541      	adds	r5, #65	; 0x41
c0d04d2c:	4816      	ldr	r0, [pc, #88]	; (c0d04d88 <u2f_apdu_sign+0xd8>)
c0d04d2e:	4629      	mov	r1, r5
c0d04d30:	4632      	mov	r2, r6
c0d04d32:	f7fe fe2c 	bl	c0d0398e <os_memmove>
    G_io_apdu_length = keyHandleLength;
c0d04d36:	4815      	ldr	r0, [pc, #84]	; (c0d04d8c <u2f_apdu_sign+0xdc>)
c0d04d38:	8006      	strh	r6, [r0, #0]
    G_io_apdu_media = IO_APDU_MEDIA_U2F; // the effective transport is managed by the U2F layer
c0d04d3a:	4815      	ldr	r0, [pc, #84]	; (c0d04d90 <u2f_apdu_sign+0xe0>)
c0d04d3c:	2107      	movs	r1, #7
c0d04d3e:	7001      	strb	r1, [r0, #0]
c0d04d40:	2009      	movs	r0, #9
    G_io_apdu_state = APDU_U2F;
c0d04d42:	4910      	ldr	r1, [pc, #64]	; (c0d04d84 <u2f_apdu_sign+0xd4>)
c0d04d44:	7008      	strb	r0, [r1, #0]
c0d04d46:	e006      	b.n	c0d04d56 <u2f_apdu_sign+0xa6>
c0d04d48:	2183      	movs	r1, #131	; 0x83
    for (i = 0; i < keyHandleLength; i++) {
        buffer[U2F_HANDLE_SIGN_HEADER_SIZE + i] ^= U2F_PROXY_MAGIC[i % (sizeof(U2F_PROXY_MAGIC)-1)];
    }
    // Check that it looks like an APDU
    if (length != U2F_HANDLE_SIGN_HEADER_SIZE + 5 + buffer[U2F_HANDLE_SIGN_HEADER_SIZE + 4]) {
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04d4a:	4a17      	ldr	r2, [pc, #92]	; (c0d04da8 <u2f_apdu_sign+0xf8>)
c0d04d4c:	447a      	add	r2, pc
c0d04d4e:	2302      	movs	r3, #2
c0d04d50:	4620      	mov	r0, r4
c0d04d52:	f000 fb4d 	bl	c0d053f0 <u2f_message_reply>
    app_dispatch();
    if ((btchip_context_D.io_flags & IO_ASYNCH_REPLY) == 0) {
        u2f_proxy_response(service, btchip_context_D.outLength);
    }
    */
}
c0d04d56:	b001      	add	sp, #4
c0d04d58:	bdf0      	pop	{r4, r5, r6, r7, pc}
        // this apdu is not subject to proxy magic masking
        // APDU is F1 D0 00 00 00 to get the magic proxy
        // RAPDU: <>
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
            // U2F_PROXY_MAGIC is given as a 0 terminated string
            G_io_apdu_buffer[0] = sizeof(U2F_PROXY_MAGIC)-1;
c0d04d5a:	4d0b      	ldr	r5, [pc, #44]	; (c0d04d88 <u2f_apdu_sign+0xd8>)
c0d04d5c:	2604      	movs	r6, #4
c0d04d5e:	702e      	strb	r6, [r5, #0]
            os_memmove(G_io_apdu_buffer+1, U2F_PROXY_MAGIC, sizeof(U2F_PROXY_MAGIC)-1);
c0d04d60:	1c68      	adds	r0, r5, #1
c0d04d62:	4912      	ldr	r1, [pc, #72]	; (c0d04dac <u2f_apdu_sign+0xfc>)
c0d04d64:	4479      	add	r1, pc
c0d04d66:	4632      	mov	r2, r6
c0d04d68:	f7fe fe11 	bl	c0d0398e <os_memmove>
            os_memmove(G_io_apdu_buffer+1+sizeof(U2F_PROXY_MAGIC)-1, "\x90\x00\x90\x00", 4);
c0d04d6c:	1d68      	adds	r0, r5, #5
c0d04d6e:	4910      	ldr	r1, [pc, #64]	; (c0d04db0 <u2f_apdu_sign+0x100>)
c0d04d70:	4479      	add	r1, pc
c0d04d72:	4632      	mov	r2, r6
c0d04d74:	f7fe fe0b 	bl	c0d0398e <os_memmove>
            u2f_message_reply(service, U2F_CMD_MSG,
                              (uint8_t *)G_io_apdu_buffer,
                              G_io_apdu_buffer[0]+1+2+2);
c0d04d78:	7828      	ldrb	r0, [r5, #0]
c0d04d7a:	1d43      	adds	r3, r0, #5
c0d04d7c:	2183      	movs	r1, #131	; 0x83
        if (os_memcmp(buffer+U2F_HANDLE_SIGN_HEADER_SIZE, "\xF1\xD0\x00\x00\x00", 5) == 0 ) {
            // U2F_PROXY_MAGIC is given as a 0 terminated string
            G_io_apdu_buffer[0] = sizeof(U2F_PROXY_MAGIC)-1;
            os_memmove(G_io_apdu_buffer+1, U2F_PROXY_MAGIC, sizeof(U2F_PROXY_MAGIC)-1);
            os_memmove(G_io_apdu_buffer+1+sizeof(U2F_PROXY_MAGIC)-1, "\x90\x00\x90\x00", 4);
            u2f_message_reply(service, U2F_CMD_MSG,
c0d04d7e:	4620      	mov	r0, r4
c0d04d80:	462a      	mov	r2, r5
c0d04d82:	e7e6      	b.n	c0d04d52 <u2f_apdu_sign+0xa2>
c0d04d84:	200022dc 	.word	0x200022dc
c0d04d88:	2000216c 	.word	0x2000216c
c0d04d8c:	200022de 	.word	0x200022de
c0d04d90:	200022c8 	.word	0x200022c8
c0d04d94:	00002d58 	.word	0x00002d58
c0d04d98:	00002d4c 	.word	0x00002d4c
c0d04d9c:	00002d42 	.word	0x00002d42
c0d04da0:	00002d2a 	.word	0x00002d2a
c0d04da4:	00002d1c 	.word	0x00002d1c
c0d04da8:	00002ce4 	.word	0x00002ce4
c0d04dac:	00002cc2 	.word	0x00002cc2
c0d04db0:	00002cbb 	.word	0x00002cbb

c0d04db4 <u2f_handle_cmd_init>:
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
}

void u2f_handle_cmd_init(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length, uint8_t *channelInit) {
c0d04db4:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04db6:	b081      	sub	sp, #4
c0d04db8:	461d      	mov	r5, r3
c0d04dba:	460e      	mov	r6, r1
c0d04dbc:	4604      	mov	r4, r0
    // screen_printf("U2F init\n");
    uint8_t channel[4];
    (void)length;
    if (u2f_is_channel_broadcast(channelInit)) {
c0d04dbe:	4618      	mov	r0, r3
c0d04dc0:	f000 fb0a 	bl	c0d053d8 <u2f_is_channel_broadcast>
c0d04dc4:	2800      	cmp	r0, #0
c0d04dc6:	d004      	beq.n	c0d04dd2 <u2f_handle_cmd_init+0x1e>
c0d04dc8:	4668      	mov	r0, sp
c0d04dca:	2104      	movs	r1, #4
        cx_rng(channel, 4);
c0d04dcc:	f7ff fd24 	bl	c0d04818 <cx_rng>
c0d04dd0:	e004      	b.n	c0d04ddc <u2f_handle_cmd_init+0x28>
c0d04dd2:	4668      	mov	r0, sp
c0d04dd4:	2204      	movs	r2, #4
    } else {
        os_memmove(channel, channelInit, 4);
c0d04dd6:	4629      	mov	r1, r5
c0d04dd8:	f7fe fdd9 	bl	c0d0398e <os_memmove>
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
c0d04ddc:	4f17      	ldr	r7, [pc, #92]	; (c0d04e3c <u2f_handle_cmd_init+0x88>)
c0d04dde:	2208      	movs	r2, #8
c0d04de0:	4638      	mov	r0, r7
c0d04de2:	4631      	mov	r1, r6
c0d04de4:	f7fe fdd3 	bl	c0d0398e <os_memmove>
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
c0d04de8:	4638      	mov	r0, r7
c0d04dea:	3008      	adds	r0, #8
c0d04dec:	4669      	mov	r1, sp
c0d04dee:	2204      	movs	r2, #4
c0d04df0:	f7fe fdcd 	bl	c0d0398e <os_memmove>
c0d04df4:	2000      	movs	r0, #0
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
c0d04df6:	7378      	strb	r0, [r7, #13]
c0d04df8:	2102      	movs	r1, #2
    } else {
        os_memmove(channel, channelInit, 4);
    }
    os_memmove(G_io_apdu_buffer, buffer, 8);
    os_memmove(G_io_apdu_buffer + 8, channel, 4);
    G_io_apdu_buffer[12] = INIT_U2F_VERSION;
c0d04dfa:	7339      	strb	r1, [r7, #12]
c0d04dfc:	2101      	movs	r1, #1
    G_io_apdu_buffer[13] = INIT_DEVICE_VERSION_MAJOR;
    G_io_apdu_buffer[14] = INIT_DEVICE_VERSION_MINOR;
c0d04dfe:	73b9      	strb	r1, [r7, #14]
    G_io_apdu_buffer[15] = INIT_BUILD_VERSION;
c0d04e00:	73f8      	strb	r0, [r7, #15]
    G_io_apdu_buffer[16] = INIT_CAPABILITIES;
c0d04e02:	7438      	strb	r0, [r7, #16]

    if (u2f_is_channel_broadcast(channelInit)) {
c0d04e04:	4628      	mov	r0, r5
c0d04e06:	f000 fae7 	bl	c0d053d8 <u2f_is_channel_broadcast>
c0d04e0a:	2586      	movs	r5, #134	; 0x86
c0d04e0c:	2800      	cmp	r0, #0
c0d04e0e:	d007      	beq.n	c0d04e20 <u2f_handle_cmd_init+0x6c>
        os_memset(service->channel, 0xff, 4);
c0d04e10:	4628      	mov	r0, r5
c0d04e12:	3079      	adds	r0, #121	; 0x79
c0d04e14:	b2c1      	uxtb	r1, r0
c0d04e16:	2204      	movs	r2, #4
c0d04e18:	4620      	mov	r0, r4
c0d04e1a:	f7fe fdaf 	bl	c0d0397c <os_memset>
c0d04e1e:	e004      	b.n	c0d04e2a <u2f_handle_cmd_init+0x76>
c0d04e20:	4669      	mov	r1, sp
c0d04e22:	2204      	movs	r2, #4
    } else {
        os_memmove(service->channel, channel, 4);
c0d04e24:	4620      	mov	r0, r4
c0d04e26:	f7fe fdb2 	bl	c0d0398e <os_memmove>
    }
    u2f_message_reply(service, U2F_CMD_INIT, G_io_apdu_buffer, 17);
c0d04e2a:	4a04      	ldr	r2, [pc, #16]	; (c0d04e3c <u2f_handle_cmd_init+0x88>)
c0d04e2c:	2311      	movs	r3, #17
c0d04e2e:	4620      	mov	r0, r4
c0d04e30:	4629      	mov	r1, r5
c0d04e32:	f000 fadd 	bl	c0d053f0 <u2f_message_reply>
}
c0d04e36:	b001      	add	sp, #4
c0d04e38:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d04e3a:	46c0      	nop			; (mov r8, r8)
c0d04e3c:	2000216c 	.word	0x2000216c

c0d04e40 <u2f_handle_cmd_msg>:
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
c0d04e40:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04e42:	b083      	sub	sp, #12
c0d04e44:	9002      	str	r0, [sp, #8]
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
c0d04e46:	7988      	ldrb	r0, [r1, #6]
c0d04e48:	794b      	ldrb	r3, [r1, #5]
c0d04e4a:	021b      	lsls	r3, r3, #8
c0d04e4c:	181f      	adds	r7, r3, r0
void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
c0d04e4e:	7888      	ldrb	r0, [r1, #2]

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
    uint8_t ins = buffer[1];
c0d04e50:	9001      	str	r0, [sp, #4]
c0d04e52:	784b      	ldrb	r3, [r1, #1]
}

void u2f_handle_cmd_msg(u2f_service_t *service, uint8_t *buffer,
                        uint16_t length) {
    // screen_printf("U2F msg\n");
    uint8_t cla = buffer[0];
c0d04e54:	780e      	ldrb	r6, [r1, #0]
    uint8_t ins = buffer[1];
    uint8_t p1 = buffer[2];
    uint8_t p2 = buffer[3];
    // in extended length buffer[4] must be 0
    uint32_t dataLength = /*(buffer[4] << 16) |*/ (buffer[5] << 8) | (buffer[6]);
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
c0d04e56:	4615      	mov	r5, r2
c0d04e58:	3d09      	subs	r5, #9
c0d04e5a:	b2ac      	uxth	r4, r5
c0d04e5c:	42a7      	cmp	r7, r4
c0d04e5e:	d004      	beq.n	c0d04e6a <u2f_handle_cmd_msg+0x2a>
c0d04e60:	1fd0      	subs	r0, r2, #7
c0d04e62:	1fd2      	subs	r2, r2, #7
c0d04e64:	b292      	uxth	r2, r2
c0d04e66:	4297      	cmp	r7, r2
c0d04e68:	d11b      	bne.n	c0d04ea2 <u2f_handle_cmd_msg+0x62>
c0d04e6a:	463d      	mov	r5, r7
                  (uint8_t *)SW_WRONG_LENGTH,
                  sizeof(SW_WRONG_LENGTH));
        return;
    }

    if (cla != FIDO_CLA) {
c0d04e6c:	2e00      	cmp	r6, #0
c0d04e6e:	d008      	beq.n	c0d04e82 <u2f_handle_cmd_msg+0x42>
c0d04e70:	2183      	movs	r1, #131	; 0x83
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04e72:	4a1c      	ldr	r2, [pc, #112]	; (c0d04ee4 <u2f_handle_cmd_msg+0xa4>)
c0d04e74:	447a      	add	r2, pc
c0d04e76:	2302      	movs	r3, #2
c0d04e78:	9802      	ldr	r0, [sp, #8]
c0d04e7a:	f000 fab9 	bl	c0d053f0 <u2f_message_reply>
        u2f_message_reply(service, U2F_CMD_MSG,
                 (uint8_t *)SW_UNKNOWN_INSTRUCTION,
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}
c0d04e7e:	b003      	add	sp, #12
c0d04e80:	bdf0      	pop	{r4, r5, r6, r7, pc}
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d04e82:	2b02      	cmp	r3, #2
c0d04e84:	dc18      	bgt.n	c0d04eb8 <u2f_handle_cmd_msg+0x78>
c0d04e86:	2b01      	cmp	r3, #1
c0d04e88:	d023      	beq.n	c0d04ed2 <u2f_handle_cmd_msg+0x92>
c0d04e8a:	2b02      	cmp	r3, #2
c0d04e8c:	d11d      	bne.n	c0d04eca <u2f_handle_cmd_msg+0x8a>
        // screen_printf("enroll\n");
        u2f_apdu_enroll(service, p1, p2, buffer + 7, dataLength);
        break;
    case FIDO_INS_SIGN:
        // screen_printf("sign\n");
        u2f_apdu_sign(service, p1, p2, buffer + 7, dataLength);
c0d04e8e:	b2a8      	uxth	r0, r5
c0d04e90:	466a      	mov	r2, sp
c0d04e92:	6010      	str	r0, [r2, #0]
c0d04e94:	1dcb      	adds	r3, r1, #7
c0d04e96:	2200      	movs	r2, #0
c0d04e98:	9802      	ldr	r0, [sp, #8]
c0d04e9a:	9901      	ldr	r1, [sp, #4]
c0d04e9c:	f7ff ff08 	bl	c0d04cb0 <u2f_apdu_sign>
c0d04ea0:	e7ed      	b.n	c0d04e7e <u2f_handle_cmd_msg+0x3e>
    if (dataLength == (uint16_t)(length - 9) || dataLength == (uint16_t)(length - 7)) {
        // Le is optional
        // nominal case from the specification
    }
    // circumvent google chrome extended length encoding done on the last byte only (module 256) but all data being transferred
    else if (dataLength == (uint16_t)(length - 9)%256) {
c0d04ea2:	b2e4      	uxtb	r4, r4
c0d04ea4:	42a7      	cmp	r7, r4
c0d04ea6:	d0e1      	beq.n	c0d04e6c <u2f_handle_cmd_msg+0x2c>
        dataLength = length - 9;
    }
    else if (dataLength == (uint16_t)(length - 7)%256) {
c0d04ea8:	b2d2      	uxtb	r2, r2
c0d04eaa:	4297      	cmp	r7, r2
c0d04eac:	4605      	mov	r5, r0
c0d04eae:	d0dd      	beq.n	c0d04e6c <u2f_handle_cmd_msg+0x2c>
c0d04eb0:	2183      	movs	r1, #131	; 0x83
        dataLength = length - 7;
    }    
    else { 
        // invalid size
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04eb2:	4a0d      	ldr	r2, [pc, #52]	; (c0d04ee8 <u2f_handle_cmd_msg+0xa8>)
c0d04eb4:	447a      	add	r2, pc
c0d04eb6:	e7de      	b.n	c0d04e76 <u2f_handle_cmd_msg+0x36>
        u2f_message_reply(service, U2F_CMD_MSG,
                  (uint8_t *)SW_UNKNOWN_CLASS,
                  sizeof(SW_UNKNOWN_CLASS));
        return;
    }
    switch (ins) {
c0d04eb8:	2b03      	cmp	r3, #3
c0d04eba:	d00e      	beq.n	c0d04eda <u2f_handle_cmd_msg+0x9a>
c0d04ebc:	2bc1      	cmp	r3, #193	; 0xc1
c0d04ebe:	d104      	bne.n	c0d04eca <u2f_handle_cmd_msg+0x8a>
c0d04ec0:	2183      	movs	r1, #131	; 0x83
                            uint8_t *buffer, uint16_t length) {
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)INFO, sizeof(INFO));
c0d04ec2:	4a0a      	ldr	r2, [pc, #40]	; (c0d04eec <u2f_handle_cmd_msg+0xac>)
c0d04ec4:	447a      	add	r2, pc
c0d04ec6:	2304      	movs	r3, #4
c0d04ec8:	e7d6      	b.n	c0d04e78 <u2f_handle_cmd_msg+0x38>
c0d04eca:	2183      	movs	r1, #131	; 0x83
        u2f_apdu_get_info(service, p1, p2, buffer + 7, dataLength);
        break;

    default:
        // screen_printf("unsupported\n");
        u2f_message_reply(service, U2F_CMD_MSG,
c0d04ecc:	4a0a      	ldr	r2, [pc, #40]	; (c0d04ef8 <u2f_handle_cmd_msg+0xb8>)
c0d04ece:	447a      	add	r2, pc
c0d04ed0:	e7d1      	b.n	c0d04e76 <u2f_handle_cmd_msg+0x36>
c0d04ed2:	2183      	movs	r1, #131	; 0x83
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);

    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)SW_INTERNAL, sizeof(SW_INTERNAL));
c0d04ed4:	4a06      	ldr	r2, [pc, #24]	; (c0d04ef0 <u2f_handle_cmd_msg+0xb0>)
c0d04ed6:	447a      	add	r2, pc
c0d04ed8:	e7cd      	b.n	c0d04e76 <u2f_handle_cmd_msg+0x36>
c0d04eda:	2183      	movs	r1, #131	; 0x83
    // screen_printf("U2F version\n");
    UNUSED(p1);
    UNUSED(p2);
    UNUSED(buffer);
    UNUSED(length);
    u2f_message_reply(service, U2F_CMD_MSG, (uint8_t *)U2F_VERSION, sizeof(U2F_VERSION));
c0d04edc:	4a05      	ldr	r2, [pc, #20]	; (c0d04ef4 <u2f_handle_cmd_msg+0xb4>)
c0d04ede:	447a      	add	r2, pc
c0d04ee0:	2308      	movs	r3, #8
c0d04ee2:	e7c9      	b.n	c0d04e78 <u2f_handle_cmd_msg+0x38>
c0d04ee4:	00002bca 	.word	0x00002bca
c0d04ee8:	00002b68 	.word	0x00002b68
c0d04eec:	00002b76 	.word	0x00002b76
c0d04ef0:	00002b42 	.word	0x00002b42
c0d04ef4:	00002b54 	.word	0x00002b54
c0d04ef8:	00002b72 	.word	0x00002b72

c0d04efc <u2f_message_complete>:
                 sizeof(SW_UNKNOWN_INSTRUCTION));
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
c0d04efc:	b580      	push	{r7, lr}
    uint8_t cmd = service->transportBuffer[0];
c0d04efe:	6981      	ldr	r1, [r0, #24]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
c0d04f00:	788a      	ldrb	r2, [r1, #2]
c0d04f02:	784b      	ldrb	r3, [r1, #1]
c0d04f04:	021b      	lsls	r3, r3, #8
c0d04f06:	189b      	adds	r3, r3, r2
        return;
    }
}

void u2f_message_complete(u2f_service_t *service) {
    uint8_t cmd = service->transportBuffer[0];
c0d04f08:	780a      	ldrb	r2, [r1, #0]
    uint16_t length = (service->transportBuffer[1] << 8) | (service->transportBuffer[2]);
    switch (cmd) {
c0d04f0a:	2a81      	cmp	r2, #129	; 0x81
c0d04f0c:	d009      	beq.n	c0d04f22 <u2f_message_complete+0x26>
c0d04f0e:	2a83      	cmp	r2, #131	; 0x83
c0d04f10:	d00d      	beq.n	c0d04f2e <u2f_message_complete+0x32>
c0d04f12:	2a86      	cmp	r2, #134	; 0x86
c0d04f14:	d10f      	bne.n	c0d04f36 <u2f_message_complete+0x3a>
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
c0d04f16:	1cc9      	adds	r1, r1, #3
c0d04f18:	2200      	movs	r2, #0
c0d04f1a:	4603      	mov	r3, r0
c0d04f1c:	f7ff ff4a 	bl	c0d04db4 <u2f_handle_cmd_init>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d04f20:	bd80      	pop	{r7, pc}
    switch (cmd) {
    case U2F_CMD_INIT:
        u2f_handle_cmd_init(service, service->transportBuffer + 3, length, service->channel);
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
c0d04f22:	1cca      	adds	r2, r1, #3
}

void u2f_handle_cmd_ping(u2f_service_t *service, uint8_t *buffer,
                         uint16_t length) {
    // screen_printf("U2F ping\n");
    u2f_message_reply(service, U2F_CMD_PING, buffer, length);
c0d04f24:	b29b      	uxth	r3, r3
c0d04f26:	2181      	movs	r1, #129	; 0x81
c0d04f28:	f000 fa62 	bl	c0d053f0 <u2f_message_reply>
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
        break;
    }
}
c0d04f2c:	bd80      	pop	{r7, pc}
        break;
    case U2F_CMD_PING:
        u2f_handle_cmd_ping(service, service->transportBuffer + 3, length);
        break;
    case U2F_CMD_MSG:
        u2f_handle_cmd_msg(service, service->transportBuffer + 3, length);
c0d04f2e:	1cc9      	adds	r1, r1, #3
c0d04f30:	b29a      	uxth	r2, r3
c0d04f32:	f7ff ff85 	bl	c0d04e40 <u2f_handle_cmd_msg>
        break;
    }
}
c0d04f36:	bd80      	pop	{r7, pc}

c0d04f38 <u2f_io_send>:
#include "u2f_processing.h"
#include "u2f_impl.h"

#include "os_io_seproxyhal.h"

void u2f_io_send(uint8_t *buffer, uint16_t length, u2f_transport_media_t media) {
c0d04f38:	b570      	push	{r4, r5, r6, lr}
    if (media == U2F_MEDIA_USB) {
c0d04f3a:	2a01      	cmp	r2, #1
c0d04f3c:	d113      	bne.n	c0d04f66 <u2f_io_send+0x2e>
c0d04f3e:	460d      	mov	r5, r1
c0d04f40:	4601      	mov	r1, r0
        os_memmove(G_io_usb_ep_buffer, buffer, length);
c0d04f42:	4c09      	ldr	r4, [pc, #36]	; (c0d04f68 <u2f_io_send+0x30>)
c0d04f44:	4620      	mov	r0, r4
c0d04f46:	462a      	mov	r2, r5
c0d04f48:	f7fe fd21 	bl	c0d0398e <os_memmove>
        // wipe the remaining to avoid :
        // 1/ data leaks
        // 2/ invalid junk
        os_memset(G_io_usb_ep_buffer+length, 0, sizeof(G_io_usb_ep_buffer)-length);
c0d04f4c:	1960      	adds	r0, r4, r5
c0d04f4e:	2640      	movs	r6, #64	; 0x40
c0d04f50:	1b72      	subs	r2, r6, r5
c0d04f52:	2500      	movs	r5, #0
c0d04f54:	4629      	mov	r1, r5
c0d04f56:	f7fe fd11 	bl	c0d0397c <os_memset>
c0d04f5a:	2081      	movs	r0, #129	; 0x81
    }
    switch (media) {
    case U2F_MEDIA_USB:
        io_usb_send_ep(U2F_EPIN_ADDR, G_io_usb_ep_buffer, USB_SEGMENT_SIZE, 0);
c0d04f5c:	4621      	mov	r1, r4
c0d04f5e:	4632      	mov	r2, r6
c0d04f60:	462b      	mov	r3, r5
c0d04f62:	f7fe fe7d 	bl	c0d03c60 <io_usb_send_ep>
#endif
    default:
        PRINTF("Request to send on unsupported media %d\n", media);
        break;
    }
}
c0d04f66:	bd70      	pop	{r4, r5, r6, pc}
c0d04f68:	20002370 	.word	0x20002370

c0d04f6c <u2f_transport_init>:
/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
c0d04f6c:	8182      	strh	r2, [r0, #12]

/**
 * Initialize the u2f transport and provide the buffer into which to store incoming message
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
c0d04f6e:	6081      	str	r1, [r0, #8]
c0d04f70:	2200      	movs	r2, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d04f72:	8242      	strh	r2, [r0, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d04f74:	8382      	strh	r2, [r0, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d04f76:	7582      	strb	r2, [r0, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d04f78:	6181      	str	r1, [r0, #24]
 */
void u2f_transport_init(u2f_service_t *service, uint8_t* message_buffer, uint16_t message_buffer_length) {
    service->transportReceiveBuffer = message_buffer;
    service->transportReceiveBufferLength = message_buffer_length;
    u2f_transport_reset(service);
}
c0d04f7a:	4770      	bx	lr

c0d04f7c <u2f_transport_sent>:

/**
 * Function called when the previously scheduled message to be sent on the media is effectively sent.
 * And a new message can be scheduled.
 */
void u2f_transport_sent(u2f_service_t* service, u2f_transport_media_t media) {
c0d04f7c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d04f7e:	b085      	sub	sp, #20
c0d04f80:	4604      	mov	r4, r0
    // if idle (possibly after an error), then only await for a transmission 
    if (service->transportState != U2F_SENDING_RESPONSE 
c0d04f82:	7f00      	ldrb	r0, [r0, #28]
        && service->transportState != U2F_SENDING_ERROR) {
c0d04f84:	1ec0      	subs	r0, r0, #3
c0d04f86:	b2c0      	uxtb	r0, r0
c0d04f88:	2801      	cmp	r0, #1
c0d04f8a:	d857      	bhi.n	c0d0503c <u2f_transport_sent+0xc0>
        // absorb the error, transport is erroneous but that won't hurt in the end.
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
c0d04f8c:	8aa0      	ldrh	r0, [r4, #20]
c0d04f8e:	8a62      	ldrh	r2, [r4, #18]
c0d04f90:	4290      	cmp	r0, r2
c0d04f92:	d927      	bls.n	c0d04fe4 <u2f_transport_sent+0x68>
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d04f94:	7da5      	ldrb	r5, [r4, #22]
c0d04f96:	2303      	movs	r3, #3
c0d04f98:	2601      	movs	r6, #1
c0d04f9a:	9502      	str	r5, [sp, #8]
c0d04f9c:	2d00      	cmp	r5, #0
c0d04f9e:	d000      	beq.n	c0d04fa2 <u2f_transport_sent+0x26>
c0d04fa0:	4633      	mov	r3, r6
        // absorb the error, transport is erroneous but that won't hurt in the end.
        //THROW(INVALID_STATE);
        return;
    }
    if (service->transportOffset < service->transportLength) {
        uint16_t mtu = (media == U2F_MEDIA_USB) ? USB_SEGMENT_SIZE : BLE_SEGMENT_SIZE;
c0d04fa2:	1e4f      	subs	r7, r1, #1
c0d04fa4:	2500      	movs	r5, #0
c0d04fa6:	460e      	mov	r6, r1
c0d04fa8:	9503      	str	r5, [sp, #12]
c0d04faa:	1bed      	subs	r5, r5, r7
c0d04fac:	417d      	adcs	r5, r7
c0d04fae:	00ad      	lsls	r5, r5, #2
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
c0d04fb0:	195d      	adds	r5, r3, r5
c0d04fb2:	2340      	movs	r3, #64	; 0x40
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
                                      (mtu - headerSize)
c0d04fb4:	1b5f      	subs	r7, r3, r5
        uint16_t channelHeader =
            (media == U2F_MEDIA_USB ? 4 : 0);
        uint8_t headerSize =
            (service->transportPacketIndex == 0 ? (channelHeader + 3)
                                                : (channelHeader + 1));
        uint16_t blockSize = ((service->transportLength - service->transportOffset) >
c0d04fb6:	1a81      	subs	r1, r0, r2
c0d04fb8:	42b9      	cmp	r1, r7
c0d04fba:	dc00      	bgt.n	c0d04fbe <u2f_transport_sent+0x42>
c0d04fbc:	460f      	mov	r7, r1
c0d04fbe:	9501      	str	r5, [sp, #4]
                                      (mtu - headerSize)
                                  ? (mtu - headerSize)
                                  : service->transportLength - service->transportOffset);
        uint16_t dataSize = blockSize + headerSize;
c0d04fc0:	1978      	adds	r0, r7, r5
        uint16_t offset = 0;
        // Fragment
        if (media == U2F_MEDIA_USB) {
c0d04fc2:	9004      	str	r0, [sp, #16]
c0d04fc4:	2e01      	cmp	r6, #1
c0d04fc6:	4635      	mov	r5, r6
c0d04fc8:	9e03      	ldr	r6, [sp, #12]
c0d04fca:	9802      	ldr	r0, [sp, #8]
c0d04fcc:	d106      	bne.n	c0d04fdc <u2f_transport_sent+0x60>
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d04fce:	481d      	ldr	r0, [pc, #116]	; (c0d05044 <u2f_transport_sent+0xc8>)
c0d04fd0:	2604      	movs	r6, #4
c0d04fd2:	4621      	mov	r1, r4
c0d04fd4:	4632      	mov	r2, r6
c0d04fd6:	f7fe fcda 	bl	c0d0398e <os_memmove>
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
c0d04fda:	7da0      	ldrb	r0, [r4, #22]
c0d04fdc:	2800      	cmp	r0, #0
c0d04fde:	d00b      	beq.n	c0d04ff8 <u2f_transport_sent+0x7c>
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
c0d04fe0:	1e40      	subs	r0, r0, #1
c0d04fe2:	e013      	b.n	c0d0500c <u2f_transport_sent+0x90>
        service->transportOffset += blockSize;
        service->transportPacketIndex++;
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
    }
    // last part sent
    else if (service->transportOffset == service->transportLength) {
c0d04fe4:	d12a      	bne.n	c0d0503c <u2f_transport_sent+0xc0>
c0d04fe6:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d04fe8:	8260      	strh	r0, [r4, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d04fea:	83a0      	strh	r0, [r4, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d04fec:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d04fee:	68a1      	ldr	r1, [r4, #8]
c0d04ff0:	61a1      	str	r1, [r4, #24]
    }
    // last part sent
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
        // we sent the whole response (even if we haven't yet received the ack for the last sent usb in packet)
        G_io_apdu_state = APDU_IDLE;
c0d04ff2:	4913      	ldr	r1, [pc, #76]	; (c0d05040 <u2f_transport_sent+0xc4>)
c0d04ff4:	7008      	strb	r0, [r1, #0]
c0d04ff6:	e021      	b.n	c0d0503c <u2f_transport_sent+0xc0>
c0d04ff8:	2034      	movs	r0, #52	; 0x34
        if (media == U2F_MEDIA_USB) {
            os_memmove(G_io_usb_ep_buffer, service->channel, 4);
            offset += 4;
        }
        if (service->transportPacketIndex == 0) {
            G_io_usb_ep_buffer[offset++] = service->sendCmd;
c0d04ffa:	5c20      	ldrb	r0, [r4, r0]
c0d04ffc:	4911      	ldr	r1, [pc, #68]	; (c0d05044 <u2f_transport_sent+0xc8>)
c0d04ffe:	5588      	strb	r0, [r1, r6]
c0d05000:	2001      	movs	r0, #1
c0d05002:	4330      	orrs	r0, r6
            G_io_usb_ep_buffer[offset++] = (service->transportLength >> 8);
c0d05004:	7d62      	ldrb	r2, [r4, #21]
c0d05006:	540a      	strb	r2, [r1, r0]
c0d05008:	1c46      	adds	r6, r0, #1
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
c0d0500a:	7d20      	ldrb	r0, [r4, #20]
c0d0500c:	4b0d      	ldr	r3, [pc, #52]	; (c0d05044 <u2f_transport_sent+0xc8>)
c0d0500e:	5598      	strb	r0, [r3, r6]
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
c0d05010:	69a1      	ldr	r1, [r4, #24]
c0d05012:	2900      	cmp	r1, #0
c0d05014:	d006      	beq.n	c0d05024 <u2f_transport_sent+0xa8>
c0d05016:	b2ba      	uxth	r2, r7
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d05018:	9801      	ldr	r0, [sp, #4]
c0d0501a:	1818      	adds	r0, r3, r0
                       service->transportBuffer + service->transportOffset, blockSize);
c0d0501c:	8a63      	ldrh	r3, [r4, #18]
c0d0501e:	18c9      	adds	r1, r1, r3
            G_io_usb_ep_buffer[offset++] = (service->transportLength & 0xff);
        } else {
            G_io_usb_ep_buffer[offset++] = (service->transportPacketIndex - 1);
        }
        if (service->transportBuffer != NULL) {
            os_memmove(G_io_usb_ep_buffer + headerSize,
c0d05020:	f7fe fcb5 	bl	c0d0398e <os_memmove>
                       service->transportBuffer + service->transportOffset, blockSize);
        }
        service->transportOffset += blockSize;
c0d05024:	8a60      	ldrh	r0, [r4, #18]
c0d05026:	19c0      	adds	r0, r0, r7
c0d05028:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d0502a:	7da0      	ldrb	r0, [r4, #22]
c0d0502c:	1c40      	adds	r0, r0, #1
c0d0502e:	75a0      	strb	r0, [r4, #22]
        u2f_io_send(G_io_usb_ep_buffer, dataSize, media);
c0d05030:	9804      	ldr	r0, [sp, #16]
c0d05032:	b281      	uxth	r1, r0
c0d05034:	4803      	ldr	r0, [pc, #12]	; (c0d05044 <u2f_transport_sent+0xc8>)
c0d05036:	462a      	mov	r2, r5
c0d05038:	f7ff ff7e 	bl	c0d04f38 <u2f_io_send>
    else if (service->transportOffset == service->transportLength) {
        u2f_transport_reset(service);
        // we sent the whole response (even if we haven't yet received the ack for the last sent usb in packet)
        G_io_apdu_state = APDU_IDLE;
    }
}
c0d0503c:	b005      	add	sp, #20
c0d0503e:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d05040:	200022dc 	.word	0x200022dc
c0d05044:	20002370 	.word	0x20002370

c0d05048 <u2f_transport_received>:
/** 
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
c0d05048:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d0504a:	b087      	sub	sp, #28
c0d0504c:	4616      	mov	r6, r2
c0d0504e:	460a      	mov	r2, r1
c0d05050:	4604      	mov	r4, r0
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
c0d05052:	7103      	strb	r3, [r0, #4]
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d05054:	7f00      	ldrb	r0, [r0, #28]
c0d05056:	1e81      	subs	r1, r0, #2
c0d05058:	2902      	cmp	r1, #2
c0d0505a:	d20f      	bcs.n	c0d0507c <u2f_transport_received+0x34>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0505c:	48da      	ldr	r0, [pc, #872]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d0505e:	2106      	movs	r1, #6
c0d05060:	7201      	strb	r1, [r0, #8]
c0d05062:	217a      	movs	r1, #122	; 0x7a
c0d05064:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05066:	313a      	adds	r1, #58	; 0x3a
c0d05068:	2234      	movs	r2, #52	; 0x34
c0d0506a:	54a1      	strb	r1, [r4, r2]
c0d0506c:	2100      	movs	r1, #0
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0506e:	75a1      	strb	r1, [r4, #22]
c0d05070:	2204      	movs	r2, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05072:	7722      	strb	r2, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05074:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d05076:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d05078:	8261      	strh	r1, [r4, #18]
c0d0507a:	e063      	b.n	c0d05144 <u2f_transport_received+0xfc>
c0d0507c:	461d      	mov	r5, r3
                          uint16_t size, u2f_transport_media_t media) {
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
    uint16_t xfer_len;
    service->media = media;
    // If busy, answer immediately, avoid reentry
    if ((service->transportState == U2F_PROCESSING_COMMAND) ||
c0d0507e:	2804      	cmp	r0, #4
c0d05080:	d105      	bne.n	c0d0508e <u2f_transport_received+0x46>
c0d05082:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d05084:	8260      	strh	r0, [r4, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d05086:	83a0      	strh	r0, [r4, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d05088:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0508a:	68a0      	ldr	r0, [r4, #8]
c0d0508c:	61a0      	str	r0, [r4, #24]
 * Function that process every message received on a media.
 * Performs message concatenation when message is splitted.
 */
void u2f_transport_received(u2f_service_t *service, uint8_t *buffer,
                          uint16_t size, u2f_transport_media_t media) {
    uint16_t channelHeader = (media == U2F_MEDIA_USB ? 4 : 0);
c0d0508e:	1e68      	subs	r0, r5, #1
c0d05090:	2300      	movs	r3, #0
c0d05092:	1a19      	subs	r1, r3, r0
c0d05094:	4141      	adcs	r1, r0
    // SENDING_ERROR is accepted, and triggers a reset => means the host hasn't consumed the error.
    if (service->transportState == U2F_SENDING_ERROR) {
        u2f_transport_reset(service);
    }

    if (size < (1 + channelHeader)) {
c0d05096:	008f      	lsls	r7, r1, #2
c0d05098:	1c78      	adds	r0, r7, #1
c0d0509a:	42b0      	cmp	r0, r6
c0d0509c:	d844      	bhi.n	c0d05128 <u2f_transport_received+0xe0>
c0d0509e:	9004      	str	r0, [sp, #16]
        // Message to short, abort
        u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
        goto error;
    }
    if (media == U2F_MEDIA_USB) {
c0d050a0:	2d01      	cmp	r5, #1
c0d050a2:	9705      	str	r7, [sp, #20]
c0d050a4:	9506      	str	r5, [sp, #24]
c0d050a6:	d10c      	bne.n	c0d050c2 <u2f_transport_received+0x7a>
c0d050a8:	4615      	mov	r5, r2
c0d050aa:	2204      	movs	r2, #4
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
c0d050ac:	4620      	mov	r0, r4
c0d050ae:	4629      	mov	r1, r5
c0d050b0:	4637      	mov	r7, r6
c0d050b2:	461e      	mov	r6, r3
c0d050b4:	f7fe fc6b 	bl	c0d0398e <os_memmove>
c0d050b8:	462a      	mov	r2, r5
c0d050ba:	9d06      	ldr	r5, [sp, #24]
c0d050bc:	4633      	mov	r3, r6
c0d050be:	463e      	mov	r6, r7
c0d050c0:	9f05      	ldr	r7, [sp, #20]
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d050c2:	8a60      	ldrh	r0, [r4, #18]
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
c0d050c4:	2800      	cmp	r0, #0
c0d050c6:	d011      	beq.n	c0d050ec <u2f_transport_received+0xa4>
c0d050c8:	2d01      	cmp	r5, #1
c0d050ca:	d129      	bne.n	c0d05120 <u2f_transport_received+0xd8>
c0d050cc:	4620      	mov	r0, r4
c0d050ce:	300e      	adds	r0, #14
c0d050d0:	4615      	mov	r5, r2
c0d050d2:	2204      	movs	r2, #4
c0d050d4:	4621      	mov	r1, r4
c0d050d6:	4637      	mov	r7, r6
c0d050d8:	461e      	mov	r6, r3
c0d050da:	f7fe fd13 	bl	c0d03b04 <os_memcmp>
c0d050de:	462a      	mov	r2, r5
c0d050e0:	9d06      	ldr	r5, [sp, #24]
c0d050e2:	4633      	mov	r3, r6
c0d050e4:	463e      	mov	r6, r7
c0d050e6:	9f05      	ldr	r7, [sp, #20]
        // hold the current channel value to reply to, for example, INIT commands within flow of segments.
        os_memmove(service->channel, buffer, 4);
    }

    // no previous chunk processed for the current message
    if (service->transportOffset == 0
c0d050e8:	2800      	cmp	r0, #0
c0d050ea:	d019      	beq.n	c0d05120 <u2f_transport_received+0xd8>
c0d050ec:	2103      	movs	r1, #3
        // on USB we could get an INIT within a flow of segments.
        || (media == U2F_MEDIA_USB && os_memcmp(service->transportChannel, service->channel, 4) != 0) ) {
        if (size < (channelHeader + 3)) {
c0d050ee:	4638      	mov	r0, r7
c0d050f0:	4308      	orrs	r0, r1
c0d050f2:	42b0      	cmp	r0, r6
c0d050f4:	d818      	bhi.n	c0d05128 <u2f_transport_received+0xe0>
c0d050f6:	9101      	str	r1, [sp, #4]
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        // check this is a command, cannot accept continuation without previous command
        if ((buffer[channelHeader+0]&U2F_MASK_COMMAND) == 0) {
c0d050f8:	19d0      	adds	r0, r2, r7
c0d050fa:	9003      	str	r0, [sp, #12]
c0d050fc:	4615      	mov	r5, r2
c0d050fe:	57d0      	ldrsb	r0, [r2, r7]
c0d05100:	217a      	movs	r1, #122	; 0x7a
c0d05102:	43c9      	mvns	r1, r1
c0d05104:	317a      	adds	r1, #122	; 0x7a
c0d05106:	b249      	sxtb	r1, r1
c0d05108:	2285      	movs	r2, #133	; 0x85
c0d0510a:	4288      	cmp	r0, r1
c0d0510c:	dd47      	ble.n	c0d0519e <u2f_transport_received+0x156>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0510e:	48ae      	ldr	r0, [pc, #696]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d05110:	2104      	movs	r1, #4
c0d05112:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05114:	323a      	adds	r2, #58	; 0x3a
c0d05116:	4615      	mov	r5, r2
c0d05118:	2234      	movs	r2, #52	; 0x34
c0d0511a:	54a5      	strb	r5, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0511c:	75a3      	strb	r3, [r4, #22]
c0d0511e:	e00d      	b.n	c0d0513c <u2f_transport_received+0xf4>
c0d05120:	2002      	movs	r0, #2
        }
    } else {


        // Continuation
        if (size < (channelHeader + 2)) {
c0d05122:	4338      	orrs	r0, r7
c0d05124:	42b0      	cmp	r0, r6
c0d05126:	d915      	bls.n	c0d05154 <u2f_transport_received+0x10c>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05128:	48a7      	ldr	r0, [pc, #668]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d0512a:	2185      	movs	r1, #133	; 0x85
c0d0512c:	7201      	strb	r1, [r0, #8]
c0d0512e:	217a      	movs	r1, #122	; 0x7a
c0d05130:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05132:	313a      	adds	r1, #58	; 0x3a
c0d05134:	2234      	movs	r2, #52	; 0x34
c0d05136:	54a1      	strb	r1, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d05138:	75a3      	strb	r3, [r4, #22]
c0d0513a:	2104      	movs	r1, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d0513c:	7721      	strb	r1, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d0513e:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d05140:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d05142:	8263      	strh	r3, [r4, #18]
c0d05144:	2001      	movs	r0, #1
    service->transportLength = 1;
c0d05146:	82a0      	strh	r0, [r4, #20]
    service->sendCmd = U2F_STATUS_ERROR;
    // pump the first message, with the reception media
    u2f_transport_sent(service, service->media);
c0d05148:	7921      	ldrb	r1, [r4, #4]
c0d0514a:	4620      	mov	r0, r4
c0d0514c:	f7ff ff16 	bl	c0d04f7c <u2f_transport_sent>
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
    }
error:
    return;
}
c0d05150:	b007      	add	sp, #28
c0d05152:	bdf0      	pop	{r4, r5, r6, r7, pc}
        if (size < (channelHeader + 2)) {
            // Message to short, abort
            u2f_transport_error(service, ERROR_PROP_MESSAGE_TOO_SHORT);
            goto error;
        }
        if (media != service->transportMedia) {
c0d05154:	7f60      	ldrb	r0, [r4, #29]
c0d05156:	42a8      	cmp	r0, r5
c0d05158:	d15a      	bne.n	c0d05210 <u2f_transport_received+0x1c8>
            // Mixed medias
            u2f_transport_error(service, ERROR_PROP_MEDIA_MIXED);
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
c0d0515a:	7f20      	ldrb	r0, [r4, #28]
c0d0515c:	2801      	cmp	r0, #1
c0d0515e:	d166      	bne.n	c0d0522e <u2f_transport_received+0x1e6>
            } else {
                u2f_transport_error(service, ERROR_INVALID_SEQ);
                goto error;
            }
        }
        if (media == U2F_MEDIA_USB) {
c0d05160:	2d01      	cmp	r5, #1
c0d05162:	d000      	beq.n	c0d05166 <u2f_transport_received+0x11e>
c0d05164:	e089      	b.n	c0d0527a <u2f_transport_received+0x232>
c0d05166:	2004      	movs	r0, #4
            // Check the channel
            if (os_memcmp(buffer, service->channel, 4) != 0) {
c0d05168:	9003      	str	r0, [sp, #12]
c0d0516a:	4610      	mov	r0, r2
c0d0516c:	4621      	mov	r1, r4
c0d0516e:	4615      	mov	r5, r2
c0d05170:	9a03      	ldr	r2, [sp, #12]
c0d05172:	4637      	mov	r7, r6
c0d05174:	461e      	mov	r6, r3
c0d05176:	f7fe fcc5 	bl	c0d03b04 <os_memcmp>
c0d0517a:	462a      	mov	r2, r5
c0d0517c:	9d06      	ldr	r5, [sp, #24]
c0d0517e:	4633      	mov	r3, r6
c0d05180:	463e      	mov	r6, r7
c0d05182:	9f05      	ldr	r7, [sp, #20]
c0d05184:	2800      	cmp	r0, #0
c0d05186:	d078      	beq.n	c0d0527a <u2f_transport_received+0x232>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05188:	488f      	ldr	r0, [pc, #572]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d0518a:	2106      	movs	r1, #6
c0d0518c:	7201      	strb	r1, [r0, #8]
c0d0518e:	217a      	movs	r1, #122	; 0x7a
c0d05190:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05192:	313a      	adds	r1, #58	; 0x3a
c0d05194:	2234      	movs	r2, #52	; 0x34
c0d05196:	54a1      	strb	r1, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d05198:	75a3      	strb	r3, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d0519a:	9903      	ldr	r1, [sp, #12]
c0d0519c:	e7ce      	b.n	c0d0513c <u2f_transport_received+0xf4>
c0d0519e:	9302      	str	r3, [sp, #8]
            goto error;
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
c0d051a0:	9806      	ldr	r0, [sp, #24]
c0d051a2:	2801      	cmp	r0, #1
c0d051a4:	d113      	bne.n	c0d051ce <u2f_transport_received+0x186>
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d051a6:	7f20      	ldrb	r0, [r4, #28]
c0d051a8:	2801      	cmp	r0, #1
c0d051aa:	d11c      	bne.n	c0d051e6 <u2f_transport_received+0x19e>
                (os_memcmp(service->channel, service->transportChannel, 4) !=
c0d051ac:	4621      	mov	r1, r4
c0d051ae:	310e      	adds	r1, #14
c0d051b0:	9200      	str	r2, [sp, #0]
c0d051b2:	2204      	movs	r2, #4
c0d051b4:	4620      	mov	r0, r4
c0d051b6:	f7fe fca5 	bl	c0d03b04 <os_memcmp>
c0d051ba:	9a00      	ldr	r2, [sp, #0]
                 0) &&
c0d051bc:	2800      	cmp	r0, #0
c0d051be:	d006      	beq.n	c0d051ce <u2f_transport_received+0x186>
                (buffer[channelHeader] != U2F_CMD_INIT)) {
c0d051c0:	9803      	ldr	r0, [sp, #12]
c0d051c2:	7800      	ldrb	r0, [r0, #0]
c0d051c4:	1c51      	adds	r1, r2, #1
c0d051c6:	b2c9      	uxtb	r1, r1
        }

        // If waiting for a continuation on a different channel, reply BUSY
        // immediately
        if (media == U2F_MEDIA_USB) {
            if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d051c8:	4288      	cmp	r0, r1
c0d051ca:	d000      	beq.n	c0d051ce <u2f_transport_received+0x186>
c0d051cc:	e0dd      	b.n	c0d0538a <u2f_transport_received+0x342>
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d051ce:	7f20      	ldrb	r0, [r4, #28]
c0d051d0:	2801      	cmp	r0, #1
c0d051d2:	d108      	bne.n	c0d051e6 <u2f_transport_received+0x19e>
            !((media == U2F_MEDIA_USB) &&
c0d051d4:	9806      	ldr	r0, [sp, #24]
c0d051d6:	2801      	cmp	r0, #1
c0d051d8:	d179      	bne.n	c0d052ce <u2f_transport_received+0x286>
              (buffer[channelHeader] == U2F_CMD_INIT))) {
c0d051da:	9803      	ldr	r0, [sp, #12]
c0d051dc:	7800      	ldrb	r0, [r0, #0]
c0d051de:	1c51      	adds	r1, r2, #1
c0d051e0:	b2c9      	uxtb	r1, r1
                goto error;
            }
        }
        // If a command was already sent, and we are not processing a INIT
        // command, abort
        if ((service->transportState == U2F_HANDLE_SEGMENTED) &&
c0d051e2:	4288      	cmp	r0, r1
c0d051e4:	d173      	bne.n	c0d052ce <u2f_transport_received+0x286>
c0d051e6:	2002      	movs	r0, #2
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        // Check the length
        uint16_t commandLength =
            (buffer[channelHeader + 1] << 8) | (buffer[channelHeader + 2]);
c0d051e8:	4338      	orrs	r0, r7
c0d051ea:	5c28      	ldrb	r0, [r5, r0]
c0d051ec:	9904      	ldr	r1, [sp, #16]
c0d051ee:	5c69      	ldrb	r1, [r5, r1]
c0d051f0:	0209      	lsls	r1, r1, #8
c0d051f2:	180f      	adds	r7, r1, r0
        if (commandLength > (service->transportReceiveBufferLength - 3)) {
c0d051f4:	89a0      	ldrh	r0, [r4, #12]
c0d051f6:	1ec0      	subs	r0, r0, #3
c0d051f8:	4287      	cmp	r7, r0
c0d051fa:	dd21      	ble.n	c0d05240 <u2f_transport_received+0x1f8>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d051fc:	4872      	ldr	r0, [pc, #456]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d051fe:	9901      	ldr	r1, [sp, #4]
c0d05200:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05202:	323a      	adds	r2, #58	; 0x3a
c0d05204:	2134      	movs	r1, #52	; 0x34
c0d05206:	5462      	strb	r2, [r4, r1]
c0d05208:	9a02      	ldr	r2, [sp, #8]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0520a:	75a2      	strb	r2, [r4, #22]
c0d0520c:	2104      	movs	r1, #4
c0d0520e:	e067      	b.n	c0d052e0 <u2f_transport_received+0x298>
c0d05210:	207a      	movs	r0, #122	; 0x7a
c0d05212:	43c0      	mvns	r0, r0
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05214:	4601      	mov	r1, r0
c0d05216:	3108      	adds	r1, #8
c0d05218:	4a6b      	ldr	r2, [pc, #428]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d0521a:	7211      	strb	r1, [r2, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d0521c:	303a      	adds	r0, #58	; 0x3a
c0d0521e:	2134      	movs	r1, #52	; 0x34
c0d05220:	5460      	strb	r0, [r4, r1]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d05222:	75a3      	strb	r3, [r4, #22]
c0d05224:	2004      	movs	r0, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05226:	7720      	strb	r0, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05228:	3208      	adds	r2, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d0522a:	61a2      	str	r2, [r4, #24]
c0d0522c:	e789      	b.n	c0d05142 <u2f_transport_received+0xfa>
            goto error;
        }
        if (service->transportState != U2F_HANDLE_SEGMENTED) {
            // Unexpected continuation at this stage, abort
            // TODO : review the behavior is HID only
            if (media == U2F_MEDIA_USB) {
c0d0522e:	2d01      	cmp	r5, #1
c0d05230:	d13e      	bne.n	c0d052b0 <u2f_transport_received+0x268>
c0d05232:	2000      	movs	r0, #0
#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
    service->transportOffset = 0;
c0d05234:	8260      	strh	r0, [r4, #18]

#warning TODO take into account the INIT during SEGMENTED message correctly (avoid erasing the first part of the apdu buffer when doing so)

// init
void u2f_transport_reset(u2f_service_t* service) {
    service->transportState = U2F_IDLE;
c0d05236:	83a0      	strh	r0, [r4, #28]
    service->transportOffset = 0;
    service->transportMedia = 0;
    service->transportPacketIndex = 0;
c0d05238:	75a0      	strb	r0, [r4, #22]
    // reset the receive buffer to allow for a new message to be received again (in case transmission of a CODE buffer the previous reply)
    service->transportBuffer = service->transportReceiveBuffer;
c0d0523a:	68a0      	ldr	r0, [r4, #8]
c0d0523c:	61a0      	str	r0, [r4, #24]
c0d0523e:	e787      	b.n	c0d05150 <u2f_transport_received+0x108>
            // Overflow in message size, abort
            u2f_transport_error(service, ERROR_INVALID_LEN);
            goto error;
        }
        // Check if the command is supported
        switch (buffer[channelHeader]) {
c0d05240:	9803      	ldr	r0, [sp, #12]
c0d05242:	7800      	ldrb	r0, [r0, #0]
c0d05244:	2881      	cmp	r0, #129	; 0x81
c0d05246:	9b02      	ldr	r3, [sp, #8]
c0d05248:	9d06      	ldr	r5, [sp, #24]
c0d0524a:	d004      	beq.n	c0d05256 <u2f_transport_received+0x20e>
c0d0524c:	2886      	cmp	r0, #134	; 0x86
c0d0524e:	d04c      	beq.n	c0d052ea <u2f_transport_received+0x2a2>
c0d05250:	2883      	cmp	r0, #131	; 0x83
c0d05252:	d000      	beq.n	c0d05256 <u2f_transport_received+0x20e>
c0d05254:	e084      	b.n	c0d05360 <u2f_transport_received+0x318>
c0d05256:	9200      	str	r2, [sp, #0]
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
c0d05258:	2d01      	cmp	r5, #1
c0d0525a:	d152      	bne.n	c0d05302 <u2f_transport_received+0x2ba>
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d0525c:	495b      	ldr	r1, [pc, #364]	; (c0d053cc <u2f_transport_received+0x384>)
c0d0525e:	4479      	add	r1, pc
c0d05260:	2204      	movs	r2, #4
c0d05262:	4620      	mov	r0, r4
c0d05264:	9204      	str	r2, [sp, #16]
c0d05266:	f7fe fc4d 	bl	c0d03b04 <os_memcmp>
        // Check if the command is supported
        switch (buffer[channelHeader]) {
        case U2F_CMD_PING:
        case U2F_CMD_MSG:
            if (media == U2F_MEDIA_USB) {
                if (u2f_is_channel_broadcast(service->channel) ||
c0d0526a:	2800      	cmp	r0, #0
c0d0526c:	d100      	bne.n	c0d05270 <u2f_transport_received+0x228>
c0d0526e:	e0a0      	b.n	c0d053b2 <u2f_transport_received+0x36a>
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d05270:	4957      	ldr	r1, [pc, #348]	; (c0d053d0 <u2f_transport_received+0x388>)
c0d05272:	4479      	add	r1, pc
c0d05274:	2204      	movs	r2, #4
c0d05276:	4620      	mov	r0, r4
c0d05278:	e03f      	b.n	c0d052fa <u2f_transport_received+0x2b2>
                u2f_transport_error(service, ERROR_CHANNEL_BUSY);
                goto error;
            }
        }
        // also discriminate invalid command sent instead of a continuation
        if (buffer[channelHeader] != service->transportPacketIndex) {
c0d0527a:	19d1      	adds	r1, r2, r7
c0d0527c:	5dd0      	ldrb	r0, [r2, r7]
c0d0527e:	7da2      	ldrb	r2, [r4, #22]
c0d05280:	4290      	cmp	r0, r2
c0d05282:	d115      	bne.n	c0d052b0 <u2f_transport_received+0x268>
c0d05284:	9302      	str	r3, [sp, #8]
            // Bad continuation packet, abort
            u2f_transport_error(service, ERROR_INVALID_SEQ);
            goto error;
        }
        xfer_len = MIN(size - (channelHeader + 1), service->transportLength - service->transportOffset);
c0d05286:	9804      	ldr	r0, [sp, #16]
c0d05288:	1a36      	subs	r6, r6, r0
c0d0528a:	8a60      	ldrh	r0, [r4, #18]
c0d0528c:	8aa2      	ldrh	r2, [r4, #20]
c0d0528e:	1a12      	subs	r2, r2, r0
c0d05290:	4296      	cmp	r6, r2
c0d05292:	db00      	blt.n	c0d05296 <u2f_transport_received+0x24e>
c0d05294:	4616      	mov	r6, r2
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
c0d05296:	b2b2      	uxth	r2, r6
c0d05298:	69a3      	ldr	r3, [r4, #24]
c0d0529a:	1818      	adds	r0, r3, r0
c0d0529c:	1c49      	adds	r1, r1, #1
c0d0529e:	f7fe fb76 	bl	c0d0398e <os_memmove>
        service->transportOffset += xfer_len;
c0d052a2:	8a60      	ldrh	r0, [r4, #18]
c0d052a4:	1980      	adds	r0, r0, r6
c0d052a6:	8260      	strh	r0, [r4, #18]
        service->transportPacketIndex++;
c0d052a8:	7da0      	ldrb	r0, [r4, #22]
c0d052aa:	1c40      	adds	r0, r0, #1
c0d052ac:	75a0      	strb	r0, [r4, #22]
c0d052ae:	e03e      	b.n	c0d0532e <u2f_transport_received+0x2e6>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d052b0:	4845      	ldr	r0, [pc, #276]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d052b2:	2104      	movs	r1, #4
c0d052b4:	7201      	strb	r1, [r0, #8]
c0d052b6:	227a      	movs	r2, #122	; 0x7a
c0d052b8:	43d2      	mvns	r2, r2
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d052ba:	323a      	adds	r2, #58	; 0x3a
c0d052bc:	461d      	mov	r5, r3
c0d052be:	2334      	movs	r3, #52	; 0x34
c0d052c0:	54e2      	strb	r2, [r4, r3]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d052c2:	75a5      	strb	r5, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d052c4:	7721      	strb	r1, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d052c6:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d052c8:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d052ca:	8265      	strh	r5, [r4, #18]
c0d052cc:	e73a      	b.n	c0d05144 <u2f_transport_received+0xfc>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d052ce:	483e      	ldr	r0, [pc, #248]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d052d0:	2104      	movs	r1, #4
c0d052d2:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d052d4:	323a      	adds	r2, #58	; 0x3a
c0d052d6:	4613      	mov	r3, r2
c0d052d8:	2234      	movs	r2, #52	; 0x34
c0d052da:	54a3      	strb	r3, [r4, r2]
c0d052dc:	9a02      	ldr	r2, [sp, #8]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d052de:	75a2      	strb	r2, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d052e0:	7721      	strb	r1, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d052e2:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d052e4:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d052e6:	8262      	strh	r2, [r4, #18]
c0d052e8:	e72c      	b.n	c0d05144 <u2f_transport_received+0xfc>
                }
            }
            // no channel for BLE
            break;
        case U2F_CMD_INIT:
            if (media != U2F_MEDIA_USB) {
c0d052ea:	2d01      	cmp	r5, #1
c0d052ec:	d138      	bne.n	c0d05360 <u2f_transport_received+0x318>
c0d052ee:	9200      	str	r2, [sp, #0]
bool u2f_is_channel_broadcast(uint8_t *channel) {
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
}

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
c0d052f0:	4938      	ldr	r1, [pc, #224]	; (c0d053d4 <u2f_transport_received+0x38c>)
c0d052f2:	4479      	add	r1, pc
c0d052f4:	2204      	movs	r2, #4
c0d052f6:	4620      	mov	r0, r4
c0d052f8:	9204      	str	r2, [sp, #16]
c0d052fa:	f7fe fc03 	bl	c0d03b04 <os_memcmp>
c0d052fe:	2800      	cmp	r0, #0
c0d05300:	d057      	beq.n	c0d053b2 <u2f_transport_received+0x36a>
        }

        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
c0d05302:	9805      	ldr	r0, [sp, #20]
c0d05304:	1a36      	subs	r6, r6, r0
c0d05306:	1cff      	adds	r7, r7, #3
c0d05308:	42be      	cmp	r6, r7
c0d0530a:	db00      	blt.n	c0d0530e <u2f_transport_received+0x2c6>
c0d0530c:	463e      	mov	r6, r7
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
c0d0530e:	b2b2      	uxth	r2, r6
c0d05310:	69a0      	ldr	r0, [r4, #24]
c0d05312:	9903      	ldr	r1, [sp, #12]
c0d05314:	f7fe fb3b 	bl	c0d0398e <os_memmove>
            service->transportOffset = xfer_len;
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
c0d05318:	82a7      	strh	r7, [r4, #20]
        // Ok, initialize the buffer
        //if (buffer[channelHeader] != U2F_CMD_INIT) 
        {
            xfer_len = MIN(size - (channelHeader), U2F_COMMAND_HEADER_SIZE+commandLength);
            os_memmove(service->transportBuffer, buffer + channelHeader, xfer_len);
            service->transportOffset = xfer_len;
c0d0531a:	8266      	strh	r6, [r4, #18]
            service->transportLength = U2F_COMMAND_HEADER_SIZE+commandLength;
            service->transportMedia = media;
c0d0531c:	7765      	strb	r5, [r4, #29]
            // initialize the response
            service->transportPacketIndex = 0;
c0d0531e:	9802      	ldr	r0, [sp, #8]
c0d05320:	75a0      	strb	r0, [r4, #22]
            os_memmove(service->transportChannel, service->channel, 4);
c0d05322:	4620      	mov	r0, r4
c0d05324:	300e      	adds	r0, #14
c0d05326:	2204      	movs	r2, #4
c0d05328:	4621      	mov	r1, r4
c0d0532a:	f7fe fb30 	bl	c0d0398e <os_memmove>
c0d0532e:	8a60      	ldrh	r0, [r4, #18]
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d05330:	2d01      	cmp	r5, #1
c0d05332:	d101      	bne.n	c0d05338 <u2f_transport_received+0x2f0>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d05334:	8aa1      	ldrh	r1, [r4, #20]
c0d05336:	e00c      	b.n	c0d05352 <u2f_transport_received+0x30a>
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
c0d05338:	8aa1      	ldrh	r1, [r4, #20]
c0d0533a:	1cca      	adds	r2, r1, #3
        os_memmove(service->transportBuffer + service->transportOffset, buffer + channelHeader + 1, xfer_len);
        service->transportOffset += xfer_len;
        service->transportPacketIndex++;
    }
    // See if we can process the command
    if ((media != U2F_MEDIA_USB) &&
c0d0533c:	4282      	cmp	r2, r0
c0d0533e:	d208      	bcs.n	c0d05352 <u2f_transport_received+0x30a>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05340:	4821      	ldr	r0, [pc, #132]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d05342:	2103      	movs	r1, #3
c0d05344:	7201      	strb	r1, [r0, #8]
c0d05346:	217a      	movs	r1, #122	; 0x7a
c0d05348:	43c9      	mvns	r1, r1
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d0534a:	313a      	adds	r1, #58	; 0x3a
c0d0534c:	2234      	movs	r2, #52	; 0x34
c0d0534e:	54a1      	strb	r1, [r4, r2]
c0d05350:	e75a      	b.n	c0d05208 <u2f_transport_received+0x1c0>
        (service->transportOffset >
         (service->transportLength + U2F_COMMAND_HEADER_SIZE))) {
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
c0d05352:	4288      	cmp	r0, r1
c0d05354:	d213      	bcs.n	c0d0537e <u2f_transport_received+0x336>
c0d05356:	2001      	movs	r0, #1
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
        service->transportState = U2F_HANDLE_SEGMENTED;
c0d05358:	7720      	strb	r0, [r4, #28]
c0d0535a:	2000      	movs	r0, #0
        service->transportState = U2F_PROCESSING_COMMAND;
        // internal notification of a complete message received
        u2f_message_complete(service);
    } else {
        // new segment received, reset the timeout for the current piece
        service->seqTimeout = 0;
c0d0535c:	62a0      	str	r0, [r4, #40]	; 0x28
c0d0535e:	e6f7      	b.n	c0d05150 <u2f_transport_received+0x108>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05360:	4819      	ldr	r0, [pc, #100]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d05362:	2101      	movs	r1, #1
c0d05364:	7201      	strb	r1, [r0, #8]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d05366:	323a      	adds	r2, #58	; 0x3a
c0d05368:	4615      	mov	r5, r2
c0d0536a:	2234      	movs	r2, #52	; 0x34
c0d0536c:	54a5      	strb	r5, [r4, r2]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d0536e:	75a3      	strb	r3, [r4, #22]
c0d05370:	2204      	movs	r2, #4
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d05372:	7722      	strb	r2, [r4, #28]
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d05374:	3008      	adds	r0, #8

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
c0d05376:	61a0      	str	r0, [r4, #24]
    service->transportOffset = 0;
c0d05378:	8263      	strh	r3, [r4, #18]
    service->transportLength = 1;
c0d0537a:	82a1      	strh	r1, [r4, #20]
c0d0537c:	e6e4      	b.n	c0d05148 <u2f_transport_received+0x100>
c0d0537e:	2002      	movs	r0, #2
        // Overflow, abort
        u2f_transport_error(service, ERROR_INVALID_LEN);
        goto error;
    } else if (service->transportOffset >= service->transportLength) {
        // switch before the handler gets the opportunity to change it again
        service->transportState = U2F_PROCESSING_COMMAND;
c0d05380:	7720      	strb	r0, [r4, #28]
        // internal notification of a complete message received
        u2f_message_complete(service);
c0d05382:	4620      	mov	r0, r4
c0d05384:	f7ff fdba 	bl	c0d04efc <u2f_message_complete>
c0d05388:	e6e2      	b.n	c0d05150 <u2f_transport_received+0x108>
                // special error case, we reply but don't change the current state of the transport (ongoing message for example)
                //u2f_transport_error_no_reset(service, ERROR_CHANNEL_BUSY);
                uint16_t offset = 0;
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
c0d0538a:	4d0f      	ldr	r5, [pc, #60]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d0538c:	4616      	mov	r6, r2
c0d0538e:	2204      	movs	r2, #4
c0d05390:	4628      	mov	r0, r5
c0d05392:	4621      	mov	r1, r4
c0d05394:	f7fe fafb 	bl	c0d0398e <os_memmove>
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
                G_io_usb_ep_buffer[offset++] = 0;
c0d05398:	9802      	ldr	r0, [sp, #8]
c0d0539a:	7168      	strb	r0, [r5, #5]
                // Fragment
                if (media == U2F_MEDIA_USB) {
                    os_memmove(G_io_usb_ep_buffer, service->channel, 4);
                    offset += 4;
                }
                G_io_usb_ep_buffer[offset++] = U2F_STATUS_ERROR;
c0d0539c:	363a      	adds	r6, #58	; 0x3a
c0d0539e:	712e      	strb	r6, [r5, #4]
c0d053a0:	2201      	movs	r2, #1
                G_io_usb_ep_buffer[offset++] = 0;
                G_io_usb_ep_buffer[offset++] = 1;
c0d053a2:	71aa      	strb	r2, [r5, #6]
c0d053a4:	2006      	movs	r0, #6
                G_io_usb_ep_buffer[offset++] = ERROR_CHANNEL_BUSY;
c0d053a6:	71e8      	strb	r0, [r5, #7]
c0d053a8:	2108      	movs	r1, #8
                u2f_io_send(G_io_usb_ep_buffer, offset, media);
c0d053aa:	4628      	mov	r0, r5
c0d053ac:	f7ff fdc4 	bl	c0d04f38 <u2f_io_send>
c0d053b0:	e6ce      	b.n	c0d05150 <u2f_transport_received+0x108>
/**
 * Reply an error at the U2F transport level (take into account the FIDO U2F framing)
 */
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;
c0d053b2:	4805      	ldr	r0, [pc, #20]	; (c0d053c8 <u2f_transport_received+0x380>)
c0d053b4:	210b      	movs	r1, #11
c0d053b6:	7201      	strb	r1, [r0, #8]
c0d053b8:	9a00      	ldr	r2, [sp, #0]
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
    service->transportBuffer = G_io_usb_ep_buffer + 8;
    service->transportOffset = 0;
    service->transportLength = 1;
    service->sendCmd = U2F_STATUS_ERROR;
c0d053ba:	323a      	adds	r2, #58	; 0x3a
c0d053bc:	2134      	movs	r1, #52	; 0x34
c0d053be:	5462      	strb	r2, [r4, r1]
c0d053c0:	9902      	ldr	r1, [sp, #8]
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
    service->transportPacketIndex = 0;
c0d053c2:	75a1      	strb	r1, [r4, #22]
static void u2f_transport_error(u2f_service_t *service, char errorCode) {
    //u2f_transport_reset(service); // warning reset first to allow for U2F_io sent call to u2f_transport_sent internally on eventless platforms
    G_io_usb_ep_buffer[8] = errorCode;

    // ensure the state is set to error sending to allow for special treatment in case reply is not read by the receiver
    service->transportState = U2F_SENDING_ERROR;
c0d053c4:	9a04      	ldr	r2, [sp, #16]
c0d053c6:	e654      	b.n	c0d05072 <u2f_transport_received+0x2a>
c0d053c8:	20002370 	.word	0x20002370
c0d053cc:	000027e4 	.word	0x000027e4
c0d053d0:	000027d4 	.word	0x000027d4
c0d053d4:	00002754 	.word	0x00002754

c0d053d8 <u2f_is_channel_broadcast>:
    }
error:
    return;
}

bool u2f_is_channel_broadcast(uint8_t *channel) {
c0d053d8:	b580      	push	{r7, lr}
    return (os_memcmp(channel, BROADCAST_CHANNEL, 4) == 0);
c0d053da:	4904      	ldr	r1, [pc, #16]	; (c0d053ec <u2f_is_channel_broadcast+0x14>)
c0d053dc:	4479      	add	r1, pc
c0d053de:	2204      	movs	r2, #4
c0d053e0:	f7fe fb90 	bl	c0d03b04 <os_memcmp>
c0d053e4:	2100      	movs	r1, #0
c0d053e6:	1a09      	subs	r1, r1, r0
c0d053e8:	4148      	adcs	r0, r1
c0d053ea:	bd80      	pop	{r7, pc}
c0d053ec:	00002666 	.word	0x00002666

c0d053f0 <u2f_message_reply>:

bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
c0d053f0:	b510      	push	{r4, lr}
c0d053f2:	2434      	movs	r4, #52	; 0x34
    service->transportState = U2F_SENDING_RESPONSE;
    service->transportPacketIndex = 0;
    service->transportBuffer = buffer;
    service->transportOffset = 0;
    service->transportLength = len;
    service->sendCmd = cmd;
c0d053f4:	5501      	strb	r1, [r0, r4]
c0d053f6:	2100      	movs	r1, #0
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
    service->transportState = U2F_SENDING_RESPONSE;
    service->transportPacketIndex = 0;
c0d053f8:	7581      	strb	r1, [r0, #22]
c0d053fa:	2403      	movs	r4, #3
bool u2f_is_channel_forbidden(uint8_t *channel) {
    return (os_memcmp(channel, FORBIDDEN_CHANNEL, 4) == 0);
}

void u2f_message_reply(u2f_service_t *service, uint8_t cmd, uint8_t *buffer, uint16_t len) {
    service->transportState = U2F_SENDING_RESPONSE;
c0d053fc:	7704      	strb	r4, [r0, #28]
    service->transportPacketIndex = 0;
    service->transportBuffer = buffer;
c0d053fe:	6182      	str	r2, [r0, #24]
    service->transportOffset = 0;
c0d05400:	8241      	strh	r1, [r0, #18]
    service->transportLength = len;
c0d05402:	8283      	strh	r3, [r0, #20]
    service->sendCmd = cmd;
    // pump the first message
    u2f_transport_sent(service, service->transportMedia);
c0d05404:	7f41      	ldrb	r1, [r0, #29]
c0d05406:	f7ff fdb9 	bl	c0d04f7c <u2f_transport_sent>
}
c0d0540a:	bd10      	pop	{r4, pc}

c0d0540c <USBD_LL_Init>:
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
  ep_out_stall = 0;
c0d0540c:	4902      	ldr	r1, [pc, #8]	; (c0d05418 <USBD_LL_Init+0xc>)
c0d0540e:	2000      	movs	r0, #0
c0d05410:	6008      	str	r0, [r1, #0]
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Init (USBD_HandleTypeDef *pdev)
{ 
  UNUSED(pdev);
  ep_in_stall = 0;
c0d05412:	4902      	ldr	r1, [pc, #8]	; (c0d0541c <USBD_LL_Init+0x10>)
c0d05414:	6008      	str	r0, [r1, #0]
  ep_out_stall = 0;
  return USBD_OK;
c0d05416:	4770      	bx	lr
c0d05418:	200023b4 	.word	0x200023b4
c0d0541c:	200023b0 	.word	0x200023b0

c0d05420 <USBD_LL_DeInit>:
  * @brief  De-Initializes the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
c0d05420:	b510      	push	{r4, lr}
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05422:	4807      	ldr	r0, [pc, #28]	; (c0d05440 <USBD_LL_DeInit+0x20>)
c0d05424:	2400      	movs	r4, #0
  G_io_seproxyhal_spi_buffer[1] = 0;
c0d05426:	7044      	strb	r4, [r0, #1]
c0d05428:	214f      	movs	r1, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_DeInit (USBD_HandleTypeDef *pdev)
{
  UNUSED(pdev);
  // usb off
  G_io_seproxyhal_spi_buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0542a:	7001      	strb	r1, [r0, #0]
c0d0542c:	2101      	movs	r1, #1
  G_io_seproxyhal_spi_buffer[1] = 0;
  G_io_seproxyhal_spi_buffer[2] = 1;
c0d0542e:	7081      	strb	r1, [r0, #2]
c0d05430:	2102      	movs	r1, #2
  G_io_seproxyhal_spi_buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d05432:	70c1      	strb	r1, [r0, #3]
c0d05434:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(G_io_seproxyhal_spi_buffer, 4);
c0d05436:	f7ff fbf7 	bl	c0d04c28 <io_seproxyhal_spi_send>

  return USBD_OK; 
c0d0543a:	4620      	mov	r0, r4
c0d0543c:	bd10      	pop	{r4, pc}
c0d0543e:	46c0      	nop			; (mov r8, r8)
c0d05440:	20001800 	.word	0x20001800

c0d05444 <USBD_LL_Start>:
  * @brief  Starts the Low Level portion of the Device driver. 
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Start(USBD_HandleTypeDef *pdev)
{
c0d05444:	b570      	push	{r4, r5, r6, lr}
c0d05446:	b082      	sub	sp, #8
c0d05448:	466d      	mov	r5, sp
c0d0544a:	2400      	movs	r4, #0
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d0544c:	706c      	strb	r4, [r5, #1]
c0d0544e:	264f      	movs	r6, #79	; 0x4f
{
  uint8_t buffer[5];
  UNUSED(pdev);

  // reset address
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05450:	702e      	strb	r6, [r5, #0]
c0d05452:	2002      	movs	r0, #2
  buffer[1] = 0;
  buffer[2] = 2;
c0d05454:	70a8      	strb	r0, [r5, #2]
c0d05456:	2003      	movs	r0, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d05458:	70e8      	strb	r0, [r5, #3]
  buffer[4] = 0;
c0d0545a:	712c      	strb	r4, [r5, #4]
c0d0545c:	2105      	movs	r1, #5
  io_seproxyhal_spi_send(buffer, 5);
c0d0545e:	4628      	mov	r0, r5
c0d05460:	f7ff fbe2 	bl	c0d04c28 <io_seproxyhal_spi_send>
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d05464:	706c      	strb	r4, [r5, #1]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
  buffer[4] = 0;
  io_seproxyhal_spi_send(buffer, 5);
  
  // start usb operation
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05466:	702e      	strb	r6, [r5, #0]
c0d05468:	2001      	movs	r0, #1
  buffer[1] = 0;
  buffer[2] = 1;
c0d0546a:	70a8      	strb	r0, [r5, #2]
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_CONNECT;
c0d0546c:	70e8      	strb	r0, [r5, #3]
c0d0546e:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d05470:	4628      	mov	r0, r5
c0d05472:	f7ff fbd9 	bl	c0d04c28 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d05476:	4620      	mov	r0, r4
c0d05478:	b002      	add	sp, #8
c0d0547a:	bd70      	pop	{r4, r5, r6, pc}

c0d0547c <USBD_LL_Stop>:
  * @brief  Stops the Low Level portion of the Device driver.
  * @param  pdev: Device handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
c0d0547c:	b510      	push	{r4, lr}
c0d0547e:	b082      	sub	sp, #8
c0d05480:	a801      	add	r0, sp, #4
c0d05482:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d05484:	7044      	strb	r4, [r0, #1]
c0d05486:	214f      	movs	r1, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_Stop (USBD_HandleTypeDef *pdev)
{
  UNUSED(pdev);
  uint8_t buffer[4];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d05488:	7001      	strb	r1, [r0, #0]
c0d0548a:	2101      	movs	r1, #1
  buffer[1] = 0;
  buffer[2] = 1;
c0d0548c:	7081      	strb	r1, [r0, #2]
c0d0548e:	2102      	movs	r1, #2
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_DISCONNECT;
c0d05490:	70c1      	strb	r1, [r0, #3]
c0d05492:	2104      	movs	r1, #4
  io_seproxyhal_spi_send(buffer, 4);
c0d05494:	f7ff fbc8 	bl	c0d04c28 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d05498:	4620      	mov	r0, r4
c0d0549a:	b002      	add	sp, #8
c0d0549c:	bd10      	pop	{r4, pc}
	...

c0d054a0 <USBD_LL_OpenEP>:
  */
USBD_StatusTypeDef  USBD_LL_OpenEP  (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  ep_type,
                                      uint16_t ep_mps)
{
c0d054a0:	b5b0      	push	{r4, r5, r7, lr}
c0d054a2:	b082      	sub	sp, #8
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
  ep_out_stall = 0;
c0d054a4:	4814      	ldr	r0, [pc, #80]	; (c0d054f8 <USBD_LL_OpenEP+0x58>)
c0d054a6:	2400      	movs	r4, #0
c0d054a8:	6004      	str	r4, [r0, #0]
                                      uint16_t ep_mps)
{
  uint8_t buffer[8];
  UNUSED(pdev);

  ep_in_stall = 0;
c0d054aa:	4814      	ldr	r0, [pc, #80]	; (c0d054fc <USBD_LL_OpenEP+0x5c>)
c0d054ac:	6004      	str	r4, [r0, #0]
c0d054ae:	466d      	mov	r5, sp
c0d054b0:	204f      	movs	r0, #79	; 0x4f
  ep_out_stall = 0;

  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d054b2:	7028      	strb	r0, [r5, #0]
  buffer[1] = 0;
c0d054b4:	706c      	strb	r4, [r5, #1]
c0d054b6:	2005      	movs	r0, #5
  buffer[2] = 5;
c0d054b8:	70a8      	strb	r0, [r5, #2]
c0d054ba:	2004      	movs	r0, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d054bc:	70e8      	strb	r0, [r5, #3]
c0d054be:	2001      	movs	r0, #1
  buffer[4] = 1;
c0d054c0:	7128      	strb	r0, [r5, #4]
  buffer[5] = ep_addr;
c0d054c2:	7169      	strb	r1, [r5, #5]
  buffer[6] = 0;
c0d054c4:	71ac      	strb	r4, [r5, #6]
  switch(ep_type) {
c0d054c6:	2a01      	cmp	r2, #1
c0d054c8:	dc05      	bgt.n	c0d054d6 <USBD_LL_OpenEP+0x36>
c0d054ca:	2a00      	cmp	r2, #0
c0d054cc:	d00a      	beq.n	c0d054e4 <USBD_LL_OpenEP+0x44>
c0d054ce:	2a01      	cmp	r2, #1
c0d054d0:	d10a      	bne.n	c0d054e8 <USBD_LL_OpenEP+0x48>
c0d054d2:	2004      	movs	r0, #4
c0d054d4:	e006      	b.n	c0d054e4 <USBD_LL_OpenEP+0x44>
c0d054d6:	2a02      	cmp	r2, #2
c0d054d8:	d003      	beq.n	c0d054e2 <USBD_LL_OpenEP+0x42>
c0d054da:	2a03      	cmp	r2, #3
c0d054dc:	d104      	bne.n	c0d054e8 <USBD_LL_OpenEP+0x48>
c0d054de:	2002      	movs	r0, #2
c0d054e0:	e000      	b.n	c0d054e4 <USBD_LL_OpenEP+0x44>
c0d054e2:	2003      	movs	r0, #3
c0d054e4:	4669      	mov	r1, sp
c0d054e6:	7188      	strb	r0, [r1, #6]
c0d054e8:	4668      	mov	r0, sp
      break;
    case USBD_EP_TYPE_INTR:
      buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_INTERRUPT;
      break;
  }
  buffer[7] = ep_mps;
c0d054ea:	71c3      	strb	r3, [r0, #7]
c0d054ec:	2108      	movs	r1, #8
  io_seproxyhal_spi_send(buffer, 8);
c0d054ee:	f7ff fb9b 	bl	c0d04c28 <io_seproxyhal_spi_send>
c0d054f2:	2000      	movs	r0, #0
  return USBD_OK; 
c0d054f4:	b002      	add	sp, #8
c0d054f6:	bdb0      	pop	{r4, r5, r7, pc}
c0d054f8:	200023b4 	.word	0x200023b4
c0d054fc:	200023b0 	.word	0x200023b0

c0d05500 <USBD_LL_CloseEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d05500:	b510      	push	{r4, lr}
c0d05502:	b082      	sub	sp, #8
c0d05504:	4668      	mov	r0, sp
c0d05506:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d05508:	7044      	strb	r4, [r0, #1]
c0d0550a:	224f      	movs	r2, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_CloseEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  uint8_t buffer[8];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d0550c:	7002      	strb	r2, [r0, #0]
c0d0550e:	2205      	movs	r2, #5
  buffer[1] = 0;
  buffer[2] = 5;
c0d05510:	7082      	strb	r2, [r0, #2]
c0d05512:	2204      	movs	r2, #4
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ENDPOINTS;
c0d05514:	70c2      	strb	r2, [r0, #3]
c0d05516:	2201      	movs	r2, #1
  buffer[4] = 1;
c0d05518:	7102      	strb	r2, [r0, #4]
  buffer[5] = ep_addr;
c0d0551a:	7141      	strb	r1, [r0, #5]
  buffer[6] = SEPROXYHAL_TAG_USB_CONFIG_TYPE_DISABLED;
c0d0551c:	7184      	strb	r4, [r0, #6]
  buffer[7] = 0;
c0d0551e:	71c4      	strb	r4, [r0, #7]
c0d05520:	2108      	movs	r1, #8
  io_seproxyhal_spi_send(buffer, 8);
c0d05522:	f7ff fb81 	bl	c0d04c28 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d05526:	4620      	mov	r0, r4
c0d05528:	b002      	add	sp, #8
c0d0552a:	bd10      	pop	{r4, pc}

c0d0552c <USBD_LL_StallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
c0d0552c:	b5b0      	push	{r4, r5, r7, lr}
c0d0552e:	b082      	sub	sp, #8
c0d05530:	460d      	mov	r5, r1
c0d05532:	4668      	mov	r0, sp
c0d05534:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = 0;
c0d05536:	7044      	strb	r4, [r0, #1]
c0d05538:	2150      	movs	r1, #80	; 0x50
  */
USBD_StatusTypeDef  USBD_LL_StallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{ 
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0553a:	7001      	strb	r1, [r0, #0]
c0d0553c:	2103      	movs	r1, #3
  buffer[1] = 0;
  buffer[2] = 3;
c0d0553e:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d05540:	70c5      	strb	r5, [r0, #3]
c0d05542:	2140      	movs	r1, #64	; 0x40
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_STALL;
c0d05544:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d05546:	7144      	strb	r4, [r0, #5]
c0d05548:	2106      	movs	r1, #6
  io_seproxyhal_spi_send(buffer, 6);
c0d0554a:	f7ff fb6d 	bl	c0d04c28 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d0554e:	0628      	lsls	r0, r5, #24
c0d05550:	d501      	bpl.n	c0d05556 <USBD_LL_StallEP+0x2a>
c0d05552:	4807      	ldr	r0, [pc, #28]	; (c0d05570 <USBD_LL_StallEP+0x44>)
c0d05554:	e000      	b.n	c0d05558 <USBD_LL_StallEP+0x2c>
c0d05556:	4805      	ldr	r0, [pc, #20]	; (c0d0556c <USBD_LL_StallEP+0x40>)
c0d05558:	6801      	ldr	r1, [r0, #0]
c0d0555a:	227f      	movs	r2, #127	; 0x7f
c0d0555c:	4015      	ands	r5, r2
c0d0555e:	2201      	movs	r2, #1
c0d05560:	40aa      	lsls	r2, r5
c0d05562:	430a      	orrs	r2, r1
c0d05564:	6002      	str	r2, [r0, #0]
    ep_in_stall |= (1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall |= (1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d05566:	4620      	mov	r0, r4
c0d05568:	b002      	add	sp, #8
c0d0556a:	bdb0      	pop	{r4, r5, r7, pc}
c0d0556c:	200023b4 	.word	0x200023b4
c0d05570:	200023b0 	.word	0x200023b0

c0d05574 <USBD_LL_ClearStallEP>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
c0d05574:	b5b0      	push	{r4, r5, r7, lr}
c0d05576:	b082      	sub	sp, #8
c0d05578:	460d      	mov	r5, r1
c0d0557a:	4668      	mov	r0, sp
c0d0557c:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = 0;
c0d0557e:	7044      	strb	r4, [r0, #1]
c0d05580:	2150      	movs	r1, #80	; 0x50
  */
USBD_StatusTypeDef  USBD_LL_ClearStallEP (USBD_HandleTypeDef *pdev, uint8_t ep_addr)   
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d05582:	7001      	strb	r1, [r0, #0]
c0d05584:	2103      	movs	r1, #3
  buffer[1] = 0;
  buffer[2] = 3;
c0d05586:	7081      	strb	r1, [r0, #2]
  buffer[3] = ep_addr;
c0d05588:	70c5      	strb	r5, [r0, #3]
c0d0558a:	2180      	movs	r1, #128	; 0x80
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_UNSTALL;
c0d0558c:	7101      	strb	r1, [r0, #4]
  buffer[5] = 0;
c0d0558e:	7144      	strb	r4, [r0, #5]
c0d05590:	2106      	movs	r1, #6
  io_seproxyhal_spi_send(buffer, 6);
c0d05592:	f7ff fb49 	bl	c0d04c28 <io_seproxyhal_spi_send>
  if (ep_addr & 0x80) {
c0d05596:	0628      	lsls	r0, r5, #24
c0d05598:	d501      	bpl.n	c0d0559e <USBD_LL_ClearStallEP+0x2a>
c0d0559a:	4807      	ldr	r0, [pc, #28]	; (c0d055b8 <USBD_LL_ClearStallEP+0x44>)
c0d0559c:	e000      	b.n	c0d055a0 <USBD_LL_ClearStallEP+0x2c>
c0d0559e:	4805      	ldr	r0, [pc, #20]	; (c0d055b4 <USBD_LL_ClearStallEP+0x40>)
c0d055a0:	6801      	ldr	r1, [r0, #0]
c0d055a2:	227f      	movs	r2, #127	; 0x7f
c0d055a4:	4015      	ands	r5, r2
c0d055a6:	2201      	movs	r2, #1
c0d055a8:	40aa      	lsls	r2, r5
c0d055aa:	4391      	bics	r1, r2
c0d055ac:	6001      	str	r1, [r0, #0]
    ep_in_stall &= ~(1<<(ep_addr&0x7F));
  }
  else {
    ep_out_stall &= ~(1<<(ep_addr&0x7F)); 
  }
  return USBD_OK; 
c0d055ae:	4620      	mov	r0, r4
c0d055b0:	b002      	add	sp, #8
c0d055b2:	bdb0      	pop	{r4, r5, r7, pc}
c0d055b4:	200023b4 	.word	0x200023b4
c0d055b8:	200023b0 	.word	0x200023b0

c0d055bc <USBD_LL_IsStallEP>:
c0d055bc:	0608      	lsls	r0, r1, #24
c0d055be:	d501      	bpl.n	c0d055c4 <USBD_LL_IsStallEP+0x8>
c0d055c0:	4805      	ldr	r0, [pc, #20]	; (c0d055d8 <USBD_LL_IsStallEP+0x1c>)
c0d055c2:	e000      	b.n	c0d055c6 <USBD_LL_IsStallEP+0xa>
c0d055c4:	4803      	ldr	r0, [pc, #12]	; (c0d055d4 <USBD_LL_IsStallEP+0x18>)
c0d055c6:	7802      	ldrb	r2, [r0, #0]
c0d055c8:	207f      	movs	r0, #127	; 0x7f
c0d055ca:	4001      	ands	r1, r0
c0d055cc:	2001      	movs	r0, #1
c0d055ce:	4088      	lsls	r0, r1
c0d055d0:	4010      	ands	r0, r2
  }
  else
  {
    return ep_out_stall & (1<<(ep_addr&0x7F));
  }
}
c0d055d2:	4770      	bx	lr
c0d055d4:	200023b4 	.word	0x200023b4
c0d055d8:	200023b0 	.word	0x200023b0

c0d055dc <USBD_LL_SetUSBAddress>:
  * @param  pdev: Device handle
  * @param  ep_addr: Endpoint Number
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
c0d055dc:	b510      	push	{r4, lr}
c0d055de:	b082      	sub	sp, #8
c0d055e0:	4668      	mov	r0, sp
c0d055e2:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
  buffer[1] = 0;
c0d055e4:	7044      	strb	r4, [r0, #1]
c0d055e6:	224f      	movs	r2, #79	; 0x4f
  */
USBD_StatusTypeDef  USBD_LL_SetUSBAddress (USBD_HandleTypeDef *pdev, uint8_t dev_addr)   
{
  UNUSED(pdev);
  uint8_t buffer[5];
  buffer[0] = SEPROXYHAL_TAG_USB_CONFIG;
c0d055e8:	7002      	strb	r2, [r0, #0]
c0d055ea:	2202      	movs	r2, #2
  buffer[1] = 0;
  buffer[2] = 2;
c0d055ec:	7082      	strb	r2, [r0, #2]
c0d055ee:	2203      	movs	r2, #3
  buffer[3] = SEPROXYHAL_TAG_USB_CONFIG_ADDR;
c0d055f0:	70c2      	strb	r2, [r0, #3]
  buffer[4] = dev_addr;
c0d055f2:	7101      	strb	r1, [r0, #4]
c0d055f4:	2105      	movs	r1, #5
  io_seproxyhal_spi_send(buffer, 5);
c0d055f6:	f7ff fb17 	bl	c0d04c28 <io_seproxyhal_spi_send>
  return USBD_OK; 
c0d055fa:	4620      	mov	r0, r4
c0d055fc:	b002      	add	sp, #8
c0d055fe:	bd10      	pop	{r4, pc}

c0d05600 <USBD_LL_Transmit>:
  */
USBD_StatusTypeDef  USBD_LL_Transmit (USBD_HandleTypeDef *pdev, 
                                      uint8_t  ep_addr,                                      
                                      uint8_t  *pbuf,
                                      uint16_t  size)
{
c0d05600:	b5b0      	push	{r4, r5, r7, lr}
c0d05602:	b082      	sub	sp, #8
c0d05604:	461c      	mov	r4, r3
c0d05606:	4615      	mov	r5, r2
c0d05608:	4668      	mov	r0, sp
c0d0560a:	2250      	movs	r2, #80	; 0x50
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0560c:	7002      	strb	r2, [r0, #0]
  buffer[1] = (3+size)>>8;
  buffer[2] = (3+size);
  buffer[3] = ep_addr;
c0d0560e:	70c1      	strb	r1, [r0, #3]
c0d05610:	2120      	movs	r1, #32
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
c0d05612:	7101      	strb	r1, [r0, #4]
  buffer[5] = size;
c0d05614:	7143      	strb	r3, [r0, #5]
                                      uint16_t  size)
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = (3+size)>>8;
c0d05616:	1cd9      	adds	r1, r3, #3
  buffer[2] = (3+size);
c0d05618:	7081      	strb	r1, [r0, #2]
                                      uint16_t  size)
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = (3+size)>>8;
c0d0561a:	0a09      	lsrs	r1, r1, #8
c0d0561c:	7041      	strb	r1, [r0, #1]
c0d0561e:	2106      	movs	r1, #6
  buffer[2] = (3+size);
  buffer[3] = ep_addr;
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_IN;
  buffer[5] = size;
  io_seproxyhal_spi_send(buffer, 6);
c0d05620:	f7ff fb02 	bl	c0d04c28 <io_seproxyhal_spi_send>
  io_seproxyhal_spi_send(pbuf, size);
c0d05624:	4628      	mov	r0, r5
c0d05626:	4621      	mov	r1, r4
c0d05628:	f7ff fafe 	bl	c0d04c28 <io_seproxyhal_spi_send>
c0d0562c:	2000      	movs	r0, #0
  return USBD_OK;   
c0d0562e:	b002      	add	sp, #8
c0d05630:	bdb0      	pop	{r4, r5, r7, pc}

c0d05632 <USBD_LL_PrepareReceive>:
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_LL_PrepareReceive(USBD_HandleTypeDef *pdev, 
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
c0d05632:	b510      	push	{r4, lr}
c0d05634:	b082      	sub	sp, #8
c0d05636:	4668      	mov	r0, sp
c0d05638:	2400      	movs	r4, #0
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
  buffer[1] = (3/*+size*/)>>8;
c0d0563a:	7044      	strb	r4, [r0, #1]
c0d0563c:	2350      	movs	r3, #80	; 0x50
                                           uint8_t  ep_addr,
                                           uint16_t  size)
{
  UNUSED(pdev);
  uint8_t buffer[6];
  buffer[0] = SEPROXYHAL_TAG_USB_EP_PREPARE;
c0d0563e:	7003      	strb	r3, [r0, #0]
c0d05640:	2303      	movs	r3, #3
  buffer[1] = (3/*+size*/)>>8;
  buffer[2] = (3/*+size*/);
c0d05642:	7083      	strb	r3, [r0, #2]
  buffer[3] = ep_addr;
c0d05644:	70c1      	strb	r1, [r0, #3]
c0d05646:	2130      	movs	r1, #48	; 0x30
  buffer[4] = SEPROXYHAL_TAG_USB_EP_PREPARE_DIR_OUT;
c0d05648:	7101      	strb	r1, [r0, #4]
  buffer[5] = size; // expected size, not transmitted here !
c0d0564a:	7142      	strb	r2, [r0, #5]
c0d0564c:	2106      	movs	r1, #6
  io_seproxyhal_spi_send(buffer, 6);
c0d0564e:	f7ff faeb 	bl	c0d04c28 <io_seproxyhal_spi_send>
  return USBD_OK;   
c0d05652:	4620      	mov	r0, r4
c0d05654:	b002      	add	sp, #8
c0d05656:	bd10      	pop	{r4, pc}

c0d05658 <USBD_Init>:
* @param  pdesc: Descriptor structure address
* @param  id: Low level core index
* @retval None
*/
USBD_StatusTypeDef USBD_Init(USBD_HandleTypeDef *pdev, USBD_DescriptorsTypeDef *pdesc, uint8_t id)
{
c0d05658:	b570      	push	{r4, r5, r6, lr}
c0d0565a:	4604      	mov	r4, r0
c0d0565c:	2002      	movs	r0, #2
  /* Check whether the USB Host handle is valid */
  if(pdev == NULL)
c0d0565e:	2c00      	cmp	r4, #0
c0d05660:	d012      	beq.n	c0d05688 <USBD_Init+0x30>
c0d05662:	4615      	mov	r5, r2
c0d05664:	460e      	mov	r6, r1
c0d05666:	2045      	movs	r0, #69	; 0x45
c0d05668:	0081      	lsls	r1, r0, #2
  {
    USBD_ErrLog("Invalid Device handle");
    return USBD_FAIL; 
  }

  memset(pdev, 0, sizeof(USBD_HandleTypeDef));
c0d0566a:	4620      	mov	r0, r4
c0d0566c:	f000 ffd2 	bl	c0d06614 <__aeabi_memclr>
  
  /* Assign USBD Descriptors */
  if(pdesc != NULL)
c0d05670:	2e00      	cmp	r6, #0
c0d05672:	d001      	beq.n	c0d05678 <USBD_Init+0x20>
c0d05674:	20f0      	movs	r0, #240	; 0xf0
  {
    pdev->pDesc = pdesc;
c0d05676:	5026      	str	r6, [r4, r0]
c0d05678:	20dc      	movs	r0, #220	; 0xdc
c0d0567a:	2101      	movs	r1, #1
  }
  
  /* Set Device initial State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d0567c:	5421      	strb	r1, [r4, r0]
  pdev->id = id;
c0d0567e:	7025      	strb	r5, [r4, #0]
  /* Initialize low level driver */
  USBD_LL_Init(pdev);
c0d05680:	4620      	mov	r0, r4
c0d05682:	f7ff fec3 	bl	c0d0540c <USBD_LL_Init>
c0d05686:	2000      	movs	r0, #0
  
  return USBD_OK; 
}
c0d05688:	bd70      	pop	{r4, r5, r6, pc}

c0d0568a <USBD_DeInit>:
*         Re-Initialize th device library
* @param  pdev: device instance
* @retval status: status
*/
USBD_StatusTypeDef USBD_DeInit(USBD_HandleTypeDef *pdev)
{
c0d0568a:	b5b0      	push	{r4, r5, r7, lr}
c0d0568c:	4604      	mov	r4, r0
c0d0568e:	20dc      	movs	r0, #220	; 0xdc
c0d05690:	2101      	movs	r1, #1
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
c0d05692:	5421      	strb	r1, [r4, r0]
c0d05694:	2017      	movs	r0, #23
c0d05696:	43c5      	mvns	r5, r0
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if(pdev->interfacesClass[intf].pClass != NULL) {
c0d05698:	1960      	adds	r0, r4, r5
c0d0569a:	2143      	movs	r1, #67	; 0x43
c0d0569c:	0089      	lsls	r1, r1, #2
c0d0569e:	5840      	ldr	r0, [r0, r1]
c0d056a0:	2800      	cmp	r0, #0
c0d056a2:	d006      	beq.n	c0d056b2 <USBD_DeInit+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
c0d056a4:	6840      	ldr	r0, [r0, #4]
c0d056a6:	f7ff f85f 	bl	c0d04768 <pic>
c0d056aa:	4602      	mov	r2, r0
c0d056ac:	7921      	ldrb	r1, [r4, #4]
c0d056ae:	4620      	mov	r0, r4
c0d056b0:	4790      	blx	r2
  /* Set Default State */
  pdev->dev_state  = USBD_STATE_DEFAULT;
  
  /* Free Class Resources */
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d056b2:	3508      	adds	r5, #8
c0d056b4:	d1f0      	bne.n	c0d05698 <USBD_DeInit+0xe>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config);  
    }
  }
  
    /* Stop the low level driver  */
  USBD_LL_Stop(pdev); 
c0d056b6:	4620      	mov	r0, r4
c0d056b8:	f7ff fee0 	bl	c0d0547c <USBD_LL_Stop>
  
  /* Initialize low level driver */
  USBD_LL_DeInit(pdev);
c0d056bc:	4620      	mov	r0, r4
c0d056be:	f7ff feaf 	bl	c0d05420 <USBD_LL_DeInit>
c0d056c2:	2000      	movs	r0, #0
  
  return USBD_OK;
c0d056c4:	bdb0      	pop	{r4, r5, r7, pc}

c0d056c6 <USBD_RegisterClassForInterface>:
  * @param  pDevice : Device Handle
  * @param  pclass: Class handle
  * @retval USBD Status
  */
USBD_StatusTypeDef USBD_RegisterClassForInterface(uint8_t interfaceidx, USBD_HandleTypeDef *pdev, USBD_ClassTypeDef *pclass)
{
c0d056c6:	4603      	mov	r3, r0
c0d056c8:	2002      	movs	r0, #2
  USBD_StatusTypeDef   status = USBD_OK;
  if(pclass != 0)
c0d056ca:	2a00      	cmp	r2, #0
c0d056cc:	d007      	beq.n	c0d056de <USBD_RegisterClassForInterface+0x18>
c0d056ce:	2000      	movs	r0, #0
  {
    if (interfaceidx < USBD_MAX_NUM_INTERFACES) {
c0d056d0:	2b02      	cmp	r3, #2
c0d056d2:	d804      	bhi.n	c0d056de <USBD_RegisterClassForInterface+0x18>
      /* link the class to the USB Device handle */
      pdev->interfacesClass[interfaceidx].pClass = pclass;
c0d056d4:	00d8      	lsls	r0, r3, #3
c0d056d6:	1808      	adds	r0, r1, r0
c0d056d8:	21f4      	movs	r1, #244	; 0xf4
c0d056da:	5042      	str	r2, [r0, r1]
c0d056dc:	2000      	movs	r0, #0
  {
    USBD_ErrLog("Invalid Class handle");
    status = USBD_FAIL; 
  }
  
  return status;
c0d056de:	4770      	bx	lr

c0d056e0 <USBD_Start>:
  *         Start the USB Device Core.
  * @param  pdev: Device Handle
  * @retval USBD Status
  */
USBD_StatusTypeDef  USBD_Start  (USBD_HandleTypeDef *pdev)
{
c0d056e0:	b580      	push	{r7, lr}
  
  /* Start the low level driver  */
  USBD_LL_Start(pdev); 
c0d056e2:	f7ff feaf 	bl	c0d05444 <USBD_LL_Start>
c0d056e6:	2000      	movs	r0, #0
  
  return USBD_OK;  
c0d056e8:	bd80      	pop	{r7, pc}

c0d056ea <USBD_SetClassConfig>:
* @param  cfgidx: configuration index
* @retval status
*/

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d056ea:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d056ec:	b081      	sub	sp, #4
c0d056ee:	460c      	mov	r4, r1
c0d056f0:	4605      	mov	r5, r0
c0d056f2:	2600      	movs	r6, #0
c0d056f4:	27f4      	movs	r7, #244	; 0xf4
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if(usbd_is_valid_intf(pdev, intf)) {
c0d056f6:	4628      	mov	r0, r5
c0d056f8:	4631      	mov	r1, r6
c0d056fa:	f000 f969 	bl	c0d059d0 <usbd_is_valid_intf>
c0d056fe:	2800      	cmp	r0, #0
c0d05700:	d007      	beq.n	c0d05712 <USBD_SetClassConfig+0x28>
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
c0d05702:	59e8      	ldr	r0, [r5, r7]
c0d05704:	6800      	ldr	r0, [r0, #0]
c0d05706:	f7ff f82f 	bl	c0d04768 <pic>
c0d0570a:	4602      	mov	r2, r0
c0d0570c:	4628      	mov	r0, r5
c0d0570e:	4621      	mov	r1, r4
c0d05710:	4790      	blx	r2

USBD_StatusTypeDef USBD_SetClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Set configuration  and Start the Class*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05712:	3708      	adds	r7, #8
c0d05714:	1c76      	adds	r6, r6, #1
c0d05716:	2e03      	cmp	r6, #3
c0d05718:	d1ed      	bne.n	c0d056f6 <USBD_SetClassConfig+0xc>
c0d0571a:	2000      	movs	r0, #0
    if(usbd_is_valid_intf(pdev, intf)) {
      ((Init_t)PIC(pdev->interfacesClass[intf].pClass->Init))(pdev, cfgidx);
    }
  }

  return USBD_OK; 
c0d0571c:	b001      	add	sp, #4
c0d0571e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d05720 <USBD_ClrClassConfig>:
* @param  pdev: device instance
* @param  cfgidx: configuration index
* @retval status: USBD_StatusTypeDef
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
c0d05720:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05722:	b081      	sub	sp, #4
c0d05724:	460c      	mov	r4, r1
c0d05726:	4605      	mov	r5, r0
c0d05728:	2600      	movs	r6, #0
c0d0572a:	27f4      	movs	r7, #244	; 0xf4
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if(usbd_is_valid_intf(pdev, intf)) {
c0d0572c:	4628      	mov	r0, r5
c0d0572e:	4631      	mov	r1, r6
c0d05730:	f000 f94e 	bl	c0d059d0 <usbd_is_valid_intf>
c0d05734:	2800      	cmp	r0, #0
c0d05736:	d007      	beq.n	c0d05748 <USBD_ClrClassConfig+0x28>
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
c0d05738:	59e8      	ldr	r0, [r5, r7]
c0d0573a:	6840      	ldr	r0, [r0, #4]
c0d0573c:	f7ff f814 	bl	c0d04768 <pic>
c0d05740:	4602      	mov	r2, r0
c0d05742:	4628      	mov	r0, r5
c0d05744:	4621      	mov	r1, r4
c0d05746:	4790      	blx	r2
*/
USBD_StatusTypeDef USBD_ClrClassConfig(USBD_HandleTypeDef  *pdev, uint8_t cfgidx)
{
  /* Clear configuration  and De-initialize the Class process*/
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05748:	3708      	adds	r7, #8
c0d0574a:	1c76      	adds	r6, r6, #1
c0d0574c:	2e03      	cmp	r6, #3
c0d0574e:	d1ed      	bne.n	c0d0572c <USBD_ClrClassConfig+0xc>
c0d05750:	2000      	movs	r0, #0
    if(usbd_is_valid_intf(pdev, intf)) {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, cfgidx);  
    }
  }
  return USBD_OK;
c0d05752:	b001      	add	sp, #4
c0d05754:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d05756 <USBD_LL_SetupStage>:
*         Handle the setup stage
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetupStage(USBD_HandleTypeDef *pdev, uint8_t *psetup)
{
c0d05756:	b5b0      	push	{r4, r5, r7, lr}
c0d05758:	4604      	mov	r4, r0
  USBD_ParseSetupRequest(&pdev->request, psetup);
c0d0575a:	4605      	mov	r5, r0
c0d0575c:	35e8      	adds	r5, #232	; 0xe8
c0d0575e:	4628      	mov	r0, r5
c0d05760:	f000 fb7f 	bl	c0d05e62 <USBD_ParseSetupRequest>
c0d05764:	20d4      	movs	r0, #212	; 0xd4
c0d05766:	2101      	movs	r1, #1
  
  pdev->ep0_state = USBD_EP0_SETUP;
c0d05768:	5021      	str	r1, [r4, r0]
c0d0576a:	20ee      	movs	r0, #238	; 0xee
  pdev->ep0_data_len = pdev->request.wLength;
c0d0576c:	5a20      	ldrh	r0, [r4, r0]
c0d0576e:	21d8      	movs	r1, #216	; 0xd8
c0d05770:	5060      	str	r0, [r4, r1]
c0d05772:	20e8      	movs	r0, #232	; 0xe8
  
  switch (pdev->request.bmRequest & 0x1F) 
c0d05774:	5c21      	ldrb	r1, [r4, r0]
c0d05776:	201f      	movs	r0, #31
c0d05778:	4008      	ands	r0, r1
c0d0577a:	2802      	cmp	r0, #2
c0d0577c:	d008      	beq.n	c0d05790 <USBD_LL_SetupStage+0x3a>
c0d0577e:	2801      	cmp	r0, #1
c0d05780:	d00b      	beq.n	c0d0579a <USBD_LL_SetupStage+0x44>
c0d05782:	2800      	cmp	r0, #0
c0d05784:	d10e      	bne.n	c0d057a4 <USBD_LL_SetupStage+0x4e>
  {
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
c0d05786:	4620      	mov	r0, r4
c0d05788:	4629      	mov	r1, r5
c0d0578a:	f000 f92e 	bl	c0d059ea <USBD_StdDevReq>
c0d0578e:	e00e      	b.n	c0d057ae <USBD_LL_SetupStage+0x58>
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
c0d05790:	4620      	mov	r0, r4
c0d05792:	4629      	mov	r1, r5
c0d05794:	f000 fae1 	bl	c0d05d5a <USBD_StdEPReq>
c0d05798:	e009      	b.n	c0d057ae <USBD_LL_SetupStage+0x58>
  case USB_REQ_RECIPIENT_DEVICE:   
    USBD_StdDevReq (pdev, &pdev->request);
    break;
    
  case USB_REQ_RECIPIENT_INTERFACE:     
    USBD_StdItfReq(pdev, &pdev->request);
c0d0579a:	4620      	mov	r0, r4
c0d0579c:	4629      	mov	r1, r5
c0d0579e:	f000 fab8 	bl	c0d05d12 <USBD_StdItfReq>
c0d057a2:	e004      	b.n	c0d057ae <USBD_LL_SetupStage+0x58>
c0d057a4:	2080      	movs	r0, #128	; 0x80
  case USB_REQ_RECIPIENT_ENDPOINT:        
    USBD_StdEPReq(pdev, &pdev->request);   
    break;
    
  default:           
    USBD_LL_StallEP(pdev , pdev->request.bmRequest & 0x80);
c0d057a6:	4001      	ands	r1, r0
c0d057a8:	4620      	mov	r0, r4
c0d057aa:	f7ff febf 	bl	c0d0552c <USBD_LL_StallEP>
c0d057ae:	2000      	movs	r0, #0
    break;
  }  
  return USBD_OK;  
c0d057b0:	bdb0      	pop	{r4, r5, r7, pc}

c0d057b2 <USBD_LL_DataOutStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataOutStage(USBD_HandleTypeDef *pdev , uint8_t epnum, uint8_t *pdata)
{
c0d057b2:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d057b4:	b083      	sub	sp, #12
c0d057b6:	9202      	str	r2, [sp, #8]
c0d057b8:	4604      	mov	r4, r0
c0d057ba:	9101      	str	r1, [sp, #4]
  USBD_EndpointTypeDef    *pep;
  
  if(epnum == 0) 
c0d057bc:	2900      	cmp	r1, #0
c0d057be:	d01c      	beq.n	c0d057fa <USBD_LL_DataOutStage+0x48>
c0d057c0:	4625      	mov	r5, r4
c0d057c2:	35dc      	adds	r5, #220	; 0xdc
c0d057c4:	2700      	movs	r7, #0
c0d057c6:	26f4      	movs	r6, #244	; 0xf4
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d057c8:	4620      	mov	r0, r4
c0d057ca:	4639      	mov	r1, r7
c0d057cc:	f000 f900 	bl	c0d059d0 <usbd_is_valid_intf>
c0d057d0:	2800      	cmp	r0, #0
c0d057d2:	d00d      	beq.n	c0d057f0 <USBD_LL_DataOutStage+0x3e>
c0d057d4:	59a0      	ldr	r0, [r4, r6]
c0d057d6:	6980      	ldr	r0, [r0, #24]
c0d057d8:	2800      	cmp	r0, #0
c0d057da:	d009      	beq.n	c0d057f0 <USBD_LL_DataOutStage+0x3e>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d057dc:	7829      	ldrb	r1, [r5, #0]
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->DataOut != NULL)&&
c0d057de:	2903      	cmp	r1, #3
c0d057e0:	d106      	bne.n	c0d057f0 <USBD_LL_DataOutStage+0x3e>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
c0d057e2:	f7fe ffc1 	bl	c0d04768 <pic>
c0d057e6:	4603      	mov	r3, r0
c0d057e8:	4620      	mov	r0, r4
c0d057ea:	9901      	ldr	r1, [sp, #4]
c0d057ec:	9a02      	ldr	r2, [sp, #8]
c0d057ee:	4798      	blx	r3
    }
  }
  else {

    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d057f0:	3608      	adds	r6, #8
c0d057f2:	1c7f      	adds	r7, r7, #1
c0d057f4:	2f03      	cmp	r7, #3
c0d057f6:	d1e7      	bne.n	c0d057c8 <USBD_LL_DataOutStage+0x16>
c0d057f8:	e030      	b.n	c0d0585c <USBD_LL_DataOutStage+0xaa>
c0d057fa:	20d4      	movs	r0, #212	; 0xd4
  
  if(epnum == 0) 
  {
    pep = &pdev->ep_out[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_OUT)
c0d057fc:	5820      	ldr	r0, [r4, r0]
c0d057fe:	2803      	cmp	r0, #3
c0d05800:	d12c      	bne.n	c0d0585c <USBD_LL_DataOutStage+0xaa>
c0d05802:	2080      	movs	r0, #128	; 0x80
    {
      if(pep->rem_length > pep->maxpacket)
c0d05804:	5820      	ldr	r0, [r4, r0]
c0d05806:	6fe1      	ldr	r1, [r4, #124]	; 0x7c
c0d05808:	4281      	cmp	r1, r0
c0d0580a:	d90a      	bls.n	c0d05822 <USBD_LL_DataOutStage+0x70>
      {
        pep->rem_length -=  pep->maxpacket;
c0d0580c:	1a09      	subs	r1, r1, r0
c0d0580e:	67e1      	str	r1, [r4, #124]	; 0x7c
       
        USBD_CtlContinueRx (pdev, 
                            pdata,
                            MIN(pep->rem_length ,pep->maxpacket));
c0d05810:	4281      	cmp	r1, r0
c0d05812:	d300      	bcc.n	c0d05816 <USBD_LL_DataOutStage+0x64>
c0d05814:	4601      	mov	r1, r0
    {
      if(pep->rem_length > pep->maxpacket)
      {
        pep->rem_length -=  pep->maxpacket;
       
        USBD_CtlContinueRx (pdev, 
c0d05816:	b28a      	uxth	r2, r1
c0d05818:	4620      	mov	r0, r4
c0d0581a:	9902      	ldr	r1, [sp, #8]
c0d0581c:	f000 fd0e 	bl	c0d0623c <USBD_CtlContinueRx>
c0d05820:	e01c      	b.n	c0d0585c <USBD_LL_DataOutStage+0xaa>
c0d05822:	4626      	mov	r6, r4
c0d05824:	36dc      	adds	r6, #220	; 0xdc
c0d05826:	2500      	movs	r5, #0
c0d05828:	27f4      	movs	r7, #244	; 0xf4
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d0582a:	4620      	mov	r0, r4
c0d0582c:	4629      	mov	r1, r5
c0d0582e:	f000 f8cf 	bl	c0d059d0 <usbd_is_valid_intf>
c0d05832:	2800      	cmp	r0, #0
c0d05834:	d00b      	beq.n	c0d0584e <USBD_LL_DataOutStage+0x9c>
c0d05836:	59e0      	ldr	r0, [r4, r7]
c0d05838:	6900      	ldr	r0, [r0, #16]
c0d0583a:	2800      	cmp	r0, #0
c0d0583c:	d007      	beq.n	c0d0584e <USBD_LL_DataOutStage+0x9c>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d0583e:	7831      	ldrb	r1, [r6, #0]
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
          if(usbd_is_valid_intf(pdev, intf) &&  (pdev->interfacesClass[intf].pClass->EP0_RxReady != NULL)&&
c0d05840:	2903      	cmp	r1, #3
c0d05842:	d104      	bne.n	c0d0584e <USBD_LL_DataOutStage+0x9c>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
c0d05844:	f7fe ff90 	bl	c0d04768 <pic>
c0d05848:	4601      	mov	r1, r0
c0d0584a:	4620      	mov	r0, r4
c0d0584c:	4788      	blx	r1
                            MIN(pep->rem_length ,pep->maxpacket));
      }
      else
      {
        uint8_t intf;
        for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0584e:	3708      	adds	r7, #8
c0d05850:	1c6d      	adds	r5, r5, #1
c0d05852:	2d03      	cmp	r5, #3
c0d05854:	d1e9      	bne.n	c0d0582a <USBD_LL_DataOutStage+0x78>
             (pdev->dev_state == USBD_STATE_CONFIGURED))
          {
            ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_RxReady))(pdev); 
          }
        }
        USBD_CtlSendStatus(pdev);
c0d05856:	4620      	mov	r0, r4
c0d05858:	f000 fcf7 	bl	c0d0624a <USBD_CtlSendStatus>
c0d0585c:	2000      	movs	r0, #0
      {
        ((DataOut_t)PIC(pdev->interfacesClass[intf].pClass->DataOut))(pdev, epnum, pdata); 
      }
    }
  }  
  return USBD_OK;
c0d0585e:	b003      	add	sp, #12
c0d05860:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d05862 <USBD_LL_DataInStage>:
* @param  pdev: device instance
* @param  epnum: endpoint index
* @retval status
*/
USBD_StatusTypeDef USBD_LL_DataInStage(USBD_HandleTypeDef *pdev ,uint8_t epnum, uint8_t *pdata)
{
c0d05862:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05864:	b081      	sub	sp, #4
c0d05866:	4604      	mov	r4, r0
c0d05868:	9100      	str	r1, [sp, #0]
  USBD_EndpointTypeDef    *pep;
  UNUSED(pdata);
    
  if(epnum == 0) 
c0d0586a:	2900      	cmp	r1, #0
c0d0586c:	d01b      	beq.n	c0d058a6 <USBD_LL_DataInStage+0x44>
c0d0586e:	4627      	mov	r7, r4
c0d05870:	37dc      	adds	r7, #220	; 0xdc
c0d05872:	2600      	movs	r6, #0
c0d05874:	25f4      	movs	r5, #244	; 0xf4
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d05876:	4620      	mov	r0, r4
c0d05878:	4631      	mov	r1, r6
c0d0587a:	f000 f8a9 	bl	c0d059d0 <usbd_is_valid_intf>
c0d0587e:	2800      	cmp	r0, #0
c0d05880:	d00c      	beq.n	c0d0589c <USBD_LL_DataInStage+0x3a>
c0d05882:	5960      	ldr	r0, [r4, r5]
c0d05884:	6940      	ldr	r0, [r0, #20]
c0d05886:	2800      	cmp	r0, #0
c0d05888:	d008      	beq.n	c0d0589c <USBD_LL_DataInStage+0x3a>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d0588a:	7839      	ldrb	r1, [r7, #0]
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->DataIn != NULL)&&
c0d0588c:	2903      	cmp	r1, #3
c0d0588e:	d105      	bne.n	c0d0589c <USBD_LL_DataInStage+0x3a>
         (pdev->dev_state == USBD_STATE_CONFIGURED))
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
c0d05890:	f7fe ff6a 	bl	c0d04768 <pic>
c0d05894:	4602      	mov	r2, r0
c0d05896:	4620      	mov	r0, r4
c0d05898:	9900      	ldr	r1, [sp, #0]
c0d0589a:	4790      	blx	r2
      pdev->dev_test_mode = 0;
    }
  }
  else {
    uint8_t intf;
    for (intf = 0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0589c:	3508      	adds	r5, #8
c0d0589e:	1c76      	adds	r6, r6, #1
c0d058a0:	2e03      	cmp	r6, #3
c0d058a2:	d1e8      	bne.n	c0d05876 <USBD_LL_DataInStage+0x14>
c0d058a4:	e04e      	b.n	c0d05944 <USBD_LL_DataInStage+0xe2>
c0d058a6:	20d4      	movs	r0, #212	; 0xd4
    
  if(epnum == 0) 
  {
    pep = &pdev->ep_in[0];
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
c0d058a8:	5820      	ldr	r0, [r4, r0]
c0d058aa:	2802      	cmp	r0, #2
c0d058ac:	d143      	bne.n	c0d05936 <USBD_LL_DataInStage+0xd4>
    {
      if(pep->rem_length > pep->maxpacket)
c0d058ae:	69e0      	ldr	r0, [r4, #28]
c0d058b0:	6a25      	ldr	r5, [r4, #32]
c0d058b2:	42a8      	cmp	r0, r5
c0d058b4:	d90b      	bls.n	c0d058ce <USBD_LL_DataInStage+0x6c>
c0d058b6:	2111      	movs	r1, #17
c0d058b8:	010a      	lsls	r2, r1, #4
      {
        pep->rem_length -=  pep->maxpacket;
        pdev->pData += pep->maxpacket;
c0d058ba:	58a1      	ldr	r1, [r4, r2]
c0d058bc:	1949      	adds	r1, r1, r5
c0d058be:	50a1      	str	r1, [r4, r2]
    
    if ( pdev->ep0_state == USBD_EP0_DATA_IN)
    {
      if(pep->rem_length > pep->maxpacket)
      {
        pep->rem_length -=  pep->maxpacket;
c0d058c0:	1b40      	subs	r0, r0, r5
c0d058c2:	61e0      	str	r0, [r4, #28]
        USBD_LL_PrepareReceive (pdev,
                                0,
                                0);  
        */
        
        USBD_CtlContinueSendData (pdev, 
c0d058c4:	b282      	uxth	r2, r0
c0d058c6:	4620      	mov	r0, r4
c0d058c8:	f000 fcaa 	bl	c0d06220 <USBD_CtlContinueSendData>
c0d058cc:	e033      	b.n	c0d05936 <USBD_LL_DataInStage+0xd4>
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d058ce:	69a6      	ldr	r6, [r4, #24]
c0d058d0:	4630      	mov	r0, r6
c0d058d2:	4629      	mov	r1, r5
c0d058d4:	f000 fd56 	bl	c0d06384 <__aeabi_uidivmod>
c0d058d8:	42ae      	cmp	r6, r5
c0d058da:	d30f      	bcc.n	c0d058fc <USBD_LL_DataInStage+0x9a>
c0d058dc:	2900      	cmp	r1, #0
c0d058de:	d10d      	bne.n	c0d058fc <USBD_LL_DataInStage+0x9a>
c0d058e0:	20d8      	movs	r0, #216	; 0xd8
           (pep->total_length >= pep->maxpacket) &&
             (pep->total_length < pdev->ep0_data_len ))
c0d058e2:	5820      	ldr	r0, [r4, r0]
c0d058e4:	4627      	mov	r7, r4
c0d058e6:	37d8      	adds	r7, #216	; 0xd8
                                  pep->rem_length);
        
      }
      else
      { /* last packet is MPS multiple, so send ZLP packet */
        if((pep->total_length % pep->maxpacket == 0) &&
c0d058e8:	4286      	cmp	r6, r0
c0d058ea:	d207      	bcs.n	c0d058fc <USBD_LL_DataInStage+0x9a>
c0d058ec:	2500      	movs	r5, #0
          USBD_LL_PrepareReceive (pdev,
                                  0,
                                  0);
          */

          USBD_CtlContinueSendData(pdev , NULL, 0);
c0d058ee:	4620      	mov	r0, r4
c0d058f0:	4629      	mov	r1, r5
c0d058f2:	462a      	mov	r2, r5
c0d058f4:	f000 fc94 	bl	c0d06220 <USBD_CtlContinueSendData>
          pdev->ep0_data_len = 0;
c0d058f8:	603d      	str	r5, [r7, #0]
c0d058fa:	e01c      	b.n	c0d05936 <USBD_LL_DataInStage+0xd4>
c0d058fc:	4626      	mov	r6, r4
c0d058fe:	36dc      	adds	r6, #220	; 0xdc
c0d05900:	2500      	movs	r5, #0
c0d05902:	27f4      	movs	r7, #244	; 0xf4
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d05904:	4620      	mov	r0, r4
c0d05906:	4629      	mov	r1, r5
c0d05908:	f000 f862 	bl	c0d059d0 <usbd_is_valid_intf>
c0d0590c:	2800      	cmp	r0, #0
c0d0590e:	d00b      	beq.n	c0d05928 <USBD_LL_DataInStage+0xc6>
c0d05910:	59e0      	ldr	r0, [r4, r7]
c0d05912:	68c0      	ldr	r0, [r0, #12]
c0d05914:	2800      	cmp	r0, #0
c0d05916:	d007      	beq.n	c0d05928 <USBD_LL_DataInStage+0xc6>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
c0d05918:	7831      	ldrb	r1, [r6, #0]
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
            if(usbd_is_valid_intf(pdev, intf) && (pdev->interfacesClass[intf].pClass->EP0_TxSent != NULL)&&
c0d0591a:	2903      	cmp	r1, #3
c0d0591c:	d104      	bne.n	c0d05928 <USBD_LL_DataInStage+0xc6>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
c0d0591e:	f7fe ff23 	bl	c0d04768 <pic>
c0d05922:	4601      	mov	r1, r0
c0d05924:	4620      	mov	r0, r4
c0d05926:	4788      	blx	r1
          
        }
        else
        {
          uint8_t intf;
          for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d05928:	3708      	adds	r7, #8
c0d0592a:	1c6d      	adds	r5, r5, #1
c0d0592c:	2d03      	cmp	r5, #3
c0d0592e:	d1e9      	bne.n	c0d05904 <USBD_LL_DataInStage+0xa2>
               (pdev->dev_state == USBD_STATE_CONFIGURED))
            {
              ((EP0_RxReady_t)PIC(pdev->interfacesClass[intf].pClass->EP0_TxSent))(pdev); 
            }
          }
          USBD_CtlReceiveStatus(pdev);
c0d05930:	4620      	mov	r0, r4
c0d05932:	f000 fc96 	bl	c0d06262 <USBD_CtlReceiveStatus>
c0d05936:	20e0      	movs	r0, #224	; 0xe0
        }
      }
    }
    if (pdev->dev_test_mode == 1)
c0d05938:	5c20      	ldrb	r0, [r4, r0]
c0d0593a:	34e0      	adds	r4, #224	; 0xe0
c0d0593c:	2801      	cmp	r0, #1
c0d0593e:	d101      	bne.n	c0d05944 <USBD_LL_DataInStage+0xe2>
c0d05940:	2000      	movs	r0, #0
    {
      USBD_RunTestMode(pdev); 
      pdev->dev_test_mode = 0;
c0d05942:	7020      	strb	r0, [r4, #0]
c0d05944:	2000      	movs	r0, #0
      {
        ((DataIn_t)PIC(pdev->interfacesClass[intf].pClass->DataIn))(pdev, epnum); 
      }
    }
  }
  return USBD_OK;
c0d05946:	b001      	add	sp, #4
c0d05948:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d0594a <USBD_LL_Reset>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
c0d0594a:	b570      	push	{r4, r5, r6, lr}
c0d0594c:	4604      	mov	r4, r0
c0d0594e:	2080      	movs	r0, #128	; 0x80
c0d05950:	2140      	movs	r1, #64	; 0x40
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
c0d05952:	5021      	str	r1, [r4, r0]
c0d05954:	20dc      	movs	r0, #220	; 0xdc
c0d05956:	2201      	movs	r2, #1
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
c0d05958:	5422      	strb	r2, [r4, r0]
USBD_StatusTypeDef USBD_LL_Reset(USBD_HandleTypeDef  *pdev)
{
  pdev->ep_out[0].maxpacket = USB_MAX_EP0_SIZE;
  

  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
c0d0595a:	6221      	str	r1, [r4, #32]
c0d0595c:	2500      	movs	r5, #0
c0d0595e:	26f4      	movs	r6, #244	; 0xf4
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
    if( usbd_is_valid_intf(pdev, intf))
c0d05960:	4620      	mov	r0, r4
c0d05962:	4629      	mov	r1, r5
c0d05964:	f000 f834 	bl	c0d059d0 <usbd_is_valid_intf>
c0d05968:	2800      	cmp	r0, #0
c0d0596a:	d007      	beq.n	c0d0597c <USBD_LL_Reset+0x32>
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
c0d0596c:	59a0      	ldr	r0, [r4, r6]
c0d0596e:	6840      	ldr	r0, [r0, #4]
c0d05970:	f7fe fefa 	bl	c0d04768 <pic>
c0d05974:	4602      	mov	r2, r0
c0d05976:	7921      	ldrb	r1, [r4, #4]
c0d05978:	4620      	mov	r0, r4
c0d0597a:	4790      	blx	r2
  pdev->ep_in[0].maxpacket = USB_MAX_EP0_SIZE;
  /* Upon Reset call user call back */
  pdev->dev_state = USBD_STATE_DEFAULT;
 
  uint8_t intf;
  for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d0597c:	3608      	adds	r6, #8
c0d0597e:	1c6d      	adds	r5, r5, #1
c0d05980:	2d03      	cmp	r5, #3
c0d05982:	d1ed      	bne.n	c0d05960 <USBD_LL_Reset+0x16>
c0d05984:	2000      	movs	r0, #0
    {
      ((DeInit_t)PIC(pdev->interfacesClass[intf].pClass->DeInit))(pdev, pdev->dev_config); 
    }
  }
  
  return USBD_OK;
c0d05986:	bd70      	pop	{r4, r5, r6, pc}

c0d05988 <USBD_LL_SetSpeed>:
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef USBD_LL_SetSpeed(USBD_HandleTypeDef  *pdev, USBD_SpeedTypeDef speed)
{
  pdev->dev_speed = speed;
c0d05988:	7401      	strb	r1, [r0, #16]
c0d0598a:	2000      	movs	r0, #0
  return USBD_OK;
c0d0598c:	4770      	bx	lr

c0d0598e <USBD_LL_Suspend>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Suspend(USBD_HandleTypeDef  *pdev)
{
c0d0598e:	2000      	movs	r0, #0
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_old_state =  pdev->dev_state;
  //pdev->dev_state  = USBD_STATE_SUSPENDED;
  return USBD_OK;
c0d05990:	4770      	bx	lr

c0d05992 <USBD_LL_Resume>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_Resume(USBD_HandleTypeDef  *pdev)
{
c0d05992:	2000      	movs	r0, #0
  UNUSED(pdev);
  // Ignored, gently
  //pdev->dev_state = pdev->dev_old_state;  
  return USBD_OK;
c0d05994:	4770      	bx	lr

c0d05996 <USBD_LL_SOF>:
* @param  pdev: device instance
* @retval status
*/

USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
c0d05996:	b570      	push	{r4, r5, r6, lr}
c0d05998:	4604      	mov	r4, r0
c0d0599a:	20dc      	movs	r0, #220	; 0xdc
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
c0d0599c:	5c20      	ldrb	r0, [r4, r0]
c0d0599e:	2803      	cmp	r0, #3
c0d059a0:	d114      	bne.n	c0d059cc <USBD_LL_SOF+0x36>
c0d059a2:	2500      	movs	r5, #0
c0d059a4:	26f4      	movs	r6, #244	; 0xf4
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
      if( usbd_is_valid_intf(pdev, intf) && pdev->interfacesClass[intf].pClass->SOF != NULL)
c0d059a6:	4620      	mov	r0, r4
c0d059a8:	4629      	mov	r1, r5
c0d059aa:	f000 f811 	bl	c0d059d0 <usbd_is_valid_intf>
c0d059ae:	2800      	cmp	r0, #0
c0d059b0:	d008      	beq.n	c0d059c4 <USBD_LL_SOF+0x2e>
c0d059b2:	59a0      	ldr	r0, [r4, r6]
c0d059b4:	69c0      	ldr	r0, [r0, #28]
c0d059b6:	2800      	cmp	r0, #0
c0d059b8:	d004      	beq.n	c0d059c4 <USBD_LL_SOF+0x2e>
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
c0d059ba:	f7fe fed5 	bl	c0d04768 <pic>
c0d059be:	4601      	mov	r1, r0
c0d059c0:	4620      	mov	r0, r4
c0d059c2:	4788      	blx	r1
USBD_StatusTypeDef USBD_LL_SOF(USBD_HandleTypeDef  *pdev)
{
  if(pdev->dev_state == USBD_STATE_CONFIGURED)
  {
    uint8_t intf;
    for (intf =0; intf < USBD_MAX_NUM_INTERFACES; intf++) {
c0d059c4:	3608      	adds	r6, #8
c0d059c6:	1c6d      	adds	r5, r5, #1
c0d059c8:	2d03      	cmp	r5, #3
c0d059ca:	d1ec      	bne.n	c0d059a6 <USBD_LL_SOF+0x10>
c0d059cc:	2000      	movs	r0, #0
      {
        ((SOF_t)PIC(pdev->interfacesClass[intf].pClass->SOF))(pdev); 
      }
    }
  }
  return USBD_OK;
c0d059ce:	bd70      	pop	{r4, r5, r6, pc}

c0d059d0 <usbd_is_valid_intf>:

/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
c0d059d0:	4602      	mov	r2, r0
c0d059d2:	2000      	movs	r0, #0
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d059d4:	2902      	cmp	r1, #2
c0d059d6:	d807      	bhi.n	c0d059e8 <usbd_is_valid_intf+0x18>
c0d059d8:	00c8      	lsls	r0, r1, #3
c0d059da:	1810      	adds	r0, r2, r0
c0d059dc:	21f4      	movs	r1, #244	; 0xf4
c0d059de:	5841      	ldr	r1, [r0, r1]
c0d059e0:	2001      	movs	r0, #1
c0d059e2:	2900      	cmp	r1, #0
c0d059e4:	d100      	bne.n	c0d059e8 <usbd_is_valid_intf+0x18>
c0d059e6:	4608      	mov	r0, r1
c0d059e8:	4770      	bx	lr

c0d059ea <USBD_StdDevReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d059ea:	b580      	push	{r7, lr}
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d059ec:	784a      	ldrb	r2, [r1, #1]
c0d059ee:	2a04      	cmp	r2, #4
c0d059f0:	dd08      	ble.n	c0d05a04 <USBD_StdDevReq+0x1a>
c0d059f2:	2a07      	cmp	r2, #7
c0d059f4:	dc0f      	bgt.n	c0d05a16 <USBD_StdDevReq+0x2c>
c0d059f6:	2a05      	cmp	r2, #5
c0d059f8:	d014      	beq.n	c0d05a24 <USBD_StdDevReq+0x3a>
c0d059fa:	2a06      	cmp	r2, #6
c0d059fc:	d11b      	bne.n	c0d05a36 <USBD_StdDevReq+0x4c>
  {
  case USB_REQ_GET_DESCRIPTOR: 
    
    USBD_GetDescriptor (pdev, req) ;
c0d059fe:	f000 f821 	bl	c0d05a44 <USBD_GetDescriptor>
c0d05a02:	e01d      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d05a04:	2a00      	cmp	r2, #0
c0d05a06:	d010      	beq.n	c0d05a2a <USBD_StdDevReq+0x40>
c0d05a08:	2a01      	cmp	r2, #1
c0d05a0a:	d017      	beq.n	c0d05a3c <USBD_StdDevReq+0x52>
c0d05a0c:	2a03      	cmp	r2, #3
c0d05a0e:	d112      	bne.n	c0d05a36 <USBD_StdDevReq+0x4c>
    USBD_GetStatus (pdev , req);
    break;
    
    
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
c0d05a10:	f000 f930 	bl	c0d05c74 <USBD_SetFeature>
c0d05a14:	e014      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
*/
USBD_StatusTypeDef  USBD_StdDevReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
  USBD_StatusTypeDef ret = USBD_OK;  
  
  switch (req->bRequest) 
c0d05a16:	2a08      	cmp	r2, #8
c0d05a18:	d00a      	beq.n	c0d05a30 <USBD_StdDevReq+0x46>
c0d05a1a:	2a09      	cmp	r2, #9
c0d05a1c:	d10b      	bne.n	c0d05a36 <USBD_StdDevReq+0x4c>
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
    break;
    
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
c0d05a1e:	f000 f8b9 	bl	c0d05b94 <USBD_SetConfig>
c0d05a22:	e00d      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
    
    USBD_GetDescriptor (pdev, req) ;
    break;
    
  case USB_REQ_SET_ADDRESS:                      
    USBD_SetAddress(pdev, req);
c0d05a24:	f000 f890 	bl	c0d05b48 <USBD_SetAddress>
c0d05a28:	e00a      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_STATUS:                                  
    USBD_GetStatus (pdev , req);
c0d05a2a:	f000 f901 	bl	c0d05c30 <USBD_GetStatus>
c0d05a2e:	e007      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_CONFIGURATION:                    
    USBD_SetConfig (pdev , req);
    break;
    
  case USB_REQ_GET_CONFIGURATION:                 
    USBD_GetConfig (pdev , req);
c0d05a30:	f000 f8e7 	bl	c0d05c02 <USBD_GetConfig>
c0d05a34:	e004      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
    break;
    
  default:  
    USBD_CtlError(pdev , req);
c0d05a36:	f000 f962 	bl	c0d05cfe <USBD_CtlError>
c0d05a3a:	e001      	b.n	c0d05a40 <USBD_StdDevReq+0x56>
  case USB_REQ_SET_FEATURE:   
    USBD_SetFeature (pdev , req);    
    break;
    
  case USB_REQ_CLEAR_FEATURE:                                   
    USBD_ClrFeature (pdev , req);
c0d05a3c:	f000 f937 	bl	c0d05cae <USBD_ClrFeature>
c0d05a40:	2000      	movs	r0, #0
  default:  
    USBD_CtlError(pdev , req);
    break;
  }
  
  return ret;
c0d05a42:	bd80      	pop	{r7, pc}

c0d05a44 <USBD_GetDescriptor>:
* @param  req: usb request
* @retval status
*/
void USBD_GetDescriptor(USBD_HandleTypeDef *pdev , 
                               USBD_SetupReqTypedef *req)
{
c0d05a44:	b5b0      	push	{r4, r5, r7, lr}
c0d05a46:	b082      	sub	sp, #8
c0d05a48:	460d      	mov	r5, r1
c0d05a4a:	4604      	mov	r4, r0
  uint16_t len;
  uint8_t *pbuf = NULL;
  
    
  switch (req->wValue >> 8)
c0d05a4c:	8849      	ldrh	r1, [r1, #2]
c0d05a4e:	0a08      	lsrs	r0, r1, #8
c0d05a50:	2805      	cmp	r0, #5
c0d05a52:	dc12      	bgt.n	c0d05a7a <USBD_GetDescriptor+0x36>
c0d05a54:	2801      	cmp	r0, #1
c0d05a56:	d01a      	beq.n	c0d05a8e <USBD_GetDescriptor+0x4a>
c0d05a58:	2802      	cmp	r0, #2
c0d05a5a:	d022      	beq.n	c0d05aa2 <USBD_GetDescriptor+0x5e>
c0d05a5c:	2803      	cmp	r0, #3
c0d05a5e:	d136      	bne.n	c0d05ace <USBD_GetDescriptor+0x8a>
c0d05a60:	b2c8      	uxtb	r0, r1
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d05a62:	2802      	cmp	r0, #2
c0d05a64:	dc38      	bgt.n	c0d05ad8 <USBD_GetDescriptor+0x94>
c0d05a66:	2800      	cmp	r0, #0
c0d05a68:	d05e      	beq.n	c0d05b28 <USBD_GetDescriptor+0xe4>
c0d05a6a:	2801      	cmp	r0, #1
c0d05a6c:	d064      	beq.n	c0d05b38 <USBD_GetDescriptor+0xf4>
c0d05a6e:	2802      	cmp	r0, #2
c0d05a70:	d12d      	bne.n	c0d05ace <USBD_GetDescriptor+0x8a>
c0d05a72:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
c0d05a74:	5820      	ldr	r0, [r4, r0]
c0d05a76:	68c0      	ldr	r0, [r0, #12]
c0d05a78:	e00c      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>
{
  uint16_t len;
  uint8_t *pbuf = NULL;
  
    
  switch (req->wValue >> 8)
c0d05a7a:	2806      	cmp	r0, #6
c0d05a7c:	d01b      	beq.n	c0d05ab6 <USBD_GetDescriptor+0x72>
c0d05a7e:	2807      	cmp	r0, #7
c0d05a80:	d022      	beq.n	c0d05ac8 <USBD_GetDescriptor+0x84>
c0d05a82:	280f      	cmp	r0, #15
c0d05a84:	d123      	bne.n	c0d05ace <USBD_GetDescriptor+0x8a>
c0d05a86:	20f0      	movs	r0, #240	; 0xf0
  { 
#if (USBD_LPM_ENABLED == 1)
  case USB_DESC_TYPE_BOS:
    pbuf = ((GetBOSDescriptor_t)PIC(pdev->pDesc->GetBOSDescriptor))(pdev->dev_speed, &len);
c0d05a88:	5820      	ldr	r0, [r4, r0]
c0d05a8a:	69c0      	ldr	r0, [r0, #28]
c0d05a8c:	e002      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>
c0d05a8e:	20f0      	movs	r0, #240	; 0xf0
    break;
#endif    
  case USB_DESC_TYPE_DEVICE:
    pbuf = ((GetDeviceDescriptor_t)PIC(pdev->pDesc->GetDeviceDescriptor))(pdev->dev_speed, &len);
c0d05a90:	5820      	ldr	r0, [r4, r0]
c0d05a92:	6800      	ldr	r0, [r0, #0]
c0d05a94:	f7fe fe68 	bl	c0d04768 <pic>
c0d05a98:	4602      	mov	r2, r0
c0d05a9a:	7c20      	ldrb	r0, [r4, #16]
c0d05a9c:	a901      	add	r1, sp, #4
c0d05a9e:	4790      	blx	r2
c0d05aa0:	e030      	b.n	c0d05b04 <USBD_GetDescriptor+0xc0>
c0d05aa2:	20f4      	movs	r0, #244	; 0xf4
    break;
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
c0d05aa4:	5820      	ldr	r0, [r4, r0]
c0d05aa6:	2100      	movs	r1, #0
c0d05aa8:	2800      	cmp	r0, #0
c0d05aaa:	d02c      	beq.n	c0d05b06 <USBD_GetDescriptor+0xc2>
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
c0d05aac:	7c21      	ldrb	r1, [r4, #16]
c0d05aae:	2900      	cmp	r1, #0
c0d05ab0:	d022      	beq.n	c0d05af8 <USBD_GetDescriptor+0xb4>
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
        //pbuf[1] = USB_DESC_TYPE_CONFIGURATION; CONST BUFFER KTHX
      }
      else
      {
        pbuf   = (uint8_t *)((GetFSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetFSConfigDescriptor))(&len);
c0d05ab2:	6ac0      	ldr	r0, [r0, #44]	; 0x2c
c0d05ab4:	e021      	b.n	c0d05afa <USBD_GetDescriptor+0xb6>
#endif   
    }
    break;
  case USB_DESC_TYPE_DEVICE_QUALIFIER:                   

    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL )   
c0d05ab6:	7c20      	ldrb	r0, [r4, #16]
c0d05ab8:	2800      	cmp	r0, #0
c0d05aba:	d108      	bne.n	c0d05ace <USBD_GetDescriptor+0x8a>
c0d05abc:	20f4      	movs	r0, #244	; 0xf4
c0d05abe:	5820      	ldr	r0, [r4, r0]
c0d05ac0:	2800      	cmp	r0, #0
c0d05ac2:	d004      	beq.n	c0d05ace <USBD_GetDescriptor+0x8a>
    {
      pbuf   = (uint8_t *)((GetDeviceQualifierDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetDeviceQualifierDescriptor))(&len);
c0d05ac4:	6b40      	ldr	r0, [r0, #52]	; 0x34
c0d05ac6:	e018      	b.n	c0d05afa <USBD_GetDescriptor+0xb6>
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d05ac8:	7c20      	ldrb	r0, [r4, #16]
c0d05aca:	2800      	cmp	r0, #0
c0d05acc:	d00e      	beq.n	c0d05aec <USBD_GetDescriptor+0xa8>
c0d05ace:	4620      	mov	r0, r4
c0d05ad0:	4629      	mov	r1, r5
c0d05ad2:	f000 f914 	bl	c0d05cfe <USBD_CtlError>
c0d05ad6:	e025      	b.n	c0d05b24 <USBD_GetDescriptor+0xe0>
      }
    }
    break;
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
c0d05ad8:	2803      	cmp	r0, #3
c0d05ada:	d029      	beq.n	c0d05b30 <USBD_GetDescriptor+0xec>
c0d05adc:	2804      	cmp	r0, #4
c0d05ade:	d02f      	beq.n	c0d05b40 <USBD_GetDescriptor+0xfc>
c0d05ae0:	2805      	cmp	r0, #5
c0d05ae2:	d1f4      	bne.n	c0d05ace <USBD_GetDescriptor+0x8a>
c0d05ae4:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_INTERFACE_STR:
      pbuf = ((GetInterfaceStrDescriptor_t)PIC(pdev->pDesc->GetInterfaceStrDescriptor))(pdev->dev_speed, &len);
c0d05ae6:	5820      	ldr	r0, [r4, r0]
c0d05ae8:	6980      	ldr	r0, [r0, #24]
c0d05aea:	e7d3      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>
c0d05aec:	20f4      	movs	r0, #244	; 0xf4
      USBD_CtlError(pdev , req);
      return;
    } 

  case USB_DESC_TYPE_OTHER_SPEED_CONFIGURATION:
    if(pdev->dev_speed == USBD_SPEED_HIGH && pdev->interfacesClass[0].pClass != NULL)   
c0d05aee:	5820      	ldr	r0, [r4, r0]
c0d05af0:	2800      	cmp	r0, #0
c0d05af2:	d0ec      	beq.n	c0d05ace <USBD_GetDescriptor+0x8a>
    {
      pbuf   = (uint8_t *)((GetOtherSpeedConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetOtherSpeedConfigDescriptor))(&len);
c0d05af4:	6b00      	ldr	r0, [r0, #48]	; 0x30
c0d05af6:	e000      	b.n	c0d05afa <USBD_GetDescriptor+0xb6>
    
  case USB_DESC_TYPE_CONFIGURATION:     
    if(pdev->interfacesClass[0].pClass != NULL) {
      if(pdev->dev_speed == USBD_SPEED_HIGH )   
      {
        pbuf   = (uint8_t *)((GetHSConfigDescriptor_t)PIC(pdev->interfacesClass[0].pClass->GetHSConfigDescriptor))(&len);
c0d05af8:	6a80      	ldr	r0, [r0, #40]	; 0x28
c0d05afa:	f7fe fe35 	bl	c0d04768 <pic>
c0d05afe:	4601      	mov	r1, r0
c0d05b00:	a801      	add	r0, sp, #4
c0d05b02:	4788      	blx	r1
c0d05b04:	4601      	mov	r1, r0
c0d05b06:	a801      	add	r0, sp, #4
  default: 
     USBD_CtlError(pdev , req);
    return;
  }
  
  if((len != 0)&& (req->wLength != 0))
c0d05b08:	8802      	ldrh	r2, [r0, #0]
c0d05b0a:	2a00      	cmp	r2, #0
c0d05b0c:	d00a      	beq.n	c0d05b24 <USBD_GetDescriptor+0xe0>
c0d05b0e:	88e8      	ldrh	r0, [r5, #6]
c0d05b10:	2800      	cmp	r0, #0
c0d05b12:	d007      	beq.n	c0d05b24 <USBD_GetDescriptor+0xe0>
  {
    
    len = MIN(len , req->wLength);
c0d05b14:	4282      	cmp	r2, r0
c0d05b16:	d300      	bcc.n	c0d05b1a <USBD_GetDescriptor+0xd6>
c0d05b18:	4602      	mov	r2, r0
c0d05b1a:	a801      	add	r0, sp, #4
c0d05b1c:	8002      	strh	r2, [r0, #0]
    
    // prepare abort if host does not read the whole data
    //USBD_CtlReceiveStatus(pdev);

    // start transfer
    USBD_CtlSendData (pdev, 
c0d05b1e:	4620      	mov	r0, r4
c0d05b20:	f000 fb68 	bl	c0d061f4 <USBD_CtlSendData>
                      pbuf,
                      len);
  }
  
}
c0d05b24:	b002      	add	sp, #8
c0d05b26:	bdb0      	pop	{r4, r5, r7, pc}
c0d05b28:	20f0      	movs	r0, #240	; 0xf0
    
  case USB_DESC_TYPE_STRING:
    switch ((uint8_t)(req->wValue))
    {
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
c0d05b2a:	5820      	ldr	r0, [r4, r0]
c0d05b2c:	6840      	ldr	r0, [r0, #4]
c0d05b2e:	e7b1      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>
c0d05b30:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_PRODUCT_STR:
      pbuf = ((GetProductStrDescriptor_t)PIC(pdev->pDesc->GetProductStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
c0d05b32:	5820      	ldr	r0, [r4, r0]
c0d05b34:	6900      	ldr	r0, [r0, #16]
c0d05b36:	e7ad      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>
c0d05b38:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_LANGID_STR:
     pbuf = ((GetLangIDStrDescriptor_t)PIC(pdev->pDesc->GetLangIDStrDescriptor))(pdev->dev_speed, &len);        
      break;
      
    case USBD_IDX_MFC_STR:
      pbuf = ((GetManufacturerStrDescriptor_t)PIC(pdev->pDesc->GetManufacturerStrDescriptor))(pdev->dev_speed, &len);
c0d05b3a:	5820      	ldr	r0, [r4, r0]
c0d05b3c:	6880      	ldr	r0, [r0, #8]
c0d05b3e:	e7a9      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>
c0d05b40:	20f0      	movs	r0, #240	; 0xf0
    case USBD_IDX_SERIAL_STR:
      pbuf = ((GetSerialStrDescriptor_t)PIC(pdev->pDesc->GetSerialStrDescriptor))(pdev->dev_speed, &len);
      break;
      
    case USBD_IDX_CONFIG_STR:
      pbuf = ((GetConfigurationStrDescriptor_t)PIC(pdev->pDesc->GetConfigurationStrDescriptor))(pdev->dev_speed, &len);
c0d05b42:	5820      	ldr	r0, [r4, r0]
c0d05b44:	6940      	ldr	r0, [r0, #20]
c0d05b46:	e7a5      	b.n	c0d05a94 <USBD_GetDescriptor+0x50>

c0d05b48 <USBD_SetAddress>:
* @param  req: usb request
* @retval status
*/
void USBD_SetAddress(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d05b48:	b570      	push	{r4, r5, r6, lr}
c0d05b4a:	4604      	mov	r4, r0
  uint8_t  dev_addr; 
  
  if ((req->wIndex == 0) && (req->wLength == 0)) 
c0d05b4c:	8888      	ldrh	r0, [r1, #4]
c0d05b4e:	2800      	cmp	r0, #0
c0d05b50:	d10b      	bne.n	c0d05b6a <USBD_SetAddress+0x22>
c0d05b52:	88c8      	ldrh	r0, [r1, #6]
c0d05b54:	2800      	cmp	r0, #0
c0d05b56:	d108      	bne.n	c0d05b6a <USBD_SetAddress+0x22>
  {
    dev_addr = (uint8_t)(req->wValue) & 0x7F;     
c0d05b58:	8848      	ldrh	r0, [r1, #2]
c0d05b5a:	257f      	movs	r5, #127	; 0x7f
c0d05b5c:	4005      	ands	r5, r0
c0d05b5e:	20dc      	movs	r0, #220	; 0xdc
    
    if (pdev->dev_state == USBD_STATE_CONFIGURED) 
c0d05b60:	5c20      	ldrb	r0, [r4, r0]
c0d05b62:	4626      	mov	r6, r4
c0d05b64:	36dc      	adds	r6, #220	; 0xdc
c0d05b66:	2803      	cmp	r0, #3
c0d05b68:	d103      	bne.n	c0d05b72 <USBD_SetAddress+0x2a>
c0d05b6a:	4620      	mov	r0, r4
c0d05b6c:	f000 f8c7 	bl	c0d05cfe <USBD_CtlError>
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d05b70:	bd70      	pop	{r4, r5, r6, pc}
c0d05b72:	20de      	movs	r0, #222	; 0xde
    {
      USBD_CtlError(pdev , req);
    } 
    else 
    {
      pdev->dev_address = dev_addr;
c0d05b74:	5425      	strb	r5, [r4, r0]
      USBD_LL_SetUSBAddress(pdev, dev_addr);               
c0d05b76:	4620      	mov	r0, r4
c0d05b78:	4629      	mov	r1, r5
c0d05b7a:	f7ff fd2f 	bl	c0d055dc <USBD_LL_SetUSBAddress>
      USBD_CtlSendStatus(pdev);                         
c0d05b7e:	4620      	mov	r0, r4
c0d05b80:	f000 fb63 	bl	c0d0624a <USBD_CtlSendStatus>
      
      if (dev_addr != 0) 
c0d05b84:	2d00      	cmp	r5, #0
c0d05b86:	d002      	beq.n	c0d05b8e <USBD_SetAddress+0x46>
c0d05b88:	2002      	movs	r0, #2
      {
        pdev->dev_state  = USBD_STATE_ADDRESSED;
c0d05b8a:	7030      	strb	r0, [r6, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d05b8c:	bd70      	pop	{r4, r5, r6, pc}
c0d05b8e:	2001      	movs	r0, #1
      {
        pdev->dev_state  = USBD_STATE_ADDRESSED;
      } 
      else 
      {
        pdev->dev_state  = USBD_STATE_DEFAULT; 
c0d05b90:	7030      	strb	r0, [r6, #0]
  } 
  else 
  {
     USBD_CtlError(pdev , req);                        
  } 
}
c0d05b92:	bd70      	pop	{r4, r5, r6, pc}

c0d05b94 <USBD_SetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_SetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d05b94:	b570      	push	{r4, r5, r6, lr}
c0d05b96:	460d      	mov	r5, r1
c0d05b98:	4604      	mov	r4, r0
  
  uint8_t  cfgidx;
  
  cfgidx = (uint8_t)(req->wValue);                 
c0d05b9a:	788e      	ldrb	r6, [r1, #2]
  
  if (cfgidx > USBD_MAX_NUM_CONFIGURATION ) 
c0d05b9c:	2e02      	cmp	r6, #2
c0d05b9e:	d21d      	bcs.n	c0d05bdc <USBD_SetConfig+0x48>
c0d05ba0:	20dc      	movs	r0, #220	; 0xdc
  {            
     USBD_CtlError(pdev , req);                              
  } 
  else 
  {
    switch (pdev->dev_state) 
c0d05ba2:	5c21      	ldrb	r1, [r4, r0]
c0d05ba4:	4620      	mov	r0, r4
c0d05ba6:	30dc      	adds	r0, #220	; 0xdc
c0d05ba8:	2903      	cmp	r1, #3
c0d05baa:	d007      	beq.n	c0d05bbc <USBD_SetConfig+0x28>
c0d05bac:	2902      	cmp	r1, #2
c0d05bae:	d115      	bne.n	c0d05bdc <USBD_SetConfig+0x48>
    {
    case USBD_STATE_ADDRESSED:
      if (cfgidx) 
c0d05bb0:	2e00      	cmp	r6, #0
c0d05bb2:	d022      	beq.n	c0d05bfa <USBD_SetConfig+0x66>
      {                                			   							   							   				
        pdev->dev_config = cfgidx;
c0d05bb4:	6066      	str	r6, [r4, #4]
c0d05bb6:	2103      	movs	r1, #3
        pdev->dev_state = USBD_STATE_CONFIGURED;
c0d05bb8:	7001      	strb	r1, [r0, #0]
c0d05bba:	e009      	b.n	c0d05bd0 <USBD_SetConfig+0x3c>
      }
      USBD_CtlSendStatus(pdev);
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
c0d05bbc:	2e00      	cmp	r6, #0
c0d05bbe:	d012      	beq.n	c0d05be6 <USBD_SetConfig+0x52>
        pdev->dev_state = USBD_STATE_ADDRESSED;
        pdev->dev_config = cfgidx;          
        USBD_ClrClassConfig(pdev , cfgidx);
        USBD_CtlSendStatus(pdev);
      } 
      else  if (cfgidx != pdev->dev_config) 
c0d05bc0:	6860      	ldr	r0, [r4, #4]
c0d05bc2:	42b0      	cmp	r0, r6
c0d05bc4:	d019      	beq.n	c0d05bfa <USBD_SetConfig+0x66>
      {
        /* Clear old configuration */
        USBD_ClrClassConfig(pdev , pdev->dev_config);
c0d05bc6:	b2c1      	uxtb	r1, r0
c0d05bc8:	4620      	mov	r0, r4
c0d05bca:	f7ff fda9 	bl	c0d05720 <USBD_ClrClassConfig>
        
        /* set new configuration */
        pdev->dev_config = cfgidx;
c0d05bce:	6066      	str	r6, [r4, #4]
c0d05bd0:	4620      	mov	r0, r4
c0d05bd2:	4631      	mov	r1, r6
c0d05bd4:	f7ff fd89 	bl	c0d056ea <USBD_SetClassConfig>
c0d05bd8:	2802      	cmp	r0, #2
c0d05bda:	d10e      	bne.n	c0d05bfa <USBD_SetConfig+0x66>
c0d05bdc:	4620      	mov	r0, r4
c0d05bde:	4629      	mov	r1, r5
c0d05be0:	f000 f88d 	bl	c0d05cfe <USBD_CtlError>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d05be4:	bd70      	pop	{r4, r5, r6, pc}
c0d05be6:	2102      	movs	r1, #2
      break;
      
    case USBD_STATE_CONFIGURED:
      if (cfgidx == 0) 
      {                           
        pdev->dev_state = USBD_STATE_ADDRESSED;
c0d05be8:	7001      	strb	r1, [r0, #0]
        pdev->dev_config = cfgidx;          
c0d05bea:	6066      	str	r6, [r4, #4]
        USBD_ClrClassConfig(pdev , cfgidx);
c0d05bec:	4620      	mov	r0, r4
c0d05bee:	4631      	mov	r1, r6
c0d05bf0:	f7ff fd96 	bl	c0d05720 <USBD_ClrClassConfig>
        USBD_CtlSendStatus(pdev);
c0d05bf4:	4620      	mov	r0, r4
c0d05bf6:	f000 fb28 	bl	c0d0624a <USBD_CtlSendStatus>
c0d05bfa:	4620      	mov	r0, r4
c0d05bfc:	f000 fb25 	bl	c0d0624a <USBD_CtlSendStatus>
    default:					
       USBD_CtlError(pdev , req);                     
      break;
    }
  }
}
c0d05c00:	bd70      	pop	{r4, r5, r6, pc}

c0d05c02 <USBD_GetConfig>:
* @param  req: usb request
* @retval status
*/
void USBD_GetConfig(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d05c02:	b580      	push	{r7, lr}

  if (req->wLength != 1) 
c0d05c04:	88ca      	ldrh	r2, [r1, #6]
c0d05c06:	2a01      	cmp	r2, #1
c0d05c08:	d10a      	bne.n	c0d05c20 <USBD_GetConfig+0x1e>
c0d05c0a:	22dc      	movs	r2, #220	; 0xdc
  {                   
     USBD_CtlError(pdev , req);
  }
  else 
  {
    switch (pdev->dev_state )  
c0d05c0c:	5c82      	ldrb	r2, [r0, r2]
c0d05c0e:	2a03      	cmp	r2, #3
c0d05c10:	d009      	beq.n	c0d05c26 <USBD_GetConfig+0x24>
c0d05c12:	2a02      	cmp	r2, #2
c0d05c14:	d104      	bne.n	c0d05c20 <USBD_GetConfig+0x1e>
c0d05c16:	2100      	movs	r1, #0
    {
    case USBD_STATE_ADDRESSED:                     
      pdev->dev_default_config = 0;
c0d05c18:	6081      	str	r1, [r0, #8]
c0d05c1a:	4601      	mov	r1, r0
c0d05c1c:	3108      	adds	r1, #8
c0d05c1e:	e003      	b.n	c0d05c28 <USBD_GetConfig+0x26>
c0d05c20:	f000 f86d 	bl	c0d05cfe <USBD_CtlError>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d05c24:	bd80      	pop	{r7, pc}
                        1);
      break;
      
    case USBD_STATE_CONFIGURED:   
      USBD_CtlSendData (pdev, 
                        (uint8_t *)&pdev->dev_config,
c0d05c26:	1d01      	adds	r1, r0, #4
c0d05c28:	2201      	movs	r2, #1
c0d05c2a:	f000 fae3 	bl	c0d061f4 <USBD_CtlSendData>
    default:
       USBD_CtlError(pdev , req);
      break;
    }
  }
}
c0d05c2e:	bd80      	pop	{r7, pc}

c0d05c30 <USBD_GetStatus>:
* @param  req: usb request
* @retval status
*/
void USBD_GetStatus(USBD_HandleTypeDef *pdev , 
                           USBD_SetupReqTypedef *req)
{
c0d05c30:	b5b0      	push	{r4, r5, r7, lr}
c0d05c32:	4604      	mov	r4, r0
c0d05c34:	20dc      	movs	r0, #220	; 0xdc
  
    
  switch (pdev->dev_state) 
c0d05c36:	5c20      	ldrb	r0, [r4, r0]
c0d05c38:	22fe      	movs	r2, #254	; 0xfe
c0d05c3a:	4002      	ands	r2, r0
c0d05c3c:	2a02      	cmp	r2, #2
c0d05c3e:	d115      	bne.n	c0d05c6c <USBD_GetStatus+0x3c>
c0d05c40:	2001      	movs	r0, #1
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d05c42:	60e0      	str	r0, [r4, #12]
c0d05c44:	20e4      	movs	r0, #228	; 0xe4
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d05c46:	5821      	ldr	r1, [r4, r0]
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    
#if ( USBD_SELF_POWERED == 1)
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
c0d05c48:	4625      	mov	r5, r4
c0d05c4a:	350c      	adds	r5, #12
c0d05c4c:	2003      	movs	r0, #3
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d05c4e:	2900      	cmp	r1, #0
c0d05c50:	d005      	beq.n	c0d05c5e <USBD_GetStatus+0x2e>
c0d05c52:	4620      	mov	r0, r4
c0d05c54:	f000 fb05 	bl	c0d06262 <USBD_CtlReceiveStatus>
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d05c58:	68e1      	ldr	r1, [r4, #12]
c0d05c5a:	2002      	movs	r0, #2
    pdev->dev_config_status = USB_CONFIG_SELF_POWERED;                                  
#else
    pdev->dev_config_status = 0;                                   
#endif
                      
    if (pdev->dev_remote_wakeup) USBD_CtlReceiveStatus(pdev);
c0d05c5c:	4308      	orrs	r0, r1
    {
       pdev->dev_config_status |= USB_CONFIG_REMOTE_WAKEUP;                                
c0d05c5e:	60e0      	str	r0, [r4, #12]
c0d05c60:	2202      	movs	r2, #2
    }
    
    USBD_CtlSendData (pdev, 
c0d05c62:	4620      	mov	r0, r4
c0d05c64:	4629      	mov	r1, r5
c0d05c66:	f000 fac5 	bl	c0d061f4 <USBD_CtlSendData>
    
  default :
    USBD_CtlError(pdev , req);                        
    break;
  }
}
c0d05c6a:	bdb0      	pop	{r4, r5, r7, pc}
                      (uint8_t *)& pdev->dev_config_status,
                      2);
    break;
    
  default :
    USBD_CtlError(pdev , req);                        
c0d05c6c:	4620      	mov	r0, r4
c0d05c6e:	f000 f846 	bl	c0d05cfe <USBD_CtlError>
    break;
  }
}
c0d05c72:	bdb0      	pop	{r4, r5, r7, pc}

c0d05c74 <USBD_SetFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_SetFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d05c74:	b5b0      	push	{r4, r5, r7, lr}
c0d05c76:	4604      	mov	r4, r0

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
c0d05c78:	8848      	ldrh	r0, [r1, #2]
c0d05c7a:	2801      	cmp	r0, #1
c0d05c7c:	d116      	bne.n	c0d05cac <USBD_SetFeature+0x38>
c0d05c7e:	460d      	mov	r5, r1
c0d05c80:	20e4      	movs	r0, #228	; 0xe4
c0d05c82:	2101      	movs	r1, #1
  {
    pdev->dev_remote_wakeup = 1;  
c0d05c84:	5021      	str	r1, [r4, r0]
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05c86:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05c88:	2802      	cmp	r0, #2
c0d05c8a:	d80c      	bhi.n	c0d05ca6 <USBD_SetFeature+0x32>
c0d05c8c:	00c0      	lsls	r0, r0, #3
c0d05c8e:	1820      	adds	r0, r4, r0
c0d05c90:	21f4      	movs	r1, #244	; 0xf4
c0d05c92:	5840      	ldr	r0, [r0, r1]
{

  if (req->wValue == USB_FEATURE_REMOTE_WAKEUP)
  {
    pdev->dev_remote_wakeup = 1;  
    if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05c94:	2800      	cmp	r0, #0
c0d05c96:	d006      	beq.n	c0d05ca6 <USBD_SetFeature+0x32>
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d05c98:	6880      	ldr	r0, [r0, #8]
c0d05c9a:	f7fe fd65 	bl	c0d04768 <pic>
c0d05c9e:	4602      	mov	r2, r0
c0d05ca0:	4620      	mov	r0, r4
c0d05ca2:	4629      	mov	r1, r5
c0d05ca4:	4790      	blx	r2
    }
    USBD_CtlSendStatus(pdev);
c0d05ca6:	4620      	mov	r0, r4
c0d05ca8:	f000 facf 	bl	c0d0624a <USBD_CtlSendStatus>
  }

}
c0d05cac:	bdb0      	pop	{r4, r5, r7, pc}

c0d05cae <USBD_ClrFeature>:
* @param  req: usb request
* @retval status
*/
void USBD_ClrFeature(USBD_HandleTypeDef *pdev , 
                            USBD_SetupReqTypedef *req)
{
c0d05cae:	b5b0      	push	{r4, r5, r7, lr}
c0d05cb0:	460d      	mov	r5, r1
c0d05cb2:	4604      	mov	r4, r0
c0d05cb4:	20dc      	movs	r0, #220	; 0xdc
  switch (pdev->dev_state)
c0d05cb6:	5c20      	ldrb	r0, [r4, r0]
c0d05cb8:	21fe      	movs	r1, #254	; 0xfe
c0d05cba:	4001      	ands	r1, r0
c0d05cbc:	2902      	cmp	r1, #2
c0d05cbe:	d119      	bne.n	c0d05cf4 <USBD_ClrFeature+0x46>
  {
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
c0d05cc0:	8868      	ldrh	r0, [r5, #2]
c0d05cc2:	2801      	cmp	r0, #1
c0d05cc4:	d11a      	bne.n	c0d05cfc <USBD_ClrFeature+0x4e>
c0d05cc6:	20e4      	movs	r0, #228	; 0xe4
c0d05cc8:	2100      	movs	r1, #0
    {
      pdev->dev_remote_wakeup = 0; 
c0d05cca:	5021      	str	r1, [r4, r0]
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05ccc:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05cce:	2802      	cmp	r0, #2
c0d05cd0:	d80c      	bhi.n	c0d05cec <USBD_ClrFeature+0x3e>
c0d05cd2:	00c0      	lsls	r0, r0, #3
c0d05cd4:	1820      	adds	r0, r4, r0
c0d05cd6:	21f4      	movs	r1, #244	; 0xf4
c0d05cd8:	5840      	ldr	r0, [r0, r1]
  case USBD_STATE_ADDRESSED:
  case USBD_STATE_CONFIGURED:
    if (req->wValue == USB_FEATURE_REMOTE_WAKEUP) 
    {
      pdev->dev_remote_wakeup = 0; 
      if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05cda:	2800      	cmp	r0, #0
c0d05cdc:	d006      	beq.n	c0d05cec <USBD_ClrFeature+0x3e>
        ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);   
c0d05cde:	6880      	ldr	r0, [r0, #8]
c0d05ce0:	f7fe fd42 	bl	c0d04768 <pic>
c0d05ce4:	4602      	mov	r2, r0
c0d05ce6:	4620      	mov	r0, r4
c0d05ce8:	4629      	mov	r1, r5
c0d05cea:	4790      	blx	r2
      }
      USBD_CtlSendStatus(pdev);
c0d05cec:	4620      	mov	r0, r4
c0d05cee:	f000 faac 	bl	c0d0624a <USBD_CtlSendStatus>
    
  default :
     USBD_CtlError(pdev , req);
    break;
  }
}
c0d05cf2:	bdb0      	pop	{r4, r5, r7, pc}
      USBD_CtlSendStatus(pdev);
    }
    break;
    
  default :
     USBD_CtlError(pdev , req);
c0d05cf4:	4620      	mov	r0, r4
c0d05cf6:	4629      	mov	r1, r5
c0d05cf8:	f000 f801 	bl	c0d05cfe <USBD_CtlError>
    break;
  }
}
c0d05cfc:	bdb0      	pop	{r4, r5, r7, pc}

c0d05cfe <USBD_CtlError>:
  USBD_LL_StallEP(pdev , 0);
}

__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
c0d05cfe:	b510      	push	{r4, lr}
c0d05d00:	4604      	mov	r4, r0
c0d05d02:	2180      	movs	r1, #128	; 0x80
* @param  req: usb request
* @retval None
*/
void USBD_CtlStall( USBD_HandleTypeDef *pdev)
{
  USBD_LL_StallEP(pdev , 0x80);
c0d05d04:	f7ff fc12 	bl	c0d0552c <USBD_LL_StallEP>
c0d05d08:	2100      	movs	r1, #0
  USBD_LL_StallEP(pdev , 0);
c0d05d0a:	4620      	mov	r0, r4
c0d05d0c:	f7ff fc0e 	bl	c0d0552c <USBD_LL_StallEP>
__weak void USBD_CtlError( USBD_HandleTypeDef *pdev ,
                            USBD_SetupReqTypedef *req)
{
  UNUSED(req);
  USBD_CtlStall(pdev);
}
c0d05d10:	bd10      	pop	{r4, pc}

c0d05d12 <USBD_StdItfReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdItfReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d05d12:	b5b0      	push	{r4, r5, r7, lr}
c0d05d14:	460d      	mov	r5, r1
c0d05d16:	4604      	mov	r4, r0
c0d05d18:	20dc      	movs	r0, #220	; 0xdc
  USBD_StatusTypeDef ret = USBD_OK; 
  
  switch (pdev->dev_state) 
c0d05d1a:	5c20      	ldrb	r0, [r4, r0]
c0d05d1c:	2803      	cmp	r0, #3
c0d05d1e:	d116      	bne.n	c0d05d4e <USBD_StdItfReq+0x3c>
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d05d20:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05d22:	2802      	cmp	r0, #2
c0d05d24:	d813      	bhi.n	c0d05d4e <USBD_StdItfReq+0x3c>
c0d05d26:	00c0      	lsls	r0, r0, #3
c0d05d28:	1820      	adds	r0, r4, r0
c0d05d2a:	21f4      	movs	r1, #244	; 0xf4
c0d05d2c:	5840      	ldr	r0, [r0, r1]
  
  switch (pdev->dev_state) 
  {
  case USBD_STATE_CONFIGURED:
    
    if (usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) 
c0d05d2e:	2800      	cmp	r0, #0
c0d05d30:	d00d      	beq.n	c0d05d4e <USBD_StdItfReq+0x3c>
    {
      ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d05d32:	6880      	ldr	r0, [r0, #8]
c0d05d34:	f7fe fd18 	bl	c0d04768 <pic>
c0d05d38:	4602      	mov	r2, r0
c0d05d3a:	4620      	mov	r0, r4
c0d05d3c:	4629      	mov	r1, r5
c0d05d3e:	4790      	blx	r2
      
      if((req->wLength == 0)&& (ret == USBD_OK))
c0d05d40:	88e8      	ldrh	r0, [r5, #6]
c0d05d42:	2800      	cmp	r0, #0
c0d05d44:	d107      	bne.n	c0d05d56 <USBD_StdItfReq+0x44>
      {
         USBD_CtlSendStatus(pdev);
c0d05d46:	4620      	mov	r0, r4
c0d05d48:	f000 fa7f 	bl	c0d0624a <USBD_CtlSendStatus>
c0d05d4c:	e003      	b.n	c0d05d56 <USBD_StdItfReq+0x44>
c0d05d4e:	4620      	mov	r0, r4
c0d05d50:	4629      	mov	r1, r5
c0d05d52:	f7ff ffd4 	bl	c0d05cfe <USBD_CtlError>
c0d05d56:	2000      	movs	r0, #0
    
  default:
     USBD_CtlError(pdev , req);
    break;
  }
  return USBD_OK;
c0d05d58:	bdb0      	pop	{r4, r5, r7, pc}

c0d05d5a <USBD_StdEPReq>:
* @param  pdev: device instance
* @param  req: usb request
* @retval status
*/
USBD_StatusTypeDef  USBD_StdEPReq (USBD_HandleTypeDef *pdev , USBD_SetupReqTypedef  *req)
{
c0d05d5a:	b5b0      	push	{r4, r5, r7, lr}
c0d05d5c:	460d      	mov	r5, r1
c0d05d5e:	4604      	mov	r4, r0
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d05d60:	7808      	ldrb	r0, [r1, #0]
c0d05d62:	2260      	movs	r2, #96	; 0x60
c0d05d64:	4002      	ands	r2, r0
{
  
  uint8_t   ep_addr;
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
c0d05d66:	7909      	ldrb	r1, [r1, #4]
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d05d68:	2a20      	cmp	r2, #32
c0d05d6a:	d10f      	bne.n	c0d05d8c <USBD_StdEPReq+0x32>
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05d6c:	2902      	cmp	r1, #2
c0d05d6e:	d80d      	bhi.n	c0d05d8c <USBD_StdEPReq+0x32>
c0d05d70:	00c8      	lsls	r0, r1, #3
c0d05d72:	1820      	adds	r0, r4, r0
c0d05d74:	22f4      	movs	r2, #244	; 0xf4
c0d05d76:	5880      	ldr	r0, [r0, r2]
  USBD_StatusTypeDef ret = USBD_OK; 
  USBD_EndpointTypeDef   *pep;
  ep_addr  = LOBYTE(req->wIndex);   
  
  /* Check if it is a class request */
  if ((req->bmRequest & 0x60) == 0x20 && usbd_is_valid_intf(pdev, LOBYTE(req->wIndex)))
c0d05d78:	2800      	cmp	r0, #0
c0d05d7a:	d007      	beq.n	c0d05d8c <USBD_StdEPReq+0x32>
  {
    ((Setup_t)PIC(pdev->interfacesClass[LOBYTE(req->wIndex)].pClass->Setup)) (pdev, req);
c0d05d7c:	6880      	ldr	r0, [r0, #8]
c0d05d7e:	f7fe fcf3 	bl	c0d04768 <pic>
c0d05d82:	4602      	mov	r2, r0
c0d05d84:	4620      	mov	r0, r4
c0d05d86:	4629      	mov	r1, r5
c0d05d88:	4790      	blx	r2
c0d05d8a:	e068      	b.n	c0d05e5e <USBD_StdEPReq+0x104>
    
    return USBD_OK;
  }
  
  switch (req->bRequest) 
c0d05d8c:	7868      	ldrb	r0, [r5, #1]
c0d05d8e:	2800      	cmp	r0, #0
c0d05d90:	d016      	beq.n	c0d05dc0 <USBD_StdEPReq+0x66>
c0d05d92:	2801      	cmp	r0, #1
c0d05d94:	d01d      	beq.n	c0d05dd2 <USBD_StdEPReq+0x78>
c0d05d96:	2803      	cmp	r0, #3
c0d05d98:	d161      	bne.n	c0d05e5e <USBD_StdEPReq+0x104>
c0d05d9a:	20dc      	movs	r0, #220	; 0xdc
  {
    
  case USB_REQ_SET_FEATURE :
    
    switch (pdev->dev_state) 
c0d05d9c:	5c20      	ldrb	r0, [r4, r0]
c0d05d9e:	2803      	cmp	r0, #3
c0d05da0:	d11b      	bne.n	c0d05dda <USBD_StdEPReq+0x80>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d05da2:	8868      	ldrh	r0, [r5, #2]
c0d05da4:	2800      	cmp	r0, #0
c0d05da6:	d107      	bne.n	c0d05db8 <USBD_StdEPReq+0x5e>
c0d05da8:	2080      	movs	r0, #128	; 0x80
      {
        if ((ep_addr != 0x00) && (ep_addr != 0x80)) 
c0d05daa:	4308      	orrs	r0, r1
c0d05dac:	2880      	cmp	r0, #128	; 0x80
c0d05dae:	d003      	beq.n	c0d05db8 <USBD_StdEPReq+0x5e>
        { 
          USBD_LL_StallEP(pdev , ep_addr);
c0d05db0:	4620      	mov	r0, r4
c0d05db2:	f7ff fbbb 	bl	c0d0552c <USBD_LL_StallEP>
          
        }
c0d05db6:	7929      	ldrb	r1, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05db8:	2902      	cmp	r1, #2
c0d05dba:	d84d      	bhi.n	c0d05e58 <USBD_StdEPReq+0xfe>
c0d05dbc:	00c8      	lsls	r0, r1, #3
c0d05dbe:	e03f      	b.n	c0d05e40 <USBD_StdEPReq+0xe6>
c0d05dc0:	20dc      	movs	r0, #220	; 0xdc
      break;    
    }
    break;
    
  case USB_REQ_GET_STATUS:                  
    switch (pdev->dev_state) 
c0d05dc2:	5c20      	ldrb	r0, [r4, r0]
c0d05dc4:	2803      	cmp	r0, #3
c0d05dc6:	d017      	beq.n	c0d05df8 <USBD_StdEPReq+0x9e>
c0d05dc8:	2802      	cmp	r0, #2
c0d05dca:	d110      	bne.n	c0d05dee <USBD_StdEPReq+0x94>
    {
    case USBD_STATE_ADDRESSED:          
      if ((ep_addr & 0x7F) != 0x00) 
c0d05dcc:	0648      	lsls	r0, r1, #25
c0d05dce:	d10a      	bne.n	c0d05de6 <USBD_StdEPReq+0x8c>
c0d05dd0:	e045      	b.n	c0d05e5e <USBD_StdEPReq+0x104>
c0d05dd2:	20dc      	movs	r0, #220	; 0xdc
    }
    break;
    
  case USB_REQ_CLEAR_FEATURE :
    
    switch (pdev->dev_state) 
c0d05dd4:	5c20      	ldrb	r0, [r4, r0]
c0d05dd6:	2803      	cmp	r0, #3
c0d05dd8:	d026      	beq.n	c0d05e28 <USBD_StdEPReq+0xce>
c0d05dda:	2802      	cmp	r0, #2
c0d05ddc:	d107      	bne.n	c0d05dee <USBD_StdEPReq+0x94>
c0d05dde:	2080      	movs	r0, #128	; 0x80
c0d05de0:	4308      	orrs	r0, r1
c0d05de2:	2880      	cmp	r0, #128	; 0x80
c0d05de4:	d03b      	beq.n	c0d05e5e <USBD_StdEPReq+0x104>
c0d05de6:	4620      	mov	r0, r4
c0d05de8:	f7ff fba0 	bl	c0d0552c <USBD_LL_StallEP>
c0d05dec:	e037      	b.n	c0d05e5e <USBD_StdEPReq+0x104>
c0d05dee:	4620      	mov	r0, r4
c0d05df0:	4629      	mov	r1, r5
c0d05df2:	f7ff ff84 	bl	c0d05cfe <USBD_CtlError>
c0d05df6:	e032      	b.n	c0d05e5e <USBD_StdEPReq+0x104>
c0d05df8:	207f      	movs	r0, #127	; 0x7f
c0d05dfa:	4008      	ands	r0, r1
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d05dfc:	0100      	lsls	r0, r0, #4
c0d05dfe:	1820      	adds	r0, r4, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
c0d05e00:	4605      	mov	r5, r0
c0d05e02:	3574      	adds	r5, #116	; 0x74
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:
      pep = ((ep_addr & 0x80) == 0x80) ? &pdev->ep_in[ep_addr & 0x7F]:\
c0d05e04:	3014      	adds	r0, #20
c0d05e06:	060a      	lsls	r2, r1, #24
c0d05e08:	d500      	bpl.n	c0d05e0c <USBD_StdEPReq+0xb2>
c0d05e0a:	4605      	mov	r5, r0
                                         &pdev->ep_out[ep_addr & 0x7F];
      if(USBD_LL_IsStallEP(pdev, ep_addr))
c0d05e0c:	4620      	mov	r0, r4
c0d05e0e:	f7ff fbd5 	bl	c0d055bc <USBD_LL_IsStallEP>
c0d05e12:	2101      	movs	r1, #1
c0d05e14:	2800      	cmp	r0, #0
c0d05e16:	d100      	bne.n	c0d05e1a <USBD_StdEPReq+0xc0>
c0d05e18:	4601      	mov	r1, r0
c0d05e1a:	6029      	str	r1, [r5, #0]
c0d05e1c:	2202      	movs	r2, #2
      else
      {
        pep->status = 0x0000;  
      }
      
      USBD_CtlSendData (pdev,
c0d05e1e:	4620      	mov	r0, r4
c0d05e20:	4629      	mov	r1, r5
c0d05e22:	f000 f9e7 	bl	c0d061f4 <USBD_CtlSendData>
c0d05e26:	e01a      	b.n	c0d05e5e <USBD_StdEPReq+0x104>
        USBD_LL_StallEP(pdev , ep_addr);
      }
      break;	
      
    case USBD_STATE_CONFIGURED:   
      if (req->wValue == USB_FEATURE_EP_HALT)
c0d05e28:	8868      	ldrh	r0, [r5, #2]
c0d05e2a:	2800      	cmp	r0, #0
c0d05e2c:	d117      	bne.n	c0d05e5e <USBD_StdEPReq+0x104>
      {
        if ((ep_addr & 0x7F) != 0x00) 
c0d05e2e:	0648      	lsls	r0, r1, #25
c0d05e30:	d012      	beq.n	c0d05e58 <USBD_StdEPReq+0xfe>
        {        
          USBD_LL_ClearStallEP(pdev , ep_addr);
c0d05e32:	4620      	mov	r0, r4
c0d05e34:	f7ff fb9e 	bl	c0d05574 <USBD_LL_ClearStallEP>
          if(usbd_is_valid_intf(pdev, LOBYTE(req->wIndex))) {
c0d05e38:	7928      	ldrb	r0, [r5, #4]
/** @defgroup USBD_REQ_Private_Functions
  * @{
  */ 

unsigned int usbd_is_valid_intf(USBD_HandleTypeDef *pdev , unsigned int intf) {
  return intf < USBD_MAX_NUM_INTERFACES && pdev->interfacesClass[intf].pClass != NULL;
c0d05e3a:	2802      	cmp	r0, #2
c0d05e3c:	d80c      	bhi.n	c0d05e58 <USBD_StdEPReq+0xfe>
c0d05e3e:	00c0      	lsls	r0, r0, #3
c0d05e40:	1820      	adds	r0, r4, r0
c0d05e42:	21f4      	movs	r1, #244	; 0xf4
c0d05e44:	5840      	ldr	r0, [r0, r1]
c0d05e46:	2800      	cmp	r0, #0
c0d05e48:	d006      	beq.n	c0d05e58 <USBD_StdEPReq+0xfe>
c0d05e4a:	6880      	ldr	r0, [r0, #8]
c0d05e4c:	f7fe fc8c 	bl	c0d04768 <pic>
c0d05e50:	4602      	mov	r2, r0
c0d05e52:	4620      	mov	r0, r4
c0d05e54:	4629      	mov	r1, r5
c0d05e56:	4790      	blx	r2
c0d05e58:	4620      	mov	r0, r4
c0d05e5a:	f000 f9f6 	bl	c0d0624a <USBD_CtlSendStatus>
c0d05e5e:	2000      	movs	r0, #0
    
  default:
    break;
  }
  return ret;
}
c0d05e60:	bdb0      	pop	{r4, r5, r7, pc}

c0d05e62 <USBD_ParseSetupRequest>:
* @retval None
*/

void USBD_ParseSetupRequest(USBD_SetupReqTypedef *req, uint8_t *pdata)
{
  req->bmRequest     = *(uint8_t *)  (pdata);
c0d05e62:	780a      	ldrb	r2, [r1, #0]
c0d05e64:	7002      	strb	r2, [r0, #0]
  req->bRequest      = *(uint8_t *)  (pdata +  1);
c0d05e66:	784a      	ldrb	r2, [r1, #1]
c0d05e68:	7042      	strb	r2, [r0, #1]
  req->wValue        = SWAPBYTE      (pdata +  2);
c0d05e6a:	788a      	ldrb	r2, [r1, #2]
c0d05e6c:	78cb      	ldrb	r3, [r1, #3]
c0d05e6e:	021b      	lsls	r3, r3, #8
c0d05e70:	189a      	adds	r2, r3, r2
c0d05e72:	8042      	strh	r2, [r0, #2]
  req->wIndex        = SWAPBYTE      (pdata +  4);
c0d05e74:	790a      	ldrb	r2, [r1, #4]
c0d05e76:	794b      	ldrb	r3, [r1, #5]
c0d05e78:	021b      	lsls	r3, r3, #8
c0d05e7a:	189a      	adds	r2, r3, r2
c0d05e7c:	8082      	strh	r2, [r0, #4]
  req->wLength       = SWAPBYTE      (pdata +  6);
c0d05e7e:	798a      	ldrb	r2, [r1, #6]
c0d05e80:	79c9      	ldrb	r1, [r1, #7]
c0d05e82:	0209      	lsls	r1, r1, #8
c0d05e84:	1889      	adds	r1, r1, r2
c0d05e86:	80c1      	strh	r1, [r0, #6]

}
c0d05e88:	4770      	bx	lr

c0d05e8a <USBD_HID_Setup>:
  * @param  req: usb requests
  * @retval status
  */
uint8_t  USBD_HID_Setup (USBD_HandleTypeDef *pdev, 
                                USBD_SetupReqTypedef *req)
{
c0d05e8a:	b570      	push	{r4, r5, r6, lr}
c0d05e8c:	b082      	sub	sp, #8
c0d05e8e:	460d      	mov	r5, r1
c0d05e90:	4604      	mov	r4, r0
c0d05e92:	a901      	add	r1, sp, #4
c0d05e94:	2000      	movs	r0, #0
  uint16_t len = 0;
c0d05e96:	8008      	strh	r0, [r1, #0]
c0d05e98:	4669      	mov	r1, sp
  uint8_t  *pbuf = NULL;

  uint8_t val = 0;
c0d05e9a:	7008      	strb	r0, [r1, #0]

  switch (req->bmRequest & USB_REQ_TYPE_MASK)
c0d05e9c:	782a      	ldrb	r2, [r5, #0]
c0d05e9e:	2160      	movs	r1, #96	; 0x60
c0d05ea0:	4011      	ands	r1, r2
c0d05ea2:	2900      	cmp	r1, #0
c0d05ea4:	d010      	beq.n	c0d05ec8 <USBD_HID_Setup+0x3e>
c0d05ea6:	2920      	cmp	r1, #32
c0d05ea8:	d138      	bne.n	c0d05f1c <USBD_HID_Setup+0x92>
  {
  case USB_REQ_TYPE_CLASS :  
    switch (req->bRequest)
c0d05eaa:	7869      	ldrb	r1, [r5, #1]
c0d05eac:	460a      	mov	r2, r1
c0d05eae:	3a0a      	subs	r2, #10
c0d05eb0:	2a02      	cmp	r2, #2
c0d05eb2:	d333      	bcc.n	c0d05f1c <USBD_HID_Setup+0x92>
c0d05eb4:	2902      	cmp	r1, #2
c0d05eb6:	d01b      	beq.n	c0d05ef0 <USBD_HID_Setup+0x66>
c0d05eb8:	2903      	cmp	r1, #3
c0d05eba:	d019      	beq.n	c0d05ef0 <USBD_HID_Setup+0x66>
                        (uint8_t *)&val,
                        1);      
      break;      
      
    default:
      USBD_CtlError (pdev, req);
c0d05ebc:	4620      	mov	r0, r4
c0d05ebe:	4629      	mov	r1, r5
c0d05ec0:	f7ff ff1d 	bl	c0d05cfe <USBD_CtlError>
c0d05ec4:	2002      	movs	r0, #2
c0d05ec6:	e029      	b.n	c0d05f1c <USBD_HID_Setup+0x92>
      return USBD_FAIL; 
    }
    break;
    
  case USB_REQ_TYPE_STANDARD:
    switch (req->bRequest)
c0d05ec8:	7869      	ldrb	r1, [r5, #1]
c0d05eca:	290b      	cmp	r1, #11
c0d05ecc:	d013      	beq.n	c0d05ef6 <USBD_HID_Setup+0x6c>
c0d05ece:	290a      	cmp	r1, #10
c0d05ed0:	d00e      	beq.n	c0d05ef0 <USBD_HID_Setup+0x66>
c0d05ed2:	2906      	cmp	r1, #6
c0d05ed4:	d122      	bne.n	c0d05f1c <USBD_HID_Setup+0x92>
    {
    case USB_REQ_GET_DESCRIPTOR: 
      // 0x22
      if( req->wValue >> 8 == HID_REPORT_DESC)
c0d05ed6:	8868      	ldrh	r0, [r5, #2]
c0d05ed8:	0a00      	lsrs	r0, r0, #8
c0d05eda:	2200      	movs	r2, #0
c0d05edc:	2821      	cmp	r0, #33	; 0x21
c0d05ede:	d00e      	beq.n	c0d05efe <USBD_HID_Setup+0x74>
c0d05ee0:	2822      	cmp	r0, #34	; 0x22
c0d05ee2:	4611      	mov	r1, r2
c0d05ee4:	d116      	bne.n	c0d05f14 <USBD_HID_Setup+0x8a>
c0d05ee6:	ae01      	add	r6, sp, #4
      {
        pbuf =  USBD_HID_GetReportDescriptor_impl(&len);
c0d05ee8:	4630      	mov	r0, r6
c0d05eea:	f000 f857 	bl	c0d05f9c <USBD_HID_GetReportDescriptor_impl>
c0d05eee:	e00a      	b.n	c0d05f06 <USBD_HID_Setup+0x7c>
c0d05ef0:	4669      	mov	r1, sp
c0d05ef2:	2201      	movs	r2, #1
c0d05ef4:	e00e      	b.n	c0d05f14 <USBD_HID_Setup+0x8a>
                        len);
      break;

    case USB_REQ_SET_INTERFACE :
      //hhid->AltSetting = (uint8_t)(req->wValue);
      USBD_CtlSendStatus(pdev);
c0d05ef6:	4620      	mov	r0, r4
c0d05ef8:	f000 f9a7 	bl	c0d0624a <USBD_CtlSendStatus>
c0d05efc:	e00d      	b.n	c0d05f1a <USBD_HID_Setup+0x90>
c0d05efe:	ae01      	add	r6, sp, #4
        len = MIN(len , req->wLength);
      }
      // 0x21
      else if( req->wValue >> 8 == HID_DESCRIPTOR_TYPE)
      {
        pbuf = USBD_HID_GetHidDescriptor_impl(&len);
c0d05f00:	4630      	mov	r0, r6
c0d05f02:	f000 f831 	bl	c0d05f68 <USBD_HID_GetHidDescriptor_impl>
c0d05f06:	4601      	mov	r1, r0
c0d05f08:	8832      	ldrh	r2, [r6, #0]
c0d05f0a:	88e8      	ldrh	r0, [r5, #6]
c0d05f0c:	4282      	cmp	r2, r0
c0d05f0e:	d300      	bcc.n	c0d05f12 <USBD_HID_Setup+0x88>
c0d05f10:	4602      	mov	r2, r0
c0d05f12:	8032      	strh	r2, [r6, #0]
c0d05f14:	4620      	mov	r0, r4
c0d05f16:	f000 f96d 	bl	c0d061f4 <USBD_CtlSendData>
c0d05f1a:	2000      	movs	r0, #0
      
    }
  }

  return USBD_OK;
}
c0d05f1c:	b002      	add	sp, #8
c0d05f1e:	bd70      	pop	{r4, r5, r6, pc}

c0d05f20 <USBD_HID_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d05f20:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05f22:	b081      	sub	sp, #4
c0d05f24:	4604      	mov	r4, r0
c0d05f26:	2182      	movs	r1, #130	; 0x82
c0d05f28:	2603      	movs	r6, #3
c0d05f2a:	2540      	movs	r5, #64	; 0x40
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d05f2c:	4632      	mov	r2, r6
c0d05f2e:	462b      	mov	r3, r5
c0d05f30:	f7ff fab6 	bl	c0d054a0 <USBD_LL_OpenEP>
c0d05f34:	2702      	movs	r7, #2
                 HID_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d05f36:	4620      	mov	r0, r4
c0d05f38:	4639      	mov	r1, r7
c0d05f3a:	4632      	mov	r2, r6
c0d05f3c:	462b      	mov	r3, r5
c0d05f3e:	f7ff faaf 	bl	c0d054a0 <USBD_LL_OpenEP>
                 HID_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 HID_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR, HID_EPOUT_SIZE);
c0d05f42:	4620      	mov	r0, r4
c0d05f44:	4639      	mov	r1, r7
c0d05f46:	462a      	mov	r2, r5
c0d05f48:	f7ff fb73 	bl	c0d05632 <USBD_LL_PrepareReceive>
c0d05f4c:	2000      	movs	r0, #0
  USBD_LL_Transmit (pdev, 
                    HID_EPIN_ADDR,                                      
                    NULL,
                    0);
  */
  return USBD_OK;
c0d05f4e:	b001      	add	sp, #4
c0d05f50:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0d05f52 <USBD_HID_DeInit>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_HID_DeInit (USBD_HandleTypeDef *pdev, 
                                 uint8_t cfgidx)
{
c0d05f52:	b510      	push	{r4, lr}
c0d05f54:	4604      	mov	r4, r0
c0d05f56:	2182      	movs	r1, #130	; 0x82
  UNUSED(cfgidx);
  /* Close HID EP IN */
  USBD_LL_CloseEP(pdev,
c0d05f58:	f7ff fad2 	bl	c0d05500 <USBD_LL_CloseEP>
c0d05f5c:	2102      	movs	r1, #2
                  HID_EPIN_ADDR);
  
  /* Close HID EP OUT */
  USBD_LL_CloseEP(pdev,
c0d05f5e:	4620      	mov	r0, r4
c0d05f60:	f7ff face 	bl	c0d05500 <USBD_LL_CloseEP>
c0d05f64:	2000      	movs	r0, #0
                  HID_EPOUT_ADDR);
  
  return USBD_OK;
c0d05f66:	bd10      	pop	{r4, pc}

c0d05f68 <USBD_HID_GetHidDescriptor_impl>:
{
  *length = sizeof (USBD_CfgDesc);
  return (uint8_t*)USBD_CfgDesc;
}

uint8_t* USBD_HID_GetHidDescriptor_impl(uint16_t* len) {
c0d05f68:	21ec      	movs	r1, #236	; 0xec
  switch (USBD_Device.request.wIndex&0xFF) {
c0d05f6a:	4a09      	ldr	r2, [pc, #36]	; (c0d05f90 <USBD_HID_GetHidDescriptor_impl+0x28>)
c0d05f6c:	5c51      	ldrb	r1, [r2, r1]
c0d05f6e:	2209      	movs	r2, #9
c0d05f70:	2901      	cmp	r1, #1
c0d05f72:	d005      	beq.n	c0d05f80 <USBD_HID_GetHidDescriptor_impl+0x18>
c0d05f74:	2900      	cmp	r1, #0
c0d05f76:	d106      	bne.n	c0d05f86 <USBD_HID_GetHidDescriptor_impl+0x1e>
c0d05f78:	4907      	ldr	r1, [pc, #28]	; (c0d05f98 <USBD_HID_GetHidDescriptor_impl+0x30>)
c0d05f7a:	4479      	add	r1, pc
c0d05f7c:	2209      	movs	r2, #9
c0d05f7e:	e004      	b.n	c0d05f8a <USBD_HID_GetHidDescriptor_impl+0x22>
c0d05f80:	4904      	ldr	r1, [pc, #16]	; (c0d05f94 <USBD_HID_GetHidDescriptor_impl+0x2c>)
c0d05f82:	4479      	add	r1, pc
c0d05f84:	e001      	b.n	c0d05f8a <USBD_HID_GetHidDescriptor_impl+0x22>
c0d05f86:	2200      	movs	r2, #0
c0d05f88:	4611      	mov	r1, r2
c0d05f8a:	8002      	strh	r2, [r0, #0]
      *len = sizeof(USBD_HID_Desc);
      return (uint8_t*)USBD_HID_Desc; 
  }
  *len = 0;
  return 0;
}
c0d05f8c:	4608      	mov	r0, r1
c0d05f8e:	4770      	bx	lr
c0d05f90:	200023b8 	.word	0x200023b8
c0d05f94:	00001aca 	.word	0x00001aca
c0d05f98:	00001ade 	.word	0x00001ade

c0d05f9c <USBD_HID_GetReportDescriptor_impl>:

uint8_t* USBD_HID_GetReportDescriptor_impl(uint16_t* len) {
c0d05f9c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d05f9e:	b081      	sub	sp, #4
c0d05fa0:	4604      	mov	r4, r0
c0d05fa2:	20ec      	movs	r0, #236	; 0xec
  switch (USBD_Device.request.wIndex&0xFF) {
c0d05fa4:	4913      	ldr	r1, [pc, #76]	; (c0d05ff4 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d05fa6:	5c08      	ldrb	r0, [r1, r0]
c0d05fa8:	2122      	movs	r1, #34	; 0x22
c0d05faa:	2800      	cmp	r0, #0
c0d05fac:	d019      	beq.n	c0d05fe2 <USBD_HID_GetReportDescriptor_impl+0x46>
c0d05fae:	2801      	cmp	r0, #1
c0d05fb0:	d11a      	bne.n	c0d05fe8 <USBD_HID_GetReportDescriptor_impl+0x4c>
#ifdef HAVE_IO_U2F
  case U2F_INTF:

    // very dirty work due to lack of callback when USB_HID_Init is called
    USBD_LL_OpenEP(&USBD_Device,
c0d05fb2:	4810      	ldr	r0, [pc, #64]	; (c0d05ff4 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d05fb4:	2181      	movs	r1, #129	; 0x81
c0d05fb6:	2703      	movs	r7, #3
c0d05fb8:	2640      	movs	r6, #64	; 0x40
c0d05fba:	463a      	mov	r2, r7
c0d05fbc:	4633      	mov	r3, r6
c0d05fbe:	f7ff fa6f 	bl	c0d054a0 <USBD_LL_OpenEP>
c0d05fc2:	2501      	movs	r5, #1
                   U2F_EPIN_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPIN_SIZE);
    
    USBD_LL_OpenEP(&USBD_Device,
c0d05fc4:	480b      	ldr	r0, [pc, #44]	; (c0d05ff4 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d05fc6:	4629      	mov	r1, r5
c0d05fc8:	463a      	mov	r2, r7
c0d05fca:	4633      	mov	r3, r6
c0d05fcc:	f7ff fa68 	bl	c0d054a0 <USBD_LL_OpenEP>
                   U2F_EPOUT_ADDR,
                   USBD_EP_TYPE_INTR,
                   U2F_EPOUT_SIZE);

    /* Prepare Out endpoint to receive 1st packet */ 
    USBD_LL_PrepareReceive(&USBD_Device, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d05fd0:	4808      	ldr	r0, [pc, #32]	; (c0d05ff4 <USBD_HID_GetReportDescriptor_impl+0x58>)
c0d05fd2:	4629      	mov	r1, r5
c0d05fd4:	4632      	mov	r2, r6
c0d05fd6:	f7ff fb2c 	bl	c0d05632 <USBD_LL_PrepareReceive>
c0d05fda:	4808      	ldr	r0, [pc, #32]	; (c0d05ffc <USBD_HID_GetReportDescriptor_impl+0x60>)
c0d05fdc:	4478      	add	r0, pc
c0d05fde:	2122      	movs	r1, #34	; 0x22
c0d05fe0:	e004      	b.n	c0d05fec <USBD_HID_GetReportDescriptor_impl+0x50>
c0d05fe2:	4805      	ldr	r0, [pc, #20]	; (c0d05ff8 <USBD_HID_GetReportDescriptor_impl+0x5c>)
c0d05fe4:	4478      	add	r0, pc
c0d05fe6:	e001      	b.n	c0d05fec <USBD_HID_GetReportDescriptor_impl+0x50>
c0d05fe8:	2100      	movs	r1, #0
c0d05fea:	4608      	mov	r0, r1
c0d05fec:	8021      	strh	r1, [r4, #0]
    *len = sizeof(HID_ReportDesc);
    return (uint8_t*)HID_ReportDesc;
  }
  *len = 0;
  return 0;
}
c0d05fee:	b001      	add	sp, #4
c0d05ff0:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d05ff2:	46c0      	nop			; (mov r8, r8)
c0d05ff4:	200023b8 	.word	0x200023b8
c0d05ff8:	00001a9f 	.word	0x00001a9f
c0d05ffc:	00001a85 	.word	0x00001a85

c0d06000 <USBD_U2F_Init>:
  * @param  cfgidx: Configuration index
  * @retval status
  */
uint8_t  USBD_U2F_Init (USBD_HandleTypeDef *pdev, 
                               uint8_t cfgidx)
{
c0d06000:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d06002:	b081      	sub	sp, #4
c0d06004:	4604      	mov	r4, r0
c0d06006:	2181      	movs	r1, #129	; 0x81
c0d06008:	2603      	movs	r6, #3
c0d0600a:	2540      	movs	r5, #64	; 0x40
  UNUSED(cfgidx);

  /* Open EP IN */
  USBD_LL_OpenEP(pdev,
c0d0600c:	4632      	mov	r2, r6
c0d0600e:	462b      	mov	r3, r5
c0d06010:	f7ff fa46 	bl	c0d054a0 <USBD_LL_OpenEP>
c0d06014:	2701      	movs	r7, #1
                 U2F_EPIN_ADDR,
                 USBD_EP_TYPE_INTR,
                 U2F_EPIN_SIZE);
  
  /* Open EP OUT */
  USBD_LL_OpenEP(pdev,
c0d06016:	4620      	mov	r0, r4
c0d06018:	4639      	mov	r1, r7
c0d0601a:	4632      	mov	r2, r6
c0d0601c:	462b      	mov	r3, r5
c0d0601e:	f7ff fa3f 	bl	c0d054a0 <USBD_LL_OpenEP>
                 U2F_EPOUT_ADDR,
                 USBD_EP_TYPE_INTR,
                 U2F_EPOUT_SIZE);

        /* Prepare Out endpoint to receive 1st packet */ 
  USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR, U2F_EPOUT_SIZE);
c0d06022:	4620      	mov	r0, r4
c0d06024:	4639      	mov	r1, r7
c0d06026:	462a      	mov	r2, r5
c0d06028:	f7ff fb03 	bl	c0d05632 <USBD_LL_PrepareReceive>
c0d0602c:	2000      	movs	r0, #0

  return USBD_OK;
c0d0602e:	b001      	add	sp, #4
c0d06030:	bdf0      	pop	{r4, r5, r6, r7, pc}
	...

c0d06034 <USBD_U2F_DataIn_impl>:
}

uint8_t  USBD_U2F_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d06034:	b580      	push	{r7, lr}
  UNUSED(pdev);
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d06036:	2901      	cmp	r1, #1
c0d06038:	d103      	bne.n	c0d06042 <USBD_U2F_DataIn_impl+0xe>
  // FIDO endpoint
  case (U2F_EPIN_ADDR&0x7F):
    // advance the u2f sending machine state
    u2f_transport_sent(&G_io_u2f, U2F_MEDIA_USB);
c0d0603a:	4803      	ldr	r0, [pc, #12]	; (c0d06048 <USBD_U2F_DataIn_impl+0x14>)
c0d0603c:	2101      	movs	r1, #1
c0d0603e:	f7fe ff9d 	bl	c0d04f7c <u2f_transport_sent>
c0d06042:	2000      	movs	r0, #0
    break;
  } 
  return USBD_OK;
c0d06044:	bd80      	pop	{r7, pc}
c0d06046:	46c0      	nop			; (mov r8, r8)
c0d06048:	200022ec 	.word	0x200022ec

c0d0604c <USBD_U2F_DataOut_impl>:
}

uint8_t  USBD_U2F_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d0604c:	b5b0      	push	{r4, r5, r7, lr}
  switch (epnum) {
c0d0604e:	2901      	cmp	r1, #1
c0d06050:	d10e      	bne.n	c0d06070 <USBD_U2F_DataOut_impl+0x24>
c0d06052:	4614      	mov	r4, r2
c0d06054:	2501      	movs	r5, #1
c0d06056:	2240      	movs	r2, #64	; 0x40
  // FIDO endpoint
  case (U2F_EPOUT_ADDR&0x7F):
      USBD_LL_PrepareReceive(pdev, U2F_EPOUT_ADDR , U2F_EPOUT_SIZE);
c0d06058:	4629      	mov	r1, r5
c0d0605a:	f7ff faea 	bl	c0d05632 <USBD_LL_PrepareReceive>
      u2f_transport_received(&G_io_u2f, buffer, io_seproxyhal_get_ep_rx_size(U2F_EPOUT_ADDR), U2F_MEDIA_USB);
c0d0605e:	4628      	mov	r0, r5
c0d06060:	f7fd fdc4 	bl	c0d03bec <io_seproxyhal_get_ep_rx_size>
c0d06064:	4602      	mov	r2, r0
c0d06066:	4803      	ldr	r0, [pc, #12]	; (c0d06074 <USBD_U2F_DataOut_impl+0x28>)
c0d06068:	4621      	mov	r1, r4
c0d0606a:	462b      	mov	r3, r5
c0d0606c:	f7fe ffec 	bl	c0d05048 <u2f_transport_received>
c0d06070:	2000      	movs	r0, #0
    break;
  }

  return USBD_OK;
c0d06072:	bdb0      	pop	{r4, r5, r7, pc}
c0d06074:	200022ec 	.word	0x200022ec

c0d06078 <USBD_HID_DataIn_impl>:
}
#endif // HAVE_IO_U2F

uint8_t  USBD_HID_DataIn_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum)
{
c0d06078:	b580      	push	{r7, lr}
  UNUSED(pdev);
  switch (epnum) {
c0d0607a:	2902      	cmp	r1, #2
c0d0607c:	d103      	bne.n	c0d06086 <USBD_HID_DataIn_impl+0xe>
    // HID gen endpoint
    case (HID_EPIN_ADDR&0x7F):
      io_usb_hid_sent(io_usb_send_apdu_data);
c0d0607e:	4803      	ldr	r0, [pc, #12]	; (c0d0608c <USBD_HID_DataIn_impl+0x14>)
c0d06080:	4478      	add	r0, pc
c0d06082:	f7fd fca1 	bl	c0d039c8 <io_usb_hid_sent>
c0d06086:	2000      	movs	r0, #0
      break;
  }

  return USBD_OK;
c0d06088:	bd80      	pop	{r7, pc}
c0d0608a:	46c0      	nop			; (mov r8, r8)
c0d0608c:	ffffdc29 	.word	0xffffdc29

c0d06090 <USBD_HID_DataOut_impl>:
}

uint8_t  USBD_HID_DataOut_impl (USBD_HandleTypeDef *pdev, 
                              uint8_t epnum, uint8_t* buffer)
{
c0d06090:	b5b0      	push	{r4, r5, r7, lr}
  // only the data hid endpoint will receive data
  switch (epnum) {
c0d06092:	2902      	cmp	r1, #2
c0d06094:	d11c      	bne.n	c0d060d0 <USBD_HID_DataOut_impl+0x40>
c0d06096:	4614      	mov	r4, r2
c0d06098:	2102      	movs	r1, #2
c0d0609a:	2240      	movs	r2, #64	; 0x40

  // HID gen endpoint
  case (HID_EPOUT_ADDR&0x7F):
    // prepare receiving the next chunk (masked time)
    USBD_LL_PrepareReceive(pdev, HID_EPOUT_ADDR , HID_EPOUT_SIZE);
c0d0609c:	f7ff fac9 	bl	c0d05632 <USBD_LL_PrepareReceive>

    // avoid troubles when an apdu has not been replied yet
    if (G_io_apdu_media == IO_APDU_MEDIA_NONE) {      
c0d060a0:	4d0c      	ldr	r5, [pc, #48]	; (c0d060d4 <USBD_HID_DataOut_impl+0x44>)
c0d060a2:	7828      	ldrb	r0, [r5, #0]
c0d060a4:	2800      	cmp	r0, #0
c0d060a6:	d113      	bne.n	c0d060d0 <USBD_HID_DataOut_impl+0x40>
c0d060a8:	2002      	movs	r0, #2
      // add to the hid transport
      switch(io_usb_hid_receive(io_usb_send_apdu_data, buffer, io_seproxyhal_get_ep_rx_size(HID_EPOUT_ADDR))) {
c0d060aa:	f7fd fd9f 	bl	c0d03bec <io_seproxyhal_get_ep_rx_size>
c0d060ae:	4602      	mov	r2, r0
c0d060b0:	480c      	ldr	r0, [pc, #48]	; (c0d060e4 <USBD_HID_DataOut_impl+0x54>)
c0d060b2:	4478      	add	r0, pc
c0d060b4:	4621      	mov	r1, r4
c0d060b6:	f7fd fb85 	bl	c0d037c4 <io_usb_hid_receive>
c0d060ba:	2802      	cmp	r0, #2
c0d060bc:	d108      	bne.n	c0d060d0 <USBD_HID_DataOut_impl+0x40>
c0d060be:	2001      	movs	r0, #1
        default:
          break;

        case IO_USB_APDU_RECEIVED:
          G_io_apdu_media = IO_APDU_MEDIA_USB_HID; // for application code
c0d060c0:	7028      	strb	r0, [r5, #0]
          G_io_apdu_state = APDU_USB_HID; // for next call to io_exchange
c0d060c2:	4805      	ldr	r0, [pc, #20]	; (c0d060d8 <USBD_HID_DataOut_impl+0x48>)
c0d060c4:	2107      	movs	r1, #7
c0d060c6:	7001      	strb	r1, [r0, #0]
          G_io_apdu_length = G_io_usb_hid_total_length;
c0d060c8:	4804      	ldr	r0, [pc, #16]	; (c0d060dc <USBD_HID_DataOut_impl+0x4c>)
c0d060ca:	6800      	ldr	r0, [r0, #0]
c0d060cc:	4904      	ldr	r1, [pc, #16]	; (c0d060e0 <USBD_HID_DataOut_impl+0x50>)
c0d060ce:	8008      	strh	r0, [r1, #0]
c0d060d0:	2000      	movs	r0, #0
      }
    }
    break;
  }

  return USBD_OK;
c0d060d2:	bdb0      	pop	{r4, r5, r7, pc}
c0d060d4:	200022c8 	.word	0x200022c8
c0d060d8:	200022dc 	.word	0x200022dc
c0d060dc:	20002164 	.word	0x20002164
c0d060e0:	200022de 	.word	0x200022de
c0d060e4:	ffffdbf7 	.word	0xffffdbf7

c0d060e8 <USBD_DeviceDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_DeviceDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d060e8:	2012      	movs	r0, #18
  UNUSED(speed);
  *length = sizeof(USBD_DeviceDesc);
c0d060ea:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_DeviceDesc;
c0d060ec:	4801      	ldr	r0, [pc, #4]	; (c0d060f4 <USBD_DeviceDescriptor+0xc>)
c0d060ee:	4478      	add	r0, pc
c0d060f0:	4770      	bx	lr
c0d060f2:	46c0      	nop			; (mov r8, r8)
c0d060f4:	00001a4a 	.word	0x00001a4a

c0d060f8 <USBD_LangIDStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_LangIDStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d060f8:	2004      	movs	r0, #4
  UNUSED(speed);
  *length = sizeof(USBD_LangIDDesc);  
c0d060fa:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_LangIDDesc;
c0d060fc:	4801      	ldr	r0, [pc, #4]	; (c0d06104 <USBD_LangIDStrDescriptor+0xc>)
c0d060fe:	4478      	add	r0, pc
c0d06100:	4770      	bx	lr
c0d06102:	46c0      	nop			; (mov r8, r8)
c0d06104:	00001a4c 	.word	0x00001a4c

c0d06108 <USBD_ManufacturerStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ManufacturerStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06108:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_MANUFACTURER_STRING);
c0d0610a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_MANUFACTURER_STRING;
c0d0610c:	4801      	ldr	r0, [pc, #4]	; (c0d06114 <USBD_ManufacturerStrDescriptor+0xc>)
c0d0610e:	4478      	add	r0, pc
c0d06110:	4770      	bx	lr
c0d06112:	46c0      	nop			; (mov r8, r8)
c0d06114:	00001a40 	.word	0x00001a40

c0d06118 <USBD_ProductStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ProductStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06118:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_PRODUCT_FS_STRING);
c0d0611a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_PRODUCT_FS_STRING;
c0d0611c:	4801      	ldr	r0, [pc, #4]	; (c0d06124 <USBD_ProductStrDescriptor+0xc>)
c0d0611e:	4478      	add	r0, pc
c0d06120:	4770      	bx	lr
c0d06122:	46c0      	nop			; (mov r8, r8)
c0d06124:	00001a3e 	.word	0x00001a3e

c0d06128 <USBD_SerialStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_SerialStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06128:	200a      	movs	r0, #10
  UNUSED(speed);
  *length = sizeof(USB_SERIAL_STRING);
c0d0612a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USB_SERIAL_STRING;
c0d0612c:	4801      	ldr	r0, [pc, #4]	; (c0d06134 <USBD_SerialStrDescriptor+0xc>)
c0d0612e:	4478      	add	r0, pc
c0d06130:	4770      	bx	lr
c0d06132:	46c0      	nop			; (mov r8, r8)
c0d06134:	00001a3c 	.word	0x00001a3c

c0d06138 <USBD_ConfigStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_ConfigStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06138:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_CONFIGURATION_FS_STRING);
c0d0613a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_CONFIGURATION_FS_STRING;
c0d0613c:	4801      	ldr	r0, [pc, #4]	; (c0d06144 <USBD_ConfigStrDescriptor+0xc>)
c0d0613e:	4478      	add	r0, pc
c0d06140:	4770      	bx	lr
c0d06142:	46c0      	nop			; (mov r8, r8)
c0d06144:	00001a1e 	.word	0x00001a1e

c0d06148 <USBD_InterfaceStrDescriptor>:
  * @param  speed: Current device speed
  * @param  length: Pointer to data length variable
  * @retval Pointer to descriptor buffer
  */
static uint8_t *USBD_InterfaceStrDescriptor(USBD_SpeedTypeDef speed, uint16_t *length)
{
c0d06148:	200e      	movs	r0, #14
  UNUSED(speed);
  *length = sizeof(USBD_INTERFACE_FS_STRING);
c0d0614a:	8008      	strh	r0, [r1, #0]
  return (uint8_t*)USBD_INTERFACE_FS_STRING;
c0d0614c:	4801      	ldr	r0, [pc, #4]	; (c0d06154 <USBD_InterfaceStrDescriptor+0xc>)
c0d0614e:	4478      	add	r0, pc
c0d06150:	4770      	bx	lr
c0d06152:	46c0      	nop			; (mov r8, r8)
c0d06154:	00001a0e 	.word	0x00001a0e

c0d06158 <USB_power>:
  // nothing to do ?
  return 0;
}
#endif // HAVE_USB_CLASS_CCID

void USB_power(unsigned char enabled) {
c0d06158:	b570      	push	{r4, r5, r6, lr}
c0d0615a:	4604      	mov	r4, r0
c0d0615c:	2045      	movs	r0, #69	; 0x45
c0d0615e:	0085      	lsls	r5, r0, #2
  os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d06160:	4816      	ldr	r0, [pc, #88]	; (c0d061bc <USB_power+0x64>)
c0d06162:	2100      	movs	r1, #0
c0d06164:	462a      	mov	r2, r5
c0d06166:	f7fd fc09 	bl	c0d0397c <os_memset>

  if (enabled) {
c0d0616a:	2c00      	cmp	r4, #0
c0d0616c:	d022      	beq.n	c0d061b4 <USB_power+0x5c>
    os_memset(&USBD_Device, 0, sizeof(USBD_Device));
c0d0616e:	4c13      	ldr	r4, [pc, #76]	; (c0d061bc <USB_power+0x64>)
c0d06170:	2600      	movs	r6, #0
c0d06172:	4620      	mov	r0, r4
c0d06174:	4631      	mov	r1, r6
c0d06176:	462a      	mov	r2, r5
c0d06178:	f7fd fc00 	bl	c0d0397c <os_memset>
    /* Init Device Library */
    USBD_Init(&USBD_Device, (USBD_DescriptorsTypeDef*)&HID_Desc, 0);
c0d0617c:	4912      	ldr	r1, [pc, #72]	; (c0d061c8 <USB_power+0x70>)
c0d0617e:	4479      	add	r1, pc
c0d06180:	4620      	mov	r0, r4
c0d06182:	4632      	mov	r2, r6
c0d06184:	f7ff fa68 	bl	c0d05658 <USBD_Init>
    
    /* Register the HID class */
    USBD_RegisterClassForInterface(HID_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_HID);
c0d06188:	4a10      	ldr	r2, [pc, #64]	; (c0d061cc <USB_power+0x74>)
c0d0618a:	447a      	add	r2, pc
c0d0618c:	4630      	mov	r0, r6
c0d0618e:	4621      	mov	r1, r4
c0d06190:	f7ff fa99 	bl	c0d056c6 <USBD_RegisterClassForInterface>
c0d06194:	2001      	movs	r0, #1
#ifdef HAVE_IO_U2F
    USBD_RegisterClassForInterface(U2F_INTF,  &USBD_Device, (USBD_ClassTypeDef*)&USBD_U2F);
c0d06196:	4a0e      	ldr	r2, [pc, #56]	; (c0d061d0 <USB_power+0x78>)
c0d06198:	447a      	add	r2, pc
c0d0619a:	4621      	mov	r1, r4
c0d0619c:	f7ff fa93 	bl	c0d056c6 <USBD_RegisterClassForInterface>
c0d061a0:	22ff      	movs	r2, #255	; 0xff
c0d061a2:	3252      	adds	r2, #82	; 0x52
    // initialize the U2F tunnel transport
    u2f_transport_init(&G_io_u2f, G_io_apdu_buffer, IO_APDU_BUFFER_SIZE);
c0d061a4:	4806      	ldr	r0, [pc, #24]	; (c0d061c0 <USB_power+0x68>)
c0d061a6:	4907      	ldr	r1, [pc, #28]	; (c0d061c4 <USB_power+0x6c>)
c0d061a8:	f7fe fee0 	bl	c0d04f6c <u2f_transport_init>
    USBD_RegisterClassForInterface(WEBUSB_INTF, &USBD_Device, (USBD_ClassTypeDef*)&USBD_WEBUSB);
    USBD_LL_PrepareReceive(&USBD_Device, WEBUSB_EPOUT_ADDR , WEBUSB_EPOUT_SIZE);
#endif // HAVE_WEBUSB

    /* Start Device Process */
    USBD_Start(&USBD_Device);
c0d061ac:	4620      	mov	r0, r4
c0d061ae:	f7ff fa97 	bl	c0d056e0 <USBD_Start>
  }
  else {
    USBD_DeInit(&USBD_Device);
  }
}
c0d061b2:	bd70      	pop	{r4, r5, r6, pc}

    /* Start Device Process */
    USBD_Start(&USBD_Device);
  }
  else {
    USBD_DeInit(&USBD_Device);
c0d061b4:	4801      	ldr	r0, [pc, #4]	; (c0d061bc <USB_power+0x64>)
c0d061b6:	f7ff fa68 	bl	c0d0568a <USBD_DeInit>
  }
}
c0d061ba:	bd70      	pop	{r4, r5, r6, pc}
c0d061bc:	200023b8 	.word	0x200023b8
c0d061c0:	200022ec 	.word	0x200022ec
c0d061c4:	2000216c 	.word	0x2000216c
c0d061c8:	0000192a 	.word	0x0000192a
c0d061cc:	0000193e 	.word	0x0000193e
c0d061d0:	00001968 	.word	0x00001968

c0d061d4 <USBD_GetCfgDesc_impl>:
  * @param  speed : current device speed
  * @param  length : pointer data length
  * @retval pointer to descriptor buffer
  */
static uint8_t  *USBD_GetCfgDesc_impl (uint16_t *length)
{
c0d061d4:	2149      	movs	r1, #73	; 0x49
  *length = sizeof (USBD_CfgDesc);
c0d061d6:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_CfgDesc;
c0d061d8:	4801      	ldr	r0, [pc, #4]	; (c0d061e0 <USBD_GetCfgDesc_impl+0xc>)
c0d061da:	4478      	add	r0, pc
c0d061dc:	4770      	bx	lr
c0d061de:	46c0      	nop			; (mov r8, r8)
c0d061e0:	0000199a 	.word	0x0000199a

c0d061e4 <USBD_GetDeviceQualifierDesc_impl>:
*         return Device Qualifier descriptor
* @param  length : pointer data length
* @retval pointer to descriptor buffer
*/
static uint8_t  *USBD_GetDeviceQualifierDesc_impl (uint16_t *length)
{
c0d061e4:	210a      	movs	r1, #10
  *length = sizeof (USBD_DeviceQualifierDesc);
c0d061e6:	8001      	strh	r1, [r0, #0]
  return (uint8_t*)USBD_DeviceQualifierDesc;
c0d061e8:	4801      	ldr	r0, [pc, #4]	; (c0d061f0 <USBD_GetDeviceQualifierDesc_impl+0xc>)
c0d061ea:	4478      	add	r0, pc
c0d061ec:	4770      	bx	lr
c0d061ee:	46c0      	nop			; (mov r8, r8)
c0d061f0:	000019d6 	.word	0x000019d6

c0d061f4 <USBD_CtlSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendData (USBD_HandleTypeDef  *pdev, 
                               uint8_t *pbuf,
                               uint16_t len)
{
c0d061f4:	b5b0      	push	{r4, r5, r7, lr}
c0d061f6:	460c      	mov	r4, r1
c0d061f8:	21d4      	movs	r1, #212	; 0xd4
c0d061fa:	2302      	movs	r3, #2
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
c0d061fc:	5043      	str	r3, [r0, r1]
c0d061fe:	2111      	movs	r1, #17
c0d06200:	0109      	lsls	r1, r1, #4
  pdev->ep_in[0].total_length = len;
  pdev->ep_in[0].rem_length   = len;
  // store the continuation data if needed
  pdev->pData = pbuf;
c0d06202:	5044      	str	r4, [r0, r1]
                               uint8_t *pbuf,
                               uint16_t len)
{
  /* Set EP0 State */
  pdev->ep0_state          = USBD_EP0_DATA_IN;                                      
  pdev->ep_in[0].total_length = len;
c0d06204:	6182      	str	r2, [r0, #24]
  pdev->ep_in[0].rem_length   = len;
c0d06206:	61c2      	str	r2, [r0, #28]
  // store the continuation data if needed
  pdev->pData = pbuf;
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));  
c0d06208:	6a01      	ldr	r1, [r0, #32]
c0d0620a:	4291      	cmp	r1, r2
c0d0620c:	d800      	bhi.n	c0d06210 <USBD_CtlSendData+0x1c>
c0d0620e:	460a      	mov	r2, r1
c0d06210:	b293      	uxth	r3, r2
c0d06212:	2500      	movs	r5, #0
c0d06214:	4629      	mov	r1, r5
c0d06216:	4622      	mov	r2, r4
c0d06218:	f7ff f9f2 	bl	c0d05600 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d0621c:	4628      	mov	r0, r5
c0d0621e:	bdb0      	pop	{r4, r5, r7, pc}

c0d06220 <USBD_CtlContinueSendData>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueSendData (USBD_HandleTypeDef  *pdev, 
                                       uint8_t *pbuf,
                                       uint16_t len)
{
c0d06220:	b5b0      	push	{r4, r5, r7, lr}
c0d06222:	460c      	mov	r4, r1
 /* Start the next transfer */
  USBD_LL_Transmit (pdev, 0x00, pbuf, MIN(len, pdev->ep_in[0].maxpacket));   
c0d06224:	6a01      	ldr	r1, [r0, #32]
c0d06226:	4291      	cmp	r1, r2
c0d06228:	d800      	bhi.n	c0d0622c <USBD_CtlContinueSendData+0xc>
c0d0622a:	460a      	mov	r2, r1
c0d0622c:	b293      	uxth	r3, r2
c0d0622e:	2500      	movs	r5, #0
c0d06230:	4629      	mov	r1, r5
c0d06232:	4622      	mov	r2, r4
c0d06234:	f7ff f9e4 	bl	c0d05600 <USBD_LL_Transmit>
  return USBD_OK;
c0d06238:	4628      	mov	r0, r5
c0d0623a:	bdb0      	pop	{r4, r5, r7, pc}

c0d0623c <USBD_CtlContinueRx>:
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlContinueRx (USBD_HandleTypeDef  *pdev, 
                                          uint8_t *pbuf,                                          
                                          uint16_t len)
{
c0d0623c:	b510      	push	{r4, lr}
c0d0623e:	2400      	movs	r4, #0
  UNUSED(pbuf);
  USBD_LL_PrepareReceive (pdev,
c0d06240:	4621      	mov	r1, r4
c0d06242:	f7ff f9f6 	bl	c0d05632 <USBD_LL_PrepareReceive>
                          0,                                            
                          len);
  return USBD_OK;
c0d06246:	4620      	mov	r0, r4
c0d06248:	bd10      	pop	{r4, pc}

c0d0624a <USBD_CtlSendStatus>:
*         send zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlSendStatus (USBD_HandleTypeDef  *pdev)
{
c0d0624a:	b510      	push	{r4, lr}
c0d0624c:	21d4      	movs	r1, #212	; 0xd4
c0d0624e:	2204      	movs	r2, #4

  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_IN;
c0d06250:	5042      	str	r2, [r0, r1]
c0d06252:	2400      	movs	r4, #0
  
 /* Start the transfer */
  USBD_LL_Transmit (pdev, 0x00, NULL, 0);   
c0d06254:	4621      	mov	r1, r4
c0d06256:	4622      	mov	r2, r4
c0d06258:	4623      	mov	r3, r4
c0d0625a:	f7ff f9d1 	bl	c0d05600 <USBD_LL_Transmit>
  
  return USBD_OK;
c0d0625e:	4620      	mov	r0, r4
c0d06260:	bd10      	pop	{r4, pc}

c0d06262 <USBD_CtlReceiveStatus>:
*         receive zero lzngth packet on the ctl pipe
* @param  pdev: device instance
* @retval status
*/
USBD_StatusTypeDef  USBD_CtlReceiveStatus (USBD_HandleTypeDef  *pdev)
{
c0d06262:	b510      	push	{r4, lr}
c0d06264:	21d4      	movs	r1, #212	; 0xd4
c0d06266:	2205      	movs	r2, #5
  /* Set EP0 State */
  pdev->ep0_state = USBD_EP0_STATUS_OUT; 
c0d06268:	5042      	str	r2, [r0, r1]
c0d0626a:	2400      	movs	r4, #0
  
 /* Start the transfer */  
  USBD_LL_PrepareReceive ( pdev,
c0d0626c:	4621      	mov	r1, r4
c0d0626e:	4622      	mov	r2, r4
c0d06270:	f7ff f9df 	bl	c0d05632 <USBD_LL_PrepareReceive>
                    0,
                    0);  

  return USBD_OK;
c0d06274:	4620      	mov	r0, r4
c0d06276:	bd10      	pop	{r4, pc}

c0d06278 <__aeabi_uidiv>:
c0d06278:	2200      	movs	r2, #0
c0d0627a:	0843      	lsrs	r3, r0, #1
c0d0627c:	428b      	cmp	r3, r1
c0d0627e:	d374      	bcc.n	c0d0636a <__aeabi_uidiv+0xf2>
c0d06280:	0903      	lsrs	r3, r0, #4
c0d06282:	428b      	cmp	r3, r1
c0d06284:	d35f      	bcc.n	c0d06346 <__aeabi_uidiv+0xce>
c0d06286:	0a03      	lsrs	r3, r0, #8
c0d06288:	428b      	cmp	r3, r1
c0d0628a:	d344      	bcc.n	c0d06316 <__aeabi_uidiv+0x9e>
c0d0628c:	0b03      	lsrs	r3, r0, #12
c0d0628e:	428b      	cmp	r3, r1
c0d06290:	d328      	bcc.n	c0d062e4 <__aeabi_uidiv+0x6c>
c0d06292:	0c03      	lsrs	r3, r0, #16
c0d06294:	428b      	cmp	r3, r1
c0d06296:	d30d      	bcc.n	c0d062b4 <__aeabi_uidiv+0x3c>
c0d06298:	22ff      	movs	r2, #255	; 0xff
c0d0629a:	0209      	lsls	r1, r1, #8
c0d0629c:	ba12      	rev	r2, r2
c0d0629e:	0c03      	lsrs	r3, r0, #16
c0d062a0:	428b      	cmp	r3, r1
c0d062a2:	d302      	bcc.n	c0d062aa <__aeabi_uidiv+0x32>
c0d062a4:	1212      	asrs	r2, r2, #8
c0d062a6:	0209      	lsls	r1, r1, #8
c0d062a8:	d065      	beq.n	c0d06376 <__aeabi_uidiv+0xfe>
c0d062aa:	0b03      	lsrs	r3, r0, #12
c0d062ac:	428b      	cmp	r3, r1
c0d062ae:	d319      	bcc.n	c0d062e4 <__aeabi_uidiv+0x6c>
c0d062b0:	e000      	b.n	c0d062b4 <__aeabi_uidiv+0x3c>
c0d062b2:	0a09      	lsrs	r1, r1, #8
c0d062b4:	0bc3      	lsrs	r3, r0, #15
c0d062b6:	428b      	cmp	r3, r1
c0d062b8:	d301      	bcc.n	c0d062be <__aeabi_uidiv+0x46>
c0d062ba:	03cb      	lsls	r3, r1, #15
c0d062bc:	1ac0      	subs	r0, r0, r3
c0d062be:	4152      	adcs	r2, r2
c0d062c0:	0b83      	lsrs	r3, r0, #14
c0d062c2:	428b      	cmp	r3, r1
c0d062c4:	d301      	bcc.n	c0d062ca <__aeabi_uidiv+0x52>
c0d062c6:	038b      	lsls	r3, r1, #14
c0d062c8:	1ac0      	subs	r0, r0, r3
c0d062ca:	4152      	adcs	r2, r2
c0d062cc:	0b43      	lsrs	r3, r0, #13
c0d062ce:	428b      	cmp	r3, r1
c0d062d0:	d301      	bcc.n	c0d062d6 <__aeabi_uidiv+0x5e>
c0d062d2:	034b      	lsls	r3, r1, #13
c0d062d4:	1ac0      	subs	r0, r0, r3
c0d062d6:	4152      	adcs	r2, r2
c0d062d8:	0b03      	lsrs	r3, r0, #12
c0d062da:	428b      	cmp	r3, r1
c0d062dc:	d301      	bcc.n	c0d062e2 <__aeabi_uidiv+0x6a>
c0d062de:	030b      	lsls	r3, r1, #12
c0d062e0:	1ac0      	subs	r0, r0, r3
c0d062e2:	4152      	adcs	r2, r2
c0d062e4:	0ac3      	lsrs	r3, r0, #11
c0d062e6:	428b      	cmp	r3, r1
c0d062e8:	d301      	bcc.n	c0d062ee <__aeabi_uidiv+0x76>
c0d062ea:	02cb      	lsls	r3, r1, #11
c0d062ec:	1ac0      	subs	r0, r0, r3
c0d062ee:	4152      	adcs	r2, r2
c0d062f0:	0a83      	lsrs	r3, r0, #10
c0d062f2:	428b      	cmp	r3, r1
c0d062f4:	d301      	bcc.n	c0d062fa <__aeabi_uidiv+0x82>
c0d062f6:	028b      	lsls	r3, r1, #10
c0d062f8:	1ac0      	subs	r0, r0, r3
c0d062fa:	4152      	adcs	r2, r2
c0d062fc:	0a43      	lsrs	r3, r0, #9
c0d062fe:	428b      	cmp	r3, r1
c0d06300:	d301      	bcc.n	c0d06306 <__aeabi_uidiv+0x8e>
c0d06302:	024b      	lsls	r3, r1, #9
c0d06304:	1ac0      	subs	r0, r0, r3
c0d06306:	4152      	adcs	r2, r2
c0d06308:	0a03      	lsrs	r3, r0, #8
c0d0630a:	428b      	cmp	r3, r1
c0d0630c:	d301      	bcc.n	c0d06312 <__aeabi_uidiv+0x9a>
c0d0630e:	020b      	lsls	r3, r1, #8
c0d06310:	1ac0      	subs	r0, r0, r3
c0d06312:	4152      	adcs	r2, r2
c0d06314:	d2cd      	bcs.n	c0d062b2 <__aeabi_uidiv+0x3a>
c0d06316:	09c3      	lsrs	r3, r0, #7
c0d06318:	428b      	cmp	r3, r1
c0d0631a:	d301      	bcc.n	c0d06320 <__aeabi_uidiv+0xa8>
c0d0631c:	01cb      	lsls	r3, r1, #7
c0d0631e:	1ac0      	subs	r0, r0, r3
c0d06320:	4152      	adcs	r2, r2
c0d06322:	0983      	lsrs	r3, r0, #6
c0d06324:	428b      	cmp	r3, r1
c0d06326:	d301      	bcc.n	c0d0632c <__aeabi_uidiv+0xb4>
c0d06328:	018b      	lsls	r3, r1, #6
c0d0632a:	1ac0      	subs	r0, r0, r3
c0d0632c:	4152      	adcs	r2, r2
c0d0632e:	0943      	lsrs	r3, r0, #5
c0d06330:	428b      	cmp	r3, r1
c0d06332:	d301      	bcc.n	c0d06338 <__aeabi_uidiv+0xc0>
c0d06334:	014b      	lsls	r3, r1, #5
c0d06336:	1ac0      	subs	r0, r0, r3
c0d06338:	4152      	adcs	r2, r2
c0d0633a:	0903      	lsrs	r3, r0, #4
c0d0633c:	428b      	cmp	r3, r1
c0d0633e:	d301      	bcc.n	c0d06344 <__aeabi_uidiv+0xcc>
c0d06340:	010b      	lsls	r3, r1, #4
c0d06342:	1ac0      	subs	r0, r0, r3
c0d06344:	4152      	adcs	r2, r2
c0d06346:	08c3      	lsrs	r3, r0, #3
c0d06348:	428b      	cmp	r3, r1
c0d0634a:	d301      	bcc.n	c0d06350 <__aeabi_uidiv+0xd8>
c0d0634c:	00cb      	lsls	r3, r1, #3
c0d0634e:	1ac0      	subs	r0, r0, r3
c0d06350:	4152      	adcs	r2, r2
c0d06352:	0883      	lsrs	r3, r0, #2
c0d06354:	428b      	cmp	r3, r1
c0d06356:	d301      	bcc.n	c0d0635c <__aeabi_uidiv+0xe4>
c0d06358:	008b      	lsls	r3, r1, #2
c0d0635a:	1ac0      	subs	r0, r0, r3
c0d0635c:	4152      	adcs	r2, r2
c0d0635e:	0843      	lsrs	r3, r0, #1
c0d06360:	428b      	cmp	r3, r1
c0d06362:	d301      	bcc.n	c0d06368 <__aeabi_uidiv+0xf0>
c0d06364:	004b      	lsls	r3, r1, #1
c0d06366:	1ac0      	subs	r0, r0, r3
c0d06368:	4152      	adcs	r2, r2
c0d0636a:	1a41      	subs	r1, r0, r1
c0d0636c:	d200      	bcs.n	c0d06370 <__aeabi_uidiv+0xf8>
c0d0636e:	4601      	mov	r1, r0
c0d06370:	4152      	adcs	r2, r2
c0d06372:	4610      	mov	r0, r2
c0d06374:	4770      	bx	lr
c0d06376:	e7ff      	b.n	c0d06378 <__aeabi_uidiv+0x100>
c0d06378:	b501      	push	{r0, lr}
c0d0637a:	2000      	movs	r0, #0
c0d0637c:	f000 f806 	bl	c0d0638c <__aeabi_idiv0>
c0d06380:	bd02      	pop	{r1, pc}
c0d06382:	46c0      	nop			; (mov r8, r8)

c0d06384 <__aeabi_uidivmod>:
c0d06384:	2900      	cmp	r1, #0
c0d06386:	d0f7      	beq.n	c0d06378 <__aeabi_uidiv+0x100>
c0d06388:	e776      	b.n	c0d06278 <__aeabi_uidiv>
c0d0638a:	4770      	bx	lr

c0d0638c <__aeabi_idiv0>:
c0d0638c:	4770      	bx	lr
c0d0638e:	46c0      	nop			; (mov r8, r8)

c0d06390 <__aeabi_llsl>:
c0d06390:	4091      	lsls	r1, r2
c0d06392:	1c03      	adds	r3, r0, #0
c0d06394:	4090      	lsls	r0, r2
c0d06396:	469c      	mov	ip, r3
c0d06398:	3a20      	subs	r2, #32
c0d0639a:	4093      	lsls	r3, r2
c0d0639c:	4319      	orrs	r1, r3
c0d0639e:	4252      	negs	r2, r2
c0d063a0:	4663      	mov	r3, ip
c0d063a2:	40d3      	lsrs	r3, r2
c0d063a4:	4319      	orrs	r1, r3
c0d063a6:	4770      	bx	lr

c0d063a8 <__aeabi_uldivmod>:
c0d063a8:	2b00      	cmp	r3, #0
c0d063aa:	d111      	bne.n	c0d063d0 <__aeabi_uldivmod+0x28>
c0d063ac:	2a00      	cmp	r2, #0
c0d063ae:	d10f      	bne.n	c0d063d0 <__aeabi_uldivmod+0x28>
c0d063b0:	2900      	cmp	r1, #0
c0d063b2:	d100      	bne.n	c0d063b6 <__aeabi_uldivmod+0xe>
c0d063b4:	2800      	cmp	r0, #0
c0d063b6:	d002      	beq.n	c0d063be <__aeabi_uldivmod+0x16>
c0d063b8:	2100      	movs	r1, #0
c0d063ba:	43c9      	mvns	r1, r1
c0d063bc:	1c08      	adds	r0, r1, #0
c0d063be:	b407      	push	{r0, r1, r2}
c0d063c0:	4802      	ldr	r0, [pc, #8]	; (c0d063cc <__aeabi_uldivmod+0x24>)
c0d063c2:	a102      	add	r1, pc, #8	; (adr r1, c0d063cc <__aeabi_uldivmod+0x24>)
c0d063c4:	1840      	adds	r0, r0, r1
c0d063c6:	9002      	str	r0, [sp, #8]
c0d063c8:	bd03      	pop	{r0, r1, pc}
c0d063ca:	46c0      	nop			; (mov r8, r8)
c0d063cc:	ffffffc1 	.word	0xffffffc1
c0d063d0:	b403      	push	{r0, r1}
c0d063d2:	4668      	mov	r0, sp
c0d063d4:	b501      	push	{r0, lr}
c0d063d6:	9802      	ldr	r0, [sp, #8]
c0d063d8:	f000 f832 	bl	c0d06440 <__udivmoddi4>
c0d063dc:	9b01      	ldr	r3, [sp, #4]
c0d063de:	469e      	mov	lr, r3
c0d063e0:	b002      	add	sp, #8
c0d063e2:	bc0c      	pop	{r2, r3}
c0d063e4:	4770      	bx	lr
c0d063e6:	46c0      	nop			; (mov r8, r8)

c0d063e8 <__aeabi_lmul>:
c0d063e8:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d063ea:	464f      	mov	r7, r9
c0d063ec:	4646      	mov	r6, r8
c0d063ee:	b4c0      	push	{r6, r7}
c0d063f0:	0416      	lsls	r6, r2, #16
c0d063f2:	0c36      	lsrs	r6, r6, #16
c0d063f4:	4699      	mov	r9, r3
c0d063f6:	0033      	movs	r3, r6
c0d063f8:	0405      	lsls	r5, r0, #16
c0d063fa:	0c2c      	lsrs	r4, r5, #16
c0d063fc:	0c07      	lsrs	r7, r0, #16
c0d063fe:	0c15      	lsrs	r5, r2, #16
c0d06400:	4363      	muls	r3, r4
c0d06402:	437e      	muls	r6, r7
c0d06404:	436f      	muls	r7, r5
c0d06406:	4365      	muls	r5, r4
c0d06408:	0c1c      	lsrs	r4, r3, #16
c0d0640a:	19ad      	adds	r5, r5, r6
c0d0640c:	1964      	adds	r4, r4, r5
c0d0640e:	469c      	mov	ip, r3
c0d06410:	42a6      	cmp	r6, r4
c0d06412:	d903      	bls.n	c0d0641c <__aeabi_lmul+0x34>
c0d06414:	2380      	movs	r3, #128	; 0x80
c0d06416:	025b      	lsls	r3, r3, #9
c0d06418:	4698      	mov	r8, r3
c0d0641a:	4447      	add	r7, r8
c0d0641c:	4663      	mov	r3, ip
c0d0641e:	0c25      	lsrs	r5, r4, #16
c0d06420:	19ef      	adds	r7, r5, r7
c0d06422:	041d      	lsls	r5, r3, #16
c0d06424:	464b      	mov	r3, r9
c0d06426:	434a      	muls	r2, r1
c0d06428:	4343      	muls	r3, r0
c0d0642a:	0c2d      	lsrs	r5, r5, #16
c0d0642c:	0424      	lsls	r4, r4, #16
c0d0642e:	1964      	adds	r4, r4, r5
c0d06430:	1899      	adds	r1, r3, r2
c0d06432:	19c9      	adds	r1, r1, r7
c0d06434:	0020      	movs	r0, r4
c0d06436:	bc0c      	pop	{r2, r3}
c0d06438:	4690      	mov	r8, r2
c0d0643a:	4699      	mov	r9, r3
c0d0643c:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d0643e:	46c0      	nop			; (mov r8, r8)

c0d06440 <__udivmoddi4>:
c0d06440:	b5f0      	push	{r4, r5, r6, r7, lr}
c0d06442:	464d      	mov	r5, r9
c0d06444:	4656      	mov	r6, sl
c0d06446:	4644      	mov	r4, r8
c0d06448:	465f      	mov	r7, fp
c0d0644a:	b4f0      	push	{r4, r5, r6, r7}
c0d0644c:	4692      	mov	sl, r2
c0d0644e:	b083      	sub	sp, #12
c0d06450:	0004      	movs	r4, r0
c0d06452:	000d      	movs	r5, r1
c0d06454:	4699      	mov	r9, r3
c0d06456:	428b      	cmp	r3, r1
c0d06458:	d82f      	bhi.n	c0d064ba <__udivmoddi4+0x7a>
c0d0645a:	d02c      	beq.n	c0d064b6 <__udivmoddi4+0x76>
c0d0645c:	4649      	mov	r1, r9
c0d0645e:	4650      	mov	r0, sl
c0d06460:	f000 f8ae 	bl	c0d065c0 <__clzdi2>
c0d06464:	0029      	movs	r1, r5
c0d06466:	0006      	movs	r6, r0
c0d06468:	0020      	movs	r0, r4
c0d0646a:	f000 f8a9 	bl	c0d065c0 <__clzdi2>
c0d0646e:	1a33      	subs	r3, r6, r0
c0d06470:	4698      	mov	r8, r3
c0d06472:	3b20      	subs	r3, #32
c0d06474:	469b      	mov	fp, r3
c0d06476:	d500      	bpl.n	c0d0647a <__udivmoddi4+0x3a>
c0d06478:	e074      	b.n	c0d06564 <__udivmoddi4+0x124>
c0d0647a:	4653      	mov	r3, sl
c0d0647c:	465a      	mov	r2, fp
c0d0647e:	4093      	lsls	r3, r2
c0d06480:	001f      	movs	r7, r3
c0d06482:	4653      	mov	r3, sl
c0d06484:	4642      	mov	r2, r8
c0d06486:	4093      	lsls	r3, r2
c0d06488:	001e      	movs	r6, r3
c0d0648a:	42af      	cmp	r7, r5
c0d0648c:	d829      	bhi.n	c0d064e2 <__udivmoddi4+0xa2>
c0d0648e:	d026      	beq.n	c0d064de <__udivmoddi4+0x9e>
c0d06490:	465b      	mov	r3, fp
c0d06492:	1ba4      	subs	r4, r4, r6
c0d06494:	41bd      	sbcs	r5, r7
c0d06496:	2b00      	cmp	r3, #0
c0d06498:	da00      	bge.n	c0d0649c <__udivmoddi4+0x5c>
c0d0649a:	e079      	b.n	c0d06590 <__udivmoddi4+0x150>
c0d0649c:	2200      	movs	r2, #0
c0d0649e:	2300      	movs	r3, #0
c0d064a0:	9200      	str	r2, [sp, #0]
c0d064a2:	9301      	str	r3, [sp, #4]
c0d064a4:	2301      	movs	r3, #1
c0d064a6:	465a      	mov	r2, fp
c0d064a8:	4093      	lsls	r3, r2
c0d064aa:	9301      	str	r3, [sp, #4]
c0d064ac:	2301      	movs	r3, #1
c0d064ae:	4642      	mov	r2, r8
c0d064b0:	4093      	lsls	r3, r2
c0d064b2:	9300      	str	r3, [sp, #0]
c0d064b4:	e019      	b.n	c0d064ea <__udivmoddi4+0xaa>
c0d064b6:	4282      	cmp	r2, r0
c0d064b8:	d9d0      	bls.n	c0d0645c <__udivmoddi4+0x1c>
c0d064ba:	2200      	movs	r2, #0
c0d064bc:	2300      	movs	r3, #0
c0d064be:	9200      	str	r2, [sp, #0]
c0d064c0:	9301      	str	r3, [sp, #4]
c0d064c2:	9b0c      	ldr	r3, [sp, #48]	; 0x30
c0d064c4:	2b00      	cmp	r3, #0
c0d064c6:	d001      	beq.n	c0d064cc <__udivmoddi4+0x8c>
c0d064c8:	601c      	str	r4, [r3, #0]
c0d064ca:	605d      	str	r5, [r3, #4]
c0d064cc:	9800      	ldr	r0, [sp, #0]
c0d064ce:	9901      	ldr	r1, [sp, #4]
c0d064d0:	b003      	add	sp, #12
c0d064d2:	bc3c      	pop	{r2, r3, r4, r5}
c0d064d4:	4690      	mov	r8, r2
c0d064d6:	4699      	mov	r9, r3
c0d064d8:	46a2      	mov	sl, r4
c0d064da:	46ab      	mov	fp, r5
c0d064dc:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0d064de:	42a3      	cmp	r3, r4
c0d064e0:	d9d6      	bls.n	c0d06490 <__udivmoddi4+0x50>
c0d064e2:	2200      	movs	r2, #0
c0d064e4:	2300      	movs	r3, #0
c0d064e6:	9200      	str	r2, [sp, #0]
c0d064e8:	9301      	str	r3, [sp, #4]
c0d064ea:	4643      	mov	r3, r8
c0d064ec:	2b00      	cmp	r3, #0
c0d064ee:	d0e8      	beq.n	c0d064c2 <__udivmoddi4+0x82>
c0d064f0:	07fb      	lsls	r3, r7, #31
c0d064f2:	0872      	lsrs	r2, r6, #1
c0d064f4:	431a      	orrs	r2, r3
c0d064f6:	4646      	mov	r6, r8
c0d064f8:	087b      	lsrs	r3, r7, #1
c0d064fa:	e00e      	b.n	c0d0651a <__udivmoddi4+0xda>
c0d064fc:	42ab      	cmp	r3, r5
c0d064fe:	d101      	bne.n	c0d06504 <__udivmoddi4+0xc4>
c0d06500:	42a2      	cmp	r2, r4
c0d06502:	d80c      	bhi.n	c0d0651e <__udivmoddi4+0xde>
c0d06504:	1aa4      	subs	r4, r4, r2
c0d06506:	419d      	sbcs	r5, r3
c0d06508:	2001      	movs	r0, #1
c0d0650a:	1924      	adds	r4, r4, r4
c0d0650c:	416d      	adcs	r5, r5
c0d0650e:	2100      	movs	r1, #0
c0d06510:	3e01      	subs	r6, #1
c0d06512:	1824      	adds	r4, r4, r0
c0d06514:	414d      	adcs	r5, r1
c0d06516:	2e00      	cmp	r6, #0
c0d06518:	d006      	beq.n	c0d06528 <__udivmoddi4+0xe8>
c0d0651a:	42ab      	cmp	r3, r5
c0d0651c:	d9ee      	bls.n	c0d064fc <__udivmoddi4+0xbc>
c0d0651e:	3e01      	subs	r6, #1
c0d06520:	1924      	adds	r4, r4, r4
c0d06522:	416d      	adcs	r5, r5
c0d06524:	2e00      	cmp	r6, #0
c0d06526:	d1f8      	bne.n	c0d0651a <__udivmoddi4+0xda>
c0d06528:	465b      	mov	r3, fp
c0d0652a:	9800      	ldr	r0, [sp, #0]
c0d0652c:	9901      	ldr	r1, [sp, #4]
c0d0652e:	1900      	adds	r0, r0, r4
c0d06530:	4169      	adcs	r1, r5
c0d06532:	2b00      	cmp	r3, #0
c0d06534:	db22      	blt.n	c0d0657c <__udivmoddi4+0x13c>
c0d06536:	002b      	movs	r3, r5
c0d06538:	465a      	mov	r2, fp
c0d0653a:	40d3      	lsrs	r3, r2
c0d0653c:	002a      	movs	r2, r5
c0d0653e:	4644      	mov	r4, r8
c0d06540:	40e2      	lsrs	r2, r4
c0d06542:	001c      	movs	r4, r3
c0d06544:	465b      	mov	r3, fp
c0d06546:	0015      	movs	r5, r2
c0d06548:	2b00      	cmp	r3, #0
c0d0654a:	db2c      	blt.n	c0d065a6 <__udivmoddi4+0x166>
c0d0654c:	0026      	movs	r6, r4
c0d0654e:	409e      	lsls	r6, r3
c0d06550:	0033      	movs	r3, r6
c0d06552:	0026      	movs	r6, r4
c0d06554:	4647      	mov	r7, r8
c0d06556:	40be      	lsls	r6, r7
c0d06558:	0032      	movs	r2, r6
c0d0655a:	1a80      	subs	r0, r0, r2
c0d0655c:	4199      	sbcs	r1, r3
c0d0655e:	9000      	str	r0, [sp, #0]
c0d06560:	9101      	str	r1, [sp, #4]
c0d06562:	e7ae      	b.n	c0d064c2 <__udivmoddi4+0x82>
c0d06564:	4642      	mov	r2, r8
c0d06566:	2320      	movs	r3, #32
c0d06568:	1a9b      	subs	r3, r3, r2
c0d0656a:	4652      	mov	r2, sl
c0d0656c:	40da      	lsrs	r2, r3
c0d0656e:	4641      	mov	r1, r8
c0d06570:	0013      	movs	r3, r2
c0d06572:	464a      	mov	r2, r9
c0d06574:	408a      	lsls	r2, r1
c0d06576:	0017      	movs	r7, r2
c0d06578:	431f      	orrs	r7, r3
c0d0657a:	e782      	b.n	c0d06482 <__udivmoddi4+0x42>
c0d0657c:	4642      	mov	r2, r8
c0d0657e:	2320      	movs	r3, #32
c0d06580:	1a9b      	subs	r3, r3, r2
c0d06582:	002a      	movs	r2, r5
c0d06584:	4646      	mov	r6, r8
c0d06586:	409a      	lsls	r2, r3
c0d06588:	0023      	movs	r3, r4
c0d0658a:	40f3      	lsrs	r3, r6
c0d0658c:	4313      	orrs	r3, r2
c0d0658e:	e7d5      	b.n	c0d0653c <__udivmoddi4+0xfc>
c0d06590:	4642      	mov	r2, r8
c0d06592:	2320      	movs	r3, #32
c0d06594:	2100      	movs	r1, #0
c0d06596:	1a9b      	subs	r3, r3, r2
c0d06598:	2200      	movs	r2, #0
c0d0659a:	9100      	str	r1, [sp, #0]
c0d0659c:	9201      	str	r2, [sp, #4]
c0d0659e:	2201      	movs	r2, #1
c0d065a0:	40da      	lsrs	r2, r3
c0d065a2:	9201      	str	r2, [sp, #4]
c0d065a4:	e782      	b.n	c0d064ac <__udivmoddi4+0x6c>
c0d065a6:	4642      	mov	r2, r8
c0d065a8:	2320      	movs	r3, #32
c0d065aa:	0026      	movs	r6, r4
c0d065ac:	1a9b      	subs	r3, r3, r2
c0d065ae:	40de      	lsrs	r6, r3
c0d065b0:	002f      	movs	r7, r5
c0d065b2:	46b4      	mov	ip, r6
c0d065b4:	4097      	lsls	r7, r2
c0d065b6:	4666      	mov	r6, ip
c0d065b8:	003b      	movs	r3, r7
c0d065ba:	4333      	orrs	r3, r6
c0d065bc:	e7c9      	b.n	c0d06552 <__udivmoddi4+0x112>
c0d065be:	46c0      	nop			; (mov r8, r8)

c0d065c0 <__clzdi2>:
c0d065c0:	b510      	push	{r4, lr}
c0d065c2:	2900      	cmp	r1, #0
c0d065c4:	d103      	bne.n	c0d065ce <__clzdi2+0xe>
c0d065c6:	f000 f807 	bl	c0d065d8 <__clzsi2>
c0d065ca:	3020      	adds	r0, #32
c0d065cc:	e002      	b.n	c0d065d4 <__clzdi2+0x14>
c0d065ce:	1c08      	adds	r0, r1, #0
c0d065d0:	f000 f802 	bl	c0d065d8 <__clzsi2>
c0d065d4:	bd10      	pop	{r4, pc}
c0d065d6:	46c0      	nop			; (mov r8, r8)

c0d065d8 <__clzsi2>:
c0d065d8:	211c      	movs	r1, #28
c0d065da:	2301      	movs	r3, #1
c0d065dc:	041b      	lsls	r3, r3, #16
c0d065de:	4298      	cmp	r0, r3
c0d065e0:	d301      	bcc.n	c0d065e6 <__clzsi2+0xe>
c0d065e2:	0c00      	lsrs	r0, r0, #16
c0d065e4:	3910      	subs	r1, #16
c0d065e6:	0a1b      	lsrs	r3, r3, #8
c0d065e8:	4298      	cmp	r0, r3
c0d065ea:	d301      	bcc.n	c0d065f0 <__clzsi2+0x18>
c0d065ec:	0a00      	lsrs	r0, r0, #8
c0d065ee:	3908      	subs	r1, #8
c0d065f0:	091b      	lsrs	r3, r3, #4
c0d065f2:	4298      	cmp	r0, r3
c0d065f4:	d301      	bcc.n	c0d065fa <__clzsi2+0x22>
c0d065f6:	0900      	lsrs	r0, r0, #4
c0d065f8:	3904      	subs	r1, #4
c0d065fa:	a202      	add	r2, pc, #8	; (adr r2, c0d06604 <__clzsi2+0x2c>)
c0d065fc:	5c10      	ldrb	r0, [r2, r0]
c0d065fe:	1840      	adds	r0, r0, r1
c0d06600:	4770      	bx	lr
c0d06602:	46c0      	nop			; (mov r8, r8)
c0d06604:	02020304 	.word	0x02020304
c0d06608:	01010101 	.word	0x01010101
	...

c0d06614 <__aeabi_memclr>:
c0d06614:	b510      	push	{r4, lr}
c0d06616:	2200      	movs	r2, #0
c0d06618:	f000 f806 	bl	c0d06628 <__aeabi_memset>
c0d0661c:	bd10      	pop	{r4, pc}
c0d0661e:	46c0      	nop			; (mov r8, r8)

c0d06620 <__aeabi_memcpy>:
c0d06620:	b510      	push	{r4, lr}
c0d06622:	f000 f809 	bl	c0d06638 <memcpy>
c0d06626:	bd10      	pop	{r4, pc}

c0d06628 <__aeabi_memset>:
c0d06628:	0013      	movs	r3, r2
c0d0662a:	b510      	push	{r4, lr}
c0d0662c:	000a      	movs	r2, r1
c0d0662e:	0019      	movs	r1, r3
c0d06630:	f000 f840 	bl	c0d066b4 <memset>
c0d06634:	bd10      	pop	{r4, pc}
c0d06636:	46c0      	nop			; (mov r8, r8)

c0d06638 <memcpy>:
c0d06638:	b570      	push	{r4, r5, r6, lr}
c0d0663a:	2a0f      	cmp	r2, #15
c0d0663c:	d932      	bls.n	c0d066a4 <memcpy+0x6c>
c0d0663e:	000c      	movs	r4, r1
c0d06640:	4304      	orrs	r4, r0
c0d06642:	000b      	movs	r3, r1
c0d06644:	07a4      	lsls	r4, r4, #30
c0d06646:	d131      	bne.n	c0d066ac <memcpy+0x74>
c0d06648:	0015      	movs	r5, r2
c0d0664a:	0004      	movs	r4, r0
c0d0664c:	3d10      	subs	r5, #16
c0d0664e:	092d      	lsrs	r5, r5, #4
c0d06650:	3501      	adds	r5, #1
c0d06652:	012d      	lsls	r5, r5, #4
c0d06654:	1949      	adds	r1, r1, r5
c0d06656:	681e      	ldr	r6, [r3, #0]
c0d06658:	6026      	str	r6, [r4, #0]
c0d0665a:	685e      	ldr	r6, [r3, #4]
c0d0665c:	6066      	str	r6, [r4, #4]
c0d0665e:	689e      	ldr	r6, [r3, #8]
c0d06660:	60a6      	str	r6, [r4, #8]
c0d06662:	68de      	ldr	r6, [r3, #12]
c0d06664:	3310      	adds	r3, #16
c0d06666:	60e6      	str	r6, [r4, #12]
c0d06668:	3410      	adds	r4, #16
c0d0666a:	4299      	cmp	r1, r3
c0d0666c:	d1f3      	bne.n	c0d06656 <memcpy+0x1e>
c0d0666e:	230f      	movs	r3, #15
c0d06670:	1945      	adds	r5, r0, r5
c0d06672:	4013      	ands	r3, r2
c0d06674:	2b03      	cmp	r3, #3
c0d06676:	d91b      	bls.n	c0d066b0 <memcpy+0x78>
c0d06678:	1f1c      	subs	r4, r3, #4
c0d0667a:	2300      	movs	r3, #0
c0d0667c:	08a4      	lsrs	r4, r4, #2
c0d0667e:	3401      	adds	r4, #1
c0d06680:	00a4      	lsls	r4, r4, #2
c0d06682:	58ce      	ldr	r6, [r1, r3]
c0d06684:	50ee      	str	r6, [r5, r3]
c0d06686:	3304      	adds	r3, #4
c0d06688:	429c      	cmp	r4, r3
c0d0668a:	d1fa      	bne.n	c0d06682 <memcpy+0x4a>
c0d0668c:	2303      	movs	r3, #3
c0d0668e:	192d      	adds	r5, r5, r4
c0d06690:	1909      	adds	r1, r1, r4
c0d06692:	401a      	ands	r2, r3
c0d06694:	d005      	beq.n	c0d066a2 <memcpy+0x6a>
c0d06696:	2300      	movs	r3, #0
c0d06698:	5ccc      	ldrb	r4, [r1, r3]
c0d0669a:	54ec      	strb	r4, [r5, r3]
c0d0669c:	3301      	adds	r3, #1
c0d0669e:	429a      	cmp	r2, r3
c0d066a0:	d1fa      	bne.n	c0d06698 <memcpy+0x60>
c0d066a2:	bd70      	pop	{r4, r5, r6, pc}
c0d066a4:	0005      	movs	r5, r0
c0d066a6:	2a00      	cmp	r2, #0
c0d066a8:	d1f5      	bne.n	c0d06696 <memcpy+0x5e>
c0d066aa:	e7fa      	b.n	c0d066a2 <memcpy+0x6a>
c0d066ac:	0005      	movs	r5, r0
c0d066ae:	e7f2      	b.n	c0d06696 <memcpy+0x5e>
c0d066b0:	001a      	movs	r2, r3
c0d066b2:	e7f8      	b.n	c0d066a6 <memcpy+0x6e>

c0d066b4 <memset>:
c0d066b4:	b570      	push	{r4, r5, r6, lr}
c0d066b6:	0783      	lsls	r3, r0, #30
c0d066b8:	d03f      	beq.n	c0d0673a <memset+0x86>
c0d066ba:	1e54      	subs	r4, r2, #1
c0d066bc:	2a00      	cmp	r2, #0
c0d066be:	d03b      	beq.n	c0d06738 <memset+0x84>
c0d066c0:	b2ce      	uxtb	r6, r1
c0d066c2:	0003      	movs	r3, r0
c0d066c4:	2503      	movs	r5, #3
c0d066c6:	e003      	b.n	c0d066d0 <memset+0x1c>
c0d066c8:	1e62      	subs	r2, r4, #1
c0d066ca:	2c00      	cmp	r4, #0
c0d066cc:	d034      	beq.n	c0d06738 <memset+0x84>
c0d066ce:	0014      	movs	r4, r2
c0d066d0:	3301      	adds	r3, #1
c0d066d2:	1e5a      	subs	r2, r3, #1
c0d066d4:	7016      	strb	r6, [r2, #0]
c0d066d6:	422b      	tst	r3, r5
c0d066d8:	d1f6      	bne.n	c0d066c8 <memset+0x14>
c0d066da:	2c03      	cmp	r4, #3
c0d066dc:	d924      	bls.n	c0d06728 <memset+0x74>
c0d066de:	25ff      	movs	r5, #255	; 0xff
c0d066e0:	400d      	ands	r5, r1
c0d066e2:	022a      	lsls	r2, r5, #8
c0d066e4:	4315      	orrs	r5, r2
c0d066e6:	042a      	lsls	r2, r5, #16
c0d066e8:	4315      	orrs	r5, r2
c0d066ea:	2c0f      	cmp	r4, #15
c0d066ec:	d911      	bls.n	c0d06712 <memset+0x5e>
c0d066ee:	0026      	movs	r6, r4
c0d066f0:	3e10      	subs	r6, #16
c0d066f2:	0936      	lsrs	r6, r6, #4
c0d066f4:	3601      	adds	r6, #1
c0d066f6:	0136      	lsls	r6, r6, #4
c0d066f8:	001a      	movs	r2, r3
c0d066fa:	199b      	adds	r3, r3, r6
c0d066fc:	6015      	str	r5, [r2, #0]
c0d066fe:	6055      	str	r5, [r2, #4]
c0d06700:	6095      	str	r5, [r2, #8]
c0d06702:	60d5      	str	r5, [r2, #12]
c0d06704:	3210      	adds	r2, #16
c0d06706:	4293      	cmp	r3, r2
c0d06708:	d1f8      	bne.n	c0d066fc <memset+0x48>
c0d0670a:	220f      	movs	r2, #15
c0d0670c:	4014      	ands	r4, r2
c0d0670e:	2c03      	cmp	r4, #3
c0d06710:	d90a      	bls.n	c0d06728 <memset+0x74>
c0d06712:	1f26      	subs	r6, r4, #4
c0d06714:	08b6      	lsrs	r6, r6, #2
c0d06716:	3601      	adds	r6, #1
c0d06718:	00b6      	lsls	r6, r6, #2
c0d0671a:	001a      	movs	r2, r3
c0d0671c:	199b      	adds	r3, r3, r6
c0d0671e:	c220      	stmia	r2!, {r5}
c0d06720:	4293      	cmp	r3, r2
c0d06722:	d1fc      	bne.n	c0d0671e <memset+0x6a>
c0d06724:	2203      	movs	r2, #3
c0d06726:	4014      	ands	r4, r2
c0d06728:	2c00      	cmp	r4, #0
c0d0672a:	d005      	beq.n	c0d06738 <memset+0x84>
c0d0672c:	b2c9      	uxtb	r1, r1
c0d0672e:	191c      	adds	r4, r3, r4
c0d06730:	7019      	strb	r1, [r3, #0]
c0d06732:	3301      	adds	r3, #1
c0d06734:	429c      	cmp	r4, r3
c0d06736:	d1fb      	bne.n	c0d06730 <memset+0x7c>
c0d06738:	bd70      	pop	{r4, r5, r6, pc}
c0d0673a:	0014      	movs	r4, r2
c0d0673c:	0003      	movs	r3, r0
c0d0673e:	e7cc      	b.n	c0d066da <memset+0x26>

c0d06740 <setjmp>:
c0d06740:	c0f0      	stmia	r0!, {r4, r5, r6, r7}
c0d06742:	4641      	mov	r1, r8
c0d06744:	464a      	mov	r2, r9
c0d06746:	4653      	mov	r3, sl
c0d06748:	465c      	mov	r4, fp
c0d0674a:	466d      	mov	r5, sp
c0d0674c:	4676      	mov	r6, lr
c0d0674e:	c07e      	stmia	r0!, {r1, r2, r3, r4, r5, r6}
c0d06750:	3828      	subs	r0, #40	; 0x28
c0d06752:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d06754:	2000      	movs	r0, #0
c0d06756:	4770      	bx	lr

c0d06758 <longjmp>:
c0d06758:	3010      	adds	r0, #16
c0d0675a:	c87c      	ldmia	r0!, {r2, r3, r4, r5, r6}
c0d0675c:	4690      	mov	r8, r2
c0d0675e:	4699      	mov	r9, r3
c0d06760:	46a2      	mov	sl, r4
c0d06762:	46ab      	mov	fp, r5
c0d06764:	46b5      	mov	sp, r6
c0d06766:	c808      	ldmia	r0!, {r3}
c0d06768:	3828      	subs	r0, #40	; 0x28
c0d0676a:	c8f0      	ldmia	r0!, {r4, r5, r6, r7}
c0d0676c:	1c08      	adds	r0, r1, #0
c0d0676e:	d100      	bne.n	c0d06772 <longjmp+0x1a>
c0d06770:	2001      	movs	r0, #1
c0d06772:	4718      	bx	r3

c0d06774 <strlen>:
c0d06774:	b510      	push	{r4, lr}
c0d06776:	0783      	lsls	r3, r0, #30
c0d06778:	d027      	beq.n	c0d067ca <strlen+0x56>
c0d0677a:	7803      	ldrb	r3, [r0, #0]
c0d0677c:	2b00      	cmp	r3, #0
c0d0677e:	d026      	beq.n	c0d067ce <strlen+0x5a>
c0d06780:	0003      	movs	r3, r0
c0d06782:	2103      	movs	r1, #3
c0d06784:	e002      	b.n	c0d0678c <strlen+0x18>
c0d06786:	781a      	ldrb	r2, [r3, #0]
c0d06788:	2a00      	cmp	r2, #0
c0d0678a:	d01c      	beq.n	c0d067c6 <strlen+0x52>
c0d0678c:	3301      	adds	r3, #1
c0d0678e:	420b      	tst	r3, r1
c0d06790:	d1f9      	bne.n	c0d06786 <strlen+0x12>
c0d06792:	6819      	ldr	r1, [r3, #0]
c0d06794:	4a0f      	ldr	r2, [pc, #60]	; (c0d067d4 <strlen+0x60>)
c0d06796:	4c10      	ldr	r4, [pc, #64]	; (c0d067d8 <strlen+0x64>)
c0d06798:	188a      	adds	r2, r1, r2
c0d0679a:	438a      	bics	r2, r1
c0d0679c:	4222      	tst	r2, r4
c0d0679e:	d10f      	bne.n	c0d067c0 <strlen+0x4c>
c0d067a0:	3304      	adds	r3, #4
c0d067a2:	6819      	ldr	r1, [r3, #0]
c0d067a4:	4a0b      	ldr	r2, [pc, #44]	; (c0d067d4 <strlen+0x60>)
c0d067a6:	188a      	adds	r2, r1, r2
c0d067a8:	438a      	bics	r2, r1
c0d067aa:	4222      	tst	r2, r4
c0d067ac:	d108      	bne.n	c0d067c0 <strlen+0x4c>
c0d067ae:	3304      	adds	r3, #4
c0d067b0:	6819      	ldr	r1, [r3, #0]
c0d067b2:	4a08      	ldr	r2, [pc, #32]	; (c0d067d4 <strlen+0x60>)
c0d067b4:	188a      	adds	r2, r1, r2
c0d067b6:	438a      	bics	r2, r1
c0d067b8:	4222      	tst	r2, r4
c0d067ba:	d0f1      	beq.n	c0d067a0 <strlen+0x2c>
c0d067bc:	e000      	b.n	c0d067c0 <strlen+0x4c>
c0d067be:	3301      	adds	r3, #1
c0d067c0:	781a      	ldrb	r2, [r3, #0]
c0d067c2:	2a00      	cmp	r2, #0
c0d067c4:	d1fb      	bne.n	c0d067be <strlen+0x4a>
c0d067c6:	1a18      	subs	r0, r3, r0
c0d067c8:	bd10      	pop	{r4, pc}
c0d067ca:	0003      	movs	r3, r0
c0d067cc:	e7e1      	b.n	c0d06792 <strlen+0x1e>
c0d067ce:	2000      	movs	r0, #0
c0d067d0:	e7fa      	b.n	c0d067c8 <strlen+0x54>
c0d067d2:	46c0      	nop			; (mov r8, r8)
c0d067d4:	fefefeff 	.word	0xfefefeff
c0d067d8:	80808080 	.word	0x80808080

c0d067dc <C_badge_back_colors>:
c0d067dc:	00000000 00ffffff                       ........

c0d067e4 <C_badge_back_bitmap>:
c0d067e4:	c1fe01e0 067f38fd c4ff81df bcfff37f     .....8..........
c0d067f4:	f1e7e71f 7807f83f 00000000              ....?..x....

c0d06800 <C_badge_back>:
c0d06800:	0000000e 0000000e 00000001 c0d067dc     .............g..
c0d06810:	c0d067e4                                .g..

c0d06814 <C_icon_dashboard_colors>:
c0d06814:	00000000 00ffffff                       ........

c0d0681c <C_icon_dashboard_bitmap>:
c0d0681c:	c1fe01e0 067038ff 9e7e79d8 b9e7e79f     .....8p..y~.....
c0d0682c:	f1c0e601 7807f83f 00000000              ....?..x....

c0d06838 <C_icon_dashboard>:
c0d06838:	0000000e 0000000e 00000001 c0d06814     .............h..
c0d06848:	c0d0681c                                .h..

c0d0684c <C_ED25519_ORDER>:
c0d0684c:	00000010 00000000 00000000 00000000     ................
c0d0685c:	def9de14 d69cf7a2 1a631258 edd3f55c     ........X.c.\...

c0d0686c <C_ED25519_FIELD>:
c0d0686c:	ffffff7f ffffffff ffffffff ffffffff     ................
c0d0687c:	ffffffff ffffffff ffffffff edffffff     ................

c0d0688c <C_fe_ma2>:
c0d0688c:	ffffff7f ffffffff ffffffff ffffffff     ................
c0d0689c:	ffffffff ffffffff c8ffffff c9e33ddb     .............=..

c0d068ac <C_fe_ma>:
c0d068ac:	ffffff7f ffffffff ffffffff ffffffff     ................
c0d068bc:	ffffffff ffffffff ffffffff e792f8ff     ................

c0d068cc <C_fe_fffb1>:
c0d068cc:	effb717e 171bd6da 37c5a920 e319fb41     ~q...... ..7A...
c0d068dc:	a80494d1 8d732ab9 7569a722 ee411c32     .....*s.".iu2.A.

c0d068ec <C_fe_fffb2>:
c0d068ec:	0a1e064d f62c5a04 b751d491 be5f16c0     M....Z,...Q..._.
c0d068fc:	4603de51 dff75604 8364ded2 e09a7c60     Q..F.V....d.`|..

c0d0690c <C_fe_fffb3>:
c0d0690c:	0d114a67 ef08c214 404695b8 eda20d3f     gJ........F@?...
c0d0691c:	4eff2440 294296a5 877d1b58 662c3017     @$.N..B)X.}..0,f

c0d0692c <C_fe_fffb4>:
c0d0692c:	03f3431a f9db6710 88f4c026 2e43f77e     .C...g..&...~.C.
c0d0693c:	08fc46ee 494a3fa1 03193d85 8691b3b6     .F...?JI.=......

c0d0694c <C_fe_sqrtm1>:
c0d0694c:	8024832b 0bdfc14f 99004d2b a7d7fb3d     +.$.O...+M..=...
c0d0695c:	0618432f 78e42fad 271beec4 b0a00e4a     /C.../.x...'J...

c0d0696c <C_fe_qm5div8>:
c0d0696c:	ffffff0f ffffffff ffffffff ffffffff     ................
c0d0697c:	ffffffff ffffffff ffffffff fdffffff     ................

c0d0698c <C_sub_address_prefix>:
c0d0698c:	41627553 00726464                       SubAddr.

c0d06994 <C_ED25519_G>:
c0d06994:	36692104 536ecdd3 e2a4c0fe dcd6fd31     .!i6..nS....1...
c0d069a4:	c72c695c a7259560 2d56c9b2 d5258f60     \i,.`.%...V-`.%.
c0d069b4:	6666661a 66666666 66666666 66666666     .fffffffffffffff
c0d069c4:	66666666 66666666 66666666 66666666     ffffffffffffffff
c0d069d4:	59658b58                                         X

c0d069d5 <C_ED25519_Hy>:
c0d069d5:	7059658b af993715 9fdcea2a ead0adf1     .eYp.7..*.......
c0d069e5:	d551726c a9cf5441 0d3a172c 941f9cd3     lrQ.AT..,.:.....
c0d069f5:	756f6d61 6300746e 696d6d6f 6e656d74     amount.commitmen
c0d06a05:	616d5f74 4d006b73                                t_mask.

c0d06a0c <C_MAGIC>:
c0d06a0c:	454e4f4d 57484f52                       MONEROHW

c0d06a14 <crcTable>:
c0d06a14:	00000000 77073096 ee0e612c 990951ba     .....0.w,a...Q..
c0d06a24:	076dc419 706af48f e963a535 9e6495a3     ..m...jp5.c...d.
c0d06a34:	0edb8832 79dcb8a4 e0d5e91e 97d2d988     2......y........
c0d06a44:	09b64c2b 7eb17cbd e7b82d07 90bf1d91     +L...|.~.-......
c0d06a54:	1db71064 6ab020f2 f3b97148 84be41de     d.... .jHq...A..
c0d06a64:	1adad47d 6ddde4eb f4d4b551 83d385c7     }......mQ.......
c0d06a74:	136c9856 646ba8c0 fd62f97a 8a65c9ec     V.l...kdz.b...e.
c0d06a84:	14015c4f 63066cd9 fa0f3d63 8d080df5     O\...l.cc=......
c0d06a94:	3b6e20c8 4c69105e d56041e4 a2677172     . n;^.iL.A`.rqg.
c0d06aa4:	3c03e4d1 4b04d447 d20d85fd a50ab56b     ...<G..K....k...
c0d06ab4:	35b5a8fa 42b2986c dbbbc9d6 acbcf940     ...5l..B....@...
c0d06ac4:	32d86ce3 45df5c75 dcd60dcf abd13d59     .l.2u\.E....Y=..
c0d06ad4:	26d930ac 51de003a c8d75180 bfd06116     .0.&:..Q.Q...a..
c0d06ae4:	21b4f4b5 56b3c423 cfba9599 b8bda50f     ...!#..V........
c0d06af4:	2802b89e 5f058808 c60cd9b2 b10be924     ...(..._....$...
c0d06b04:	2f6f7c87 58684c11 c1611dab b6662d3d     .|o/.LhX..a.=-f.
c0d06b14:	76dc4190 01db7106 98d220bc efd5102a     .A.v.q... ..*...
c0d06b24:	71b18589 06b6b51f 9fbfe4a5 e8b8d433     ...q........3...
c0d06b34:	7807c9a2 0f00f934 9609a88e e10e9818     ...x4...........
c0d06b44:	7f6a0dbb 086d3d2d 91646c97 e6635c01     ..j.-=m..ld..\c.
c0d06b54:	6b6b51f4 1c6c6162 856530d8 f262004e     .Qkkbal..0e.N.b.
c0d06b64:	6c0695ed 1b01a57b 8208f4c1 f50fc457     ...l{.......W...
c0d06b74:	65b0d9c6 12b7e950 8bbeb8ea fcb9887c     ...eP.......|...
c0d06b84:	62dd1ddf 15da2d49 8cd37cf3 fbd44c65     ...bI-...|..eL..
c0d06b94:	4db26158 3ab551ce a3bc0074 d4bb30e2     Xa.M.Q.:t....0..
c0d06ba4:	4adfa541 3dd895d7 a4d1c46d d3d6f4fb     A..J...=m.......
c0d06bb4:	4369e96a 346ed9fc ad678846 da60b8d0     j.iC..n4F.g...`.
c0d06bc4:	44042d73 33031de5 aa0a4c5f dd0d7cc9     s-.D...3_L...|..
c0d06bd4:	5005713c 270241aa be0b1010 c90c2086     <q.P.A.'..... ..
c0d06be4:	5768b525 206f85b3 b966d409 ce61e49f     %.hW..o ..f...a.
c0d06bf4:	5edef90e 29d9c998 b0d09822 c7d7a8b4     ...^...)".......
c0d06c04:	59b33d17 2eb40d81 b7bd5c3b c0ba6cad     .=.Y....;\...l..
c0d06c14:	edb88320 9abfb3b6 03b6e20c 74b1d29a      ..............t
c0d06c24:	ead54739 9dd277af 04db2615 73dc1683     9G...w...&.....s
c0d06c34:	e3630b12 94643b84 0d6d6a3e 7a6a5aa8     ..c..;d.>jm..Zjz
c0d06c44:	e40ecf0b 9309ff9d 0a00ae27 7d079eb1     ........'......}
c0d06c54:	f00f9344 8708a3d2 1e01f268 6906c2fe     D.......h......i
c0d06c64:	f762575d 806567cb 196c3671 6e6b06e7     ]Wb..ge.q6l...kn
c0d06c74:	fed41b76 89d32be0 10da7a5a 67dd4acc     v....+..Zz...J.g
c0d06c84:	f9b9df6f 8ebeeff9 17b7be43 60b08ed5     o.......C......`
c0d06c94:	d6d6a3e8 a1d1937e 38d8c2c4 4fdff252     ....~......8R..O
c0d06ca4:	d1bb67f1 a6bc5767 3fb506dd 48b2364b     .g..gW.....?K6.H
c0d06cb4:	d80d2bda af0a1b4c 36034af6 41047a60     .+..L....J.6`z.A
c0d06cc4:	df60efc3 a867df55 316e8eef 4669be79     ..`.U.g...n1y.iF
c0d06cd4:	cb61b38c bc66831a 256fd2a0 5268e236     ..a...f...o%6.hR
c0d06ce4:	cc0c7795 bb0b4703 220216b9 5505262f     .w...G....."/&.U
c0d06cf4:	c5ba3bbe b2bd0b28 2bb45a92 5cb36a04     .;..(....Z.+.j.\
c0d06d04:	c2d7ffa7 b5d0cf31 2cd99e8b 5bdeae1d     ....1......,...[
c0d06d14:	9b64c2b0 ec63f226 756aa39c 026d930a     ..d.&.c...ju..m.
c0d06d24:	9c0906a9 eb0e363f 72076785 05005713     ....?6...g.r.W..
c0d06d34:	95bf4a82 e2b87a14 7bb12bae 0cb61b38     .J...z...+.{8...
c0d06d44:	92d28e9b e5d5be0d 7cdcefb7 0bdbdf21     ...........|!...
c0d06d54:	86d3d2d4 f1d4e242 68ddb3f8 1fda836e     ....B......hn...
c0d06d64:	81be16cd f6b9265b 6fb077e1 18b74777     ....[&...w.owG..
c0d06d74:	88085ae6 ff0f6a70 66063bca 11010b5c     .Z..pj...;.f\...
c0d06d84:	8f659eff f862ae69 616bffd3 166ccf45     ..e.i.b...kaE.l.
c0d06d94:	a00ae278 d70dd2ee 4e048354 3903b3c2     x.......T..N...9
c0d06da4:	a7672661 d06016f7 4969474d 3e6e77db     a&g...`.MGiI.wn>
c0d06db4:	aed16a4a d9d65adc 40df0b66 37d83bf0     Jj...Z..f..@.;.7
c0d06dc4:	a9bcae53 debb9ec5 47b2cf7f 30b5ffe9     S..........G...0
c0d06dd4:	bdbdf21c cabac28a 53b39330 24b4a3a6     ........0..S...$
c0d06de4:	bad03605 cdd70693 54de5729 23d967bf     .6......)W.T.g.#
c0d06df4:	b3667a2e c4614ab8 5d681b02 2a6f2b94     .zf..Ja...h].+o*
c0d06e04:	b40bbe37 c30c8ea1 5a05df1b 2d02ef8d     7..........Z...-

c0d06e14 <alphabet>:
c0d06e14:	34333231 38373635 43424139 47464544     123456789ABCDEFG
c0d06e24:	4c4b4a48 51504e4d 55545352 59585756     HJKLMNPQRSTUVWXY
c0d06e34:	6362615a 67666564 6b6a6968 706f6e6d     Zabcdefghijkmnop
c0d06e44:	74737271 78777675 00007a79              qrstuvwxyz..

c0d06e50 <encoded_block_sizes>:
c0d06e50:	00000000 00000002 00000003 00000005     ................
c0d06e60:	00000006 00000007 00000009 0000000a     ................
c0d06e70:	0000000b 65654620 6d783f00 52003f72     .... Fee.?xmr?.R
c0d06e80:	63656a65 63410074 74706563 454c4300     eject.Accept.CLE
c0d06e90:	57205241 5344524f 4f4e2800 50495720     AR WORDS.(NO WIP
c0d06ea0:	20002945 756f6d41 4400746e 69747365     E). Amount.Desti
c0d06eb0:	6974616e 3f006e6f 74736564 003f312e     nation.?dest.1?.
c0d06ec0:	7365643f 3f322e74 65643f00 332e7473     ?dest.2?.?dest.3
c0d06ed0:	643f003f 2e747365 3f003f34 74736564     ?.?dest.4?.?dest
c0d06ee0:	003f352e 45005854 726f7078 74490074     .5?.TX.Export.It
c0d06ef0:	6c697720 6572206c 00746573 20656874      will reset.the 
c0d06f00:	6c707061 74616369 216e6f69 6f624100     application!.Abo
c0d06f10:	54007472 20747365 7774654e 206b726f     rt.Test Network 
c0d06f20:	61745300 4e206567 6f777465 4d006b72     .Stage Network.M
c0d06f30:	206e6961 7774654e 006b726f 74736554     ain Network.Test
c0d06f40:	74654e20 6b726f77 53002020 65676174      Network  .Stage
c0d06f50:	74654e20 6b726f77 614d0020 4e206e69      Network .Main N
c0d06f60:	6f777465 20206b72 61655200 20796c6c     etwork  .Really 
c0d06f70:	65736552 003f2074 59006f4e 43007365     Reset ?.No.Yes.C
c0d06f80:	676e6168 654e2065 726f7774 6853006b     hange Network.Sh
c0d06f90:	3220776f 6f772035 00736472 65736552     ow 25 words.Rese
c0d06fa0:	61420074 53006b63 00706177 20296328     t.Back.Swap.(c) 
c0d06fb0:	6764654c 53207265 53005341 20636570     Ledger SAS.Spec 
c0d06fc0:	392e3020 4100302e 20207070 2e322e31      0.9.0.App  1.2.
c0d06fd0:	57580032 613f0050 2e726464 3f003f31     2.XWP.?addr.1?.?
c0d06fe0:	72646461 003f322e 6464613f 3f332e72     addr.2?.?addr.3?
c0d06ff0:	64613f00 342e7264 613f003f 2e726464     .?addr.4?.?addr.
c0d07000:	53003f35 69747465 0073676e 756f6241     5?.Settings.Abou
c0d07010:	75510074 61207469 00007070              t.Quit app..

c0d0701c <ui_menu_fee_validation>:
	...
c0d07024:	00000001 00000000 c0d06e74 c0d06e79     ........tn..yn..
	...
c0d0703c:	c0d03005 ffff5331 00000000 c0d06e7f     .0..1S.......n..
c0d0704c:	c0d06e75 00000000 00000000 c0d03005     un...........0..
c0d0705c:	0000acce 00000000 c0d06e86 c0d06e75     .........n..un..
	...

c0d0708c <ui_menu_words>:
c0d0708c:	00000000 c0d0309d 00000000 00000000     .....0..........
c0d0709c:	c0d06f68 c0d06f68 00000000 00000000     ho..ho..........
c0d070ac:	c0d0309d 00000002 00000000 c0d06f68     .0..........ho..
c0d070bc:	c0d06f68 00000000 00000000 c0d0309d     ho...........0..
c0d070cc:	00000004 00000000 c0d06f68 c0d06f68     ........ho..ho..
	...
c0d070e4:	c0d0309d 00000006 00000000 c0d06f68     .0..........ho..
c0d070f4:	c0d06f68 00000000 00000000 c0d0309d     ho...........0..
c0d07104:	00000008 00000000 c0d06f68 c0d06f68     ........ho..ho..
	...
c0d0711c:	c0d0309d 0000000a 00000000 c0d06f68     .0..........ho..
c0d0712c:	c0d06f68 00000000 00000000 c0d0309d     ho...........0..
c0d0713c:	0000000c 00000000 c0d06f68 c0d06f68     ........ho..ho..
	...
c0d07154:	c0d0309d 0000000e 00000000 c0d06f68     .0..........ho..
c0d07164:	c0d06f68 00000000 00000000 c0d0309d     ho...........0..
c0d07174:	00000010 00000000 c0d06f68 c0d06f68     ........ho..ho..
	...
c0d0718c:	c0d0309d 00000012 00000000 c0d06f68     .0..........ho..
c0d0719c:	c0d06f68 00000000 00000000 c0d0309d     ho...........0..
c0d071ac:	00000014 00000000 c0d06f68 c0d06f68     ........ho..ho..
	...
c0d071c4:	c0d0309d 00000016 00000000 c0d06f68     .0..........ho..
c0d071d4:	c0d06f68 00000000 00000000 c0d0309d     ho...........0..
c0d071e4:	00000018 00000000 c0d06f68 c0d06f68     ........ho..ho..
	...
c0d071fc:	c0d030b1 ffffffff 00000000 c0d06e8d     .0...........n..
c0d0720c:	c0d06e99 00000000 00000000 00000000     .n..............
	...

c0d07230 <ui_menu_validation>:
	...
c0d07238:	00000001 00000000 c0d06ea3 c0d06e79     .........n..yn..
	...
c0d07254:	00000003 00000000 c0d06eab c0d06eb7     .........n...n..
	...
c0d07270:	00000004 00000000 c0d06ec0 c0d06ec0     .........n...n..
	...
c0d0728c:	00000005 00000000 c0d06ec9 c0d06ec9     .........n...n..
	...
c0d072a8:	00000006 00000000 c0d06ed2 c0d06ed2     .........n...n..
	...
c0d072c4:	00000007 00000000 c0d06edb c0d06edb     .........n...n..
	...
c0d072dc:	c0d03135 ffff5331 00000000 c0d06e7f     51..1S.......n..
c0d072ec:	c0d06ee4 00000000 00000000 c0d03135     .n..........51..
c0d072fc:	0000acce 00000000 c0d06e86 c0d06ee4     .........n...n..
	...

c0d0732c <ui_export_viewkey>:
c0d0732c:	00000003 00800000 00000020 00000001     ........ .......
c0d0733c:	00000000 00ffffff 00000000 00000000     ................
	...
c0d07364:	00030005 0007000c 00000007 00000000     ................
c0d07374:	00ffffff 00000000 00070000 00000000     ................
	...
c0d0739c:	00750005 0008000d 00000006 00000000     ..u.............
c0d073ac:	00ffffff 00000000 00060000 00000000     ................
	...
c0d073d4:	00000107 0080000c 00000020 00000000     ........ .......
c0d073e4:	00ffffff 00000000 00008008 20002008     ............. . 
	...
c0d0740c:	00000207 0080001a 00000020 00000000     ........ .......
c0d0741c:	00ffffff 00000000 00008008 20002008     ............. . 
	...
c0d07444:	77656956 79654b20 00000000 61656c50     View Key....Plea
c0d07454:	43206573 65636e61 0000006c              se Cancel...

c0d07460 <ui_menu_network>:
	...
c0d07470:	c0d06eee c0d06efc 00000000 00000000     .n...n..........
c0d07480:	c0d03069 00000000 c0d06800 c0d06f0d     i0.......h...o..
c0d07490:	00000000 0000283d 00000000 c0d0346d     ....=(......m4..
c0d074a0:	00000001 00000000 c0d06f13 00000000     .........o......
	...
c0d074b8:	c0d0346d 00000002 00000000 c0d06f21     m4..........!o..
	...
c0d074d4:	c0d0346d 00000000 00000000 c0d06f2f     m4........../o..
	...

c0d07508 <ui_menu_reset>:
	...
c0d07518:	c0d06f69 00000000 00000000 00000000     io..............
c0d07528:	c0d03069 00000000 c0d06800 c0d06f78     i0.......h..xo..
c0d07538:	00000000 0000283d 00000000 c0d03555     ....=(......U5..
	...
c0d07550:	c0d06f7b 00000000 00000000 00000000     {o..............
	...

c0d07578 <ui_menu_settings>:
c0d07578:	00000000 c0d0353d 00000000 00000000     ....=5..........
c0d07588:	c0d06f7f 00000000 00000000 00000000     .o..............
c0d07598:	c0d03119 00000000 00000000 c0d06f8e     .1...........o..
	...
c0d075b0:	c0d07508 00000000 00000000 00000000     .u..............
c0d075c0:	c0d06f9c 00000000 00000000 00000000     .o..............
c0d075d0:	c0d03069 00000002 c0d06800 c0d06fa2     i0.......h...o..
c0d075e0:	00000000 0000283d 00000000 00000000     ....=(..........
	...

c0d07604 <ui_menu_info>:
	...
c0d0760c:	ffffffff 00000000 c0d06fa7 00000000     .........o......
	...
c0d07628:	ffffffff 00000000 c0d06fac 00000000     .........o......
	...
c0d07644:	ffffffff 00000000 c0d06fbb 00000000     .........o......
	...
c0d07660:	ffffffff 00000000 c0d06fc7 00000000     .........o......
	...
c0d07678:	c0d03069 00000003 c0d06800 c0d06fa2     i0.......h...o..
c0d07688:	00000000 0000283d 00000000 00000000     ....=(..........
	...

c0d076ac <ui_menu_pubaddr>:
	...
c0d076b4:	00000003 00000000 c0d06fd2 c0d06fd6     .........o...o..
	...
c0d076d0:	00000004 00000000 c0d06fdf c0d06fdf     .........o...o..
	...
c0d076ec:	00000005 00000000 c0d06fe8 c0d06fe8     .........o...o..
	...
c0d07708:	00000006 00000000 c0d06ff1 c0d06ff1     .........o...o..
	...
c0d07724:	00000007 00000000 c0d06ffa c0d06ffa     .........o...o..
	...
c0d0773c:	c0d03069 00000000 c0d06800 c0d06fa2     i0.......h...o..
c0d0774c:	00000000 0000283d 00000000 00000000     ....=(..........
	...

c0d07770 <ui_menu_main>:
c0d07770:	00000000 c0d036d9 00000000 00000000     .....6..........
c0d07780:	c0d06fd2 c0d06f68 00000000 c0d07578     .o..ho......xu..
	...
c0d0779c:	c0d07003 00000000 00000000 c0d07604     .p...........v..
	...
c0d077b8:	c0d0700c 00000000 00000000 00000000     .p..............
c0d077c8:	c0d04b75 00000000 c0d06838 c0d07012     uK......8h...p..
c0d077d8:	00000000 00001d32 00000000 00000000     ....2...........
	...
c0d077fc:	000001b0 00a7b000 00000000              ............

c0d07808 <ux_menu_elements>:
c0d07808:	00008003 00800000 00000020 00000001     ........ .......
c0d07818:	00000000 00ffffff 00000000 00000000     ................
	...
c0d07840:	00038105 0007000e 00000004 00000000     ................
c0d07850:	00ffffff 00000000 000b0000 00000000     ................
	...
c0d07878:	00768205 0007000e 00000004 00000000     ..v.............
c0d07888:	00ffffff 00000000 000c0000 00000000     ................
	...
c0d078b0:	000e4107 00640003 0000000c 00000000     .A....d.........
c0d078c0:	00ffffff 00000000 0000800a 00000000     ................
	...
c0d078e8:	000e4207 00640023 0000000c 00000000     .B..#.d.........
c0d078f8:	00ffffff 00000000 0000800a 00000000     ................
	...
c0d07920:	000e1005 00000009 00000000 00000000     ................
c0d07930:	00ffffff 00000000 00000000 00000000     ................
	...
c0d07958:	000e2007 00640013 0000000c 00000000     . ....d.........
c0d07968:	00ffffff 00000000 00008008 00000000     ................
	...
c0d07990:	000e2107 0064000c 0000000c 00000000     .!....d.........
c0d079a0:	00ffffff 00000000 00008008 00000000     ................
	...
c0d079c8:	000e2207 0064001a 0000000c 00000000     ."....d.........
c0d079d8:	00ffffff 00000000 00008008 00000000     ................
	...

c0d07a00 <UX_MENU_END_ENTRY>:
	...

c0d07a1c <SW_INTERNAL>:
c0d07a1c:	0190006f                                         o.

c0d07a1e <SW_BUSY>:
c0d07a1e:	00670190                                         ..

c0d07a20 <SW_WRONG_LENGTH>:
c0d07a20:	85690067                                         g.

c0d07a22 <SW_PROOF_OF_PRESENCE_REQUIRED>:
c0d07a22:	d0f18569 00000000 4e4f4f4d 90009000     i.......MOON....
	...

c0d07a34 <SW_BAD_KEY_HANDLE>:
c0d07a34:	3255806a                                         j.

c0d07a36 <U2F_VERSION>:
c0d07a36:	5f463255 00903256                       U2F_V2..

c0d07a3e <INFO>:
c0d07a3e:	00900901                                ....

c0d07a42 <SW_UNKNOWN_CLASS>:
c0d07a42:	006d006e                                         n.

c0d07a44 <SW_UNKNOWN_INSTRUCTION>:
c0d07a44:	ffff006d                                         m.

c0d07a46 <BROADCAST_CHANNEL>:
c0d07a46:	ffffffff                                ....

c0d07a4a <FORBIDDEN_CHANNEL>:
c0d07a4a:	00000000 21090000                                ......

c0d07a50 <USBD_HID_Desc_fido>:
c0d07a50:	01112109 22220121 00000000              .!..!.""....

c0d07a5c <USBD_HID_Desc>:
c0d07a5c:	01112109 22220100 f1d00600                       .!...."".

c0d07a65 <HID_ReportDesc_fido>:
c0d07a65:	09f1d006 0901a101 26001503 087500ff     ...........&..u.
c0d07a75:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d07a85:	a006c008                                         ..

c0d07a87 <HID_ReportDesc>:
c0d07a87:	09ffa006 0901a101 26001503 087500ff     ...........&..u.
c0d07a97:	08814095 00150409 7500ff26 91409508     .@......&..u..@.
c0d07aa7:	0000c008 d060e900                                .....

c0d07aac <HID_Desc>:
c0d07aac:	c0d060e9 c0d060f9 c0d06109 c0d06119     .`...`...a...a..
c0d07abc:	c0d06129 c0d06139 c0d06149 00000000     )a..9a..Ia......

c0d07acc <USBD_HID>:
c0d07acc:	c0d05f21 c0d05f53 c0d05e8b 00000000     !_..S_...^......
c0d07adc:	00000000 c0d06079 c0d06091 00000000     ....y`...`......
	...
c0d07af4:	c0d061d5 c0d061d5 c0d061d5 c0d061e5     .a...a...a...a..

c0d07b04 <USBD_U2F>:
c0d07b04:	c0d06001 c0d05f53 c0d05e8b 00000000     .`..S_...^......
c0d07b14:	00000000 c0d06035 c0d0604d 00000000     ....5`..M`......
	...
c0d07b2c:	c0d061d5 c0d061d5 c0d061d5 c0d061e5     .a...a...a...a..

c0d07b3c <USBD_DeviceDesc>:
c0d07b3c:	02000112 40000000 00012c97 02010200     .......@.,......
c0d07b4c:	03040103                                         ..

c0d07b4e <USBD_LangIDDesc>:
c0d07b4e:	04090304                                ....

c0d07b52 <USBD_MANUFACTURER_STRING>:
c0d07b52:	004c030e 00640065 00650067 030e0072              ..L.e.d.g.e.r.

c0d07b60 <USBD_PRODUCT_FS_STRING>:
c0d07b60:	004e030e 006e0061 0020006f 030a0053              ..N.a.n.o. .S.

c0d07b6e <USB_SERIAL_STRING>:
c0d07b6e:	0030030a 00300030 02090031                       ..0.0.0.1.

c0d07b78 <USBD_CfgDesc>:
c0d07b78:	00490209 c0020102 00040932 00030200     ..I.....2.......
c0d07b88:	21090200 01000111 07002222 40038205     ...!...."".....@
c0d07b98:	05070100 00400302 01040901 01030200     ......@.........
c0d07ba8:	21090201 01210111 07002222 40038105     ...!..!."".....@
c0d07bb8:	05070100 00400301 00000001              ......@.....

c0d07bc4 <USBD_DeviceQualifierDesc>:
c0d07bc4:	0200060a 40000000 00000001              .......@....

c0d07bd0 <_etext>:
	...

c0d07c00 <N_state_pic>:
	...
