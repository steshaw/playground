class Unicode {
  public static void main(String[] args) throws Exception {
    byte[] bb = new byte[2];
    for (int b1 = 0xc0; b1 < 0xc2; b1++) {
        for (int b2 = 0x80; b2 < 0xc0; b2++) {
            bb[0] = (byte)b1;
            bb[1] = (byte)b2; 
            String cstr = new String(bb, "utf-8");
            char c = cstr.toCharArray()[0];
            System.out.printf("[%02x, %02x] -> U+%04x [%s]%n",
                              b1, b2, c & 0xffff, (c>=0x20)?cstr:"ctrl");
        }
    }
  }
}
