using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApp1
{
    internal class SessionString
    {
        private string _track_id;
        private string _session_time_min;
        private string _session_time_sec;
        private string _session_time_milsec;
        private string _car_id;
        private int _driver_id;
        private string _date;
        private string _note;

        public string TrackID
        { get { return _track_id; } }

        public string Min
        { get { return _session_time_min; } }
        public string Sec
        { get { return _session_time_sec; } }
        public string Milsec
        { get { return _session_time_milsec; } }
        public string Car
        { get { return _car_id; } }
        public int Driver
        { get { return _driver_id; } }
        public string Date
        { get { return _date; } }
        public string Note
        { get { return _note; } }

        public SessionString(string trac, string car, int driver, string date, string min="0", string sec = "0", string milsec = "0", string note = null)
        { 
            this._track_id = trac;
            this._session_time_min = min;
            this._session_time_sec = sec;
            this._session_time_milsec = milsec;
            this._car_id = car;
            this._driver_id = driver;
            this._date = date;
            this._note = note;
        }



    }
}
