using System;
using System.Runtime.InteropServices;
using Stead.Interop;

namespace Stead
{
    public class WorkerSession : SafeHandle
    {
        public WorkerSession(string broker, string service, bool verbose)
            : base(IntPtr.Zero, true)
        {
            handle = MajorDomoWorker.mdwrk_new(broker, service, verbose);
        }

        public IntPtr Receive(ref IntPtr reply)
        {
            if (IsInvalid)
                return IntPtr.Zero;

            return MajorDomoWorker.mdwrk_recv(handle, ref reply);
        }

        public override bool IsInvalid
        {
            get
            {
                return handle == IntPtr.Zero;
            }
        }

        protected override bool ReleaseHandle()
        {
            MajorDomoWorker.mdwrk_destroy(ref handle);
            return true;
        }
    }

}
