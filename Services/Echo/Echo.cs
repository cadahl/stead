using System;
using System.Runtime.InteropServices;
using Stead.Interop;

namespace Stead.Services
{
  public class WorkerSession : SafeHandle
  {
    public WorkerSession(string broker, string service, bool verbose)
      : base(IntPtr.Zero, true)
    {
      handle = WorkerAPI.mdwrk_new(broker, service, verbose);
    }

    public IntPtr Receive(ref IntPtr reply)
    {
      if(IsInvalid)
        return IntPtr.Zero;

      return WorkerAPI.mdwrk_recv(handle, ref reply);      
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
      WorkerAPI.mdwrk_destroy(ref handle);
      return true;
    }
  }

  public class Echo
  {
    public static void Main(string[] args)
    {
      string broker = args.Count > 0 ? args[0] : "tcp://localhost:5555";

      using(WorkerSession session = new WorkerSession(broker, "echo", false))
      {
        IntPtr reply = IntPtr.Zero;
        
        while(true) 
        {
          IntPtr request = session.Receive(ref reply);

          if(request == IntPtr.Zero)
            break;

          reply = request;
        }
      }
    }
  }
}
