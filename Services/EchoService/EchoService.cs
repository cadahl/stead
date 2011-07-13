using System;
using System.Runtime.InteropServices;
using Stead;

namespace Stead.Services
{
  public class EchoService
  {
    public static void Main(string[] args)
    {
      string broker = args.Length > 0 ? args[0] : "tcp://localhost:5555";

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
