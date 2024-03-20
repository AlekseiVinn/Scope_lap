using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace WpfApp1
{
    /// <summary>
    /// Interaction logic for EditWindow.xaml
    /// </summary>
    public partial class OnEditWindow : Window
    {
        NpgsqlDataAdapter dataAdapter;
        User activeUser;
        DataTable dt;
        string sessionId;


        public OnEditWindow(User ownerUser, string sessionId)
        {
            this.activeUser = ownerUser;
            this.sessionId = sessionId;
            InitializeComponent();

            dataAdapter = new NpgsqlDataAdapter();
            dataAdapter.SelectCommand = new NpgsqlCommand(Commands.getFullSessionDyIDStr(this.sessionId).ToString(), activeUser.Connection);
            dt = new DataTable();
            dataAdapter.Fill(dt);
            Table.ItemsSource = dt.DefaultView;

            dataAdapter = new NpgsqlDataAdapter(@"SELECT *	FROM public.get_length;", activeUser.Connection);
            DataTable track = new DataTable();
            dataAdapter.Fill(track);
            lapConf.ItemsSource = track.DefaultView;
            lapConf.DisplayMemberPath = "conf";
            lapConf.SelectedValuePath = "conf_id";

            dataAdapter = new NpgsqlDataAdapter(@"SELECT *	FROM public.all_cars;", activeUser.Connection);
            DataTable dt2 = new DataTable();
            dataAdapter.Fill(dt2);
            carList.ItemsSource = dt2.DefaultView;
            carList.DisplayMemberPath = "car_name";
            carList.SelectedValuePath = "car_id";

            DriverHeader.Content = Commands.GetDriverName(activeUser.Connection, activeUser.UserName);
        }


        private void cancelBtn_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void newCar_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("We are sorry: functionality unavailable (work in progress)", "Functionality not implemented", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void lapTime_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !IsTextAllowed(e.Text);
        }

        private static readonly Regex _regex = new Regex("[^0-9.-]+"); //regex that matches disallowed text
        private static bool IsTextAllowed(string text)
        {
            return !_regex.IsMatch(text);
        }

        private void okBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                SessionString saveString = new SessionString(lapConf.SelectedValue.ToString(),
                                               carList.SelectedValue.ToString(),
                                               Convert.ToInt32(sessionId),
                                               datePick.SelectedDate.Value.ToShortDateString(),
                                               lapMin.Text,
                                               lapSec.Text,
                                               lapMillisec.Text,
                                               noteToSave.Text);
                Commands.updateSession(activeUser.Connection, saveString);
                MessageBox.Show("Session Updated!");
                UserPage owner = this.Owner as UserPage;
                
                dt = new DataTable();
                dataAdapter.Fill(dt);
                Table.ItemsSource = dt.DefaultView;

                owner.updateTable();
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Check if all necessary info is filled");
            }

        }

        
    }
}
