using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls.Primitives;
using System.Windows.Markup;
using Npgsql;

namespace WpfApp1
{
    internal class Commands
    {
        public static NpgsqlDataAdapter InitialConn(NpgsqlConnection conn)
        {
            NpgsqlCommand selCommand = new NpgsqlCommand();
            selCommand.CommandType = System.Data.CommandType.Text;
            selCommand.CommandText = "SELECT * FROM public.compact_all_sessions";
            selCommand.Connection = conn;

            return new NpgsqlDataAdapter(selCommand);
        }

        public static string GetDriverName(NpgsqlConnection conn, string login)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = $"SELECT public.func_get_driver_name('{login}');";
            cmd.Connection = conn;
            string result = (String)cmd.ExecuteScalar();
            return result;
        }

        public static NpgsqlDataReader getTop100(NpgsqlConnection conn)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = @"SELECT * FROM public.top_100_sessions;";
            cmd.Connection = conn;

            return cmd.ExecuteReader();
        }

        public static int deleteSession(NpgsqlConnection conn, string _id)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = $"CALL proc_delete_session({_id});";
            cmd.Connection = conn;

            return cmd.ExecuteNonQuery();
        }

        public static NpgsqlDataReader yourSessions(NpgsqlConnection conn)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = @"SELECT * FROM public.your_sessions;";
            cmd.Connection = conn;

            return cmd.ExecuteReader();
        }

        public static int getDriverID(NpgsqlConnection conn, string _id)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = $"SELECT public.func_get_driver_id('{_id}');";
            cmd.Connection = conn;

            return (Int32)cmd.ExecuteScalar();
        }

        public static int getUserID(NpgsqlConnection conn, string name)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = $"SELECT public.func_get_you_id('{name}');";
            cmd.Connection = conn;

            return (Int32)cmd.ExecuteScalar();
        }

        public static NpgsqlDataReader getLen(NpgsqlConnection conn)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = @"SELECT * FROM public.get_length;";
            cmd.Connection = conn;

            return cmd.ExecuteReader();
        }

        public static int createSession(NpgsqlConnection conn, SessionString session)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;

            if (session.Note == null)
            {
                cmd.CommandText = $"SELECT public.func_create_session({session.TrackID}::smallint,'{session.Min} minutes {session.Sec} seconds {session.Milsec} milliseconds'," +
                                                                   $"{session.Car},{session.Driver},'{session.Date}');";

            }
            else
            {
                cmd.CommandText = $"SELECT public.func_create_session({session.TrackID}::smallint,'{session.Min} minutes {session.Sec} seconds {session.Milsec} milliseconds'," +
                                                                   $"{session.Car},{session.Driver},'{session.Date}', '{session.Note}');";
            }
            cmd.Connection = conn;

            return cmd.ExecuteNonQuery();
        }

        public static NpgsqlDataReader getAllSession(NpgsqlConnection conn)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = @"SELECT * FROM public.compact_all_sessions;";
            cmd.Connection = conn;

            return cmd.ExecuteReader();
        }

        public static NpgsqlDataReader getFullSessionDyID(NpgsqlConnection conn, string _id)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.CommandText = $"SELECT * FROM public.all_sessions WHERE \"Session N\" = {_id};";
            cmd.Connection = conn;

            return cmd.ExecuteReader();
        }

        public static StringBuilder getFullSessionDyIDStr(string _id)
        {
            return new StringBuilder($"SELECT * FROM public.all_sessions WHERE \"Session N\" = {_id};");
        }


        public static int updateSession(NpgsqlConnection conn, SessionString session)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.CommandType = System.Data.CommandType.Text;

            if (session.Note == null)
            {
                cmd.CommandText = $"SELECT public.func_update_session({session.Driver}::bigint,{session.TrackID}::smallint,'{session.Min} minutes " +
                                                                    $"{session.Sec} seconds {session.Milsec} milliseconds'," +
                                                                    $"{session.Car}::integer,'{session.Date}');";
            }
            else
            {
                cmd.CommandText = $"SELECT public.func_update_session({session.Driver}::bigint,{session.TrackID}::smallint,'{session.Min} minutes " +
                                                                    $"{session.Sec} seconds {session.Milsec} milliseconds'," +
                                                                    $"{session.Car}::integer,'{session.Date}','{session.Note}');";
            }
            cmd.Connection = conn;

            return cmd.ExecuteNonQuery();
        }
    }
}
