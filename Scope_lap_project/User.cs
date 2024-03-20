using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApp1
{
    public class User
    {
        private NpgsqlConnection conn;
        private string userName;
        public int ID
        { get; private set; }

        public NpgsqlConnection Connection 
        { get { return conn; } }
        public string UserName
        { get { return userName; } }

        public User(NpgsqlConnection connect, string name)
        { 
            this.conn = connect;
            this.userName = name;
            this.ID = Commands.getUserID(connect, name);
        }


    }
}
