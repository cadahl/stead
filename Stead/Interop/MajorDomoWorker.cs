using System;
using System.Runtime.InteropServices;

namespace Stead.Interop
{
    public static class MajorDomoWorker
    {
        [DllImport("libmdwrkapi.so")]
        public static extern IntPtr mdwrk_new(string broker, string service, bool verbose);

        [DllImport("libmdwrkapi.so")]
        public static extern void mdwrk_destroy(ref IntPtr self_p);

        [DllImport("libmdwrkapi.so")]
        public static extern void mdwrk_set_liveness(IntPtr self, int liveness);

        [DllImport("libmdwrkapi.so")]
        public static extern void mdwrk_set_heartbeat(IntPtr self, int heartbeat);

        [DllImport("libmdwrkapi.so")]
        public static extern void mdwrk_set_reconnect(IntPtr self, bool reconnect);

        [DllImport("libmdwrkapi.so")]
        public static extern IntPtr/*zmsg_t*/ mdwrk_recv(IntPtr self, ref IntPtr/*zms_t ** */ reply_p);
    }
}