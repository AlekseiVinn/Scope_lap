using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApp1
{
    internal class Pgstring
    {
        private static string host = "localhost";
        private static string database = "nurngburg";

        public static string Host
        { get { return host; } }

        public static string Database
        { get { return database; } }

        public static string Create(string user, string password)
        {
           return $"Host={Host};Database={Database};Username={user};Password={password}";
        }
    }
}
