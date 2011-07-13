using System;
using System.Runtime.InteropServices;

namespace Stead.Interop
{
    public static class MajorDomoWorker
    {
        [DllImport("mdwrkapi")]
        public static extern IntPtr mdwrk_new(string broker, string service, bool verbose);

        [DllImport("mdwrkapi")]
        public static extern void mdwrk_destroy(ref IntPtr self_p);

        [DllImport("mdwrkapi")]
        public static extern void mdwrk_set_liveness(IntPtr self, int liveness);

        [DllImport("mdwrkapi")]
        public static extern void mdwrk_set_heartbeat(IntPtr self, int heartbeat);

        [DllImport("mdwrkapi")]
        public static extern void mdwrk_set_reconnect(IntPtr self, bool reconnect);

        [DllImport("mdwrkapi")]
        public static extern IntPtr/*zmsg_t*/ mdwrk_recv(IntPtr self, ref IntPtr/*zms_t ** */ reply_p);
    }
}