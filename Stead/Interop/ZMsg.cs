using System;
using System.Runtime.InteropServices;

namespace Stead.Interop
{
    public static class ZMsg
    {
        [DllImport("libczmq.so")]
        public static extern IntPtr zmsg_dup(IntPtr msg);

        [DllImport("libczmq.so")]
        public static extern IntPtr zmsg_new();

        [DllImport("libczmq.so")]
        public static extern void zmsg_destroy(IntPtr msg);

        [DllImport("libczmq.so")]
        public static extern void zmsg_pushstr(IntPtr msg, string str);
    }
}
