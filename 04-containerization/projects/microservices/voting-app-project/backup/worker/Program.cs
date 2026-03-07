using System;
using System.Threading;

namespace Worker
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Worker is starting up...");
            while (true)
            {
                Console.WriteLine("Worker checking for votes in Redis...");
                Thread.Sleep(5000);
            }
        }
    }
}
