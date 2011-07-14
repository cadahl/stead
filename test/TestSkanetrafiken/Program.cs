using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace TestSkanetrafiken
{
    class Program
    {
        static void Main(string[] args)
        {
            string ns = @"{http://www.etis.fskab.se/v1.0/ETISws}";
            string query = @"http://www.labs.skanetrafiken.se/v2.2/resultspage.asp?cmdaction=next&selPointFr=malm%F6%20C|80000|0&selPointTo=hassleholm%20C|93070|0&LastStart=" + Uri.EscapeUriString(DateTime.Now.ToString("yyyy-MM-dd HH:mm"));
            Console.WriteLine(query);

            Stopwatch sw = new Stopwatch();
            sw.Start();

            WebClient wc = new WebClient();
            wc.Proxy = null;
            XDocument doc = XDocument.Load(wc.OpenRead(query));
            var journeys = doc.Descendants(ns + "Journey");

            if (journeys.FirstOrDefault() == null)
            {
                Console.WriteLine("No journey elements.");
                return;
            }

            var results = from j in journeys
                          orderby (int)j.Element(ns + "SequenceNo")
                          let routeLink = j.Element(ns+"RouteLinks").Elements(ns+"RouteLink").First()
                          select new
                                     {
                                         Departure = (DateTime)j.Element(ns + "DepDateTime"),
                                         Arrival = (DateTime)j.Element(ns + "ArrDateTime"),
                                         From = routeLink.Element(ns + "From").Element(ns + "Name").Value,
                                         To = routeLink.Element(ns + "To").Element(ns + "Name").Value,
                                         TransportType = routeLink.Element(ns + "Line").Element(ns + "Name").Value,
                                     };
            
            foreach(var result in results)
            {
                Console.WriteLine(result.Departure.ToShortTimeString() + " " + result.TransportType + " (" + result.From + " - " + result.To + ")" + " " + result.Arrival.ToShortTimeString());
            }

            sw.Stop();
            Console.WriteLine("Total ms: " + sw.ElapsedMilliseconds);



        }
    }
}
