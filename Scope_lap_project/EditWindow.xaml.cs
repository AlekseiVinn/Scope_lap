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
    public partial class EditWindow : Window
    {
        NpgsqlDataAdapter dataAdapter;
        User activeUser;
        SessionString saveString;


        public EditWindow()
        { InitializeComponent(); }

        public EditWindow(User ownerUser)
        {
            this.activeUser = ownerUser;
            InitializeComponent();

            dataAdapter = new NpgsqlDataAdapter(@"SELECT *	FROM public.get_length;", activeUser.Connection);
            DataTable dt = new DataTable();
            dataAdapter.Fill(dt);
            lapConf.ItemsSource= dt.DefaultView;
            lapConf.DisplayMemberPath = "conf";
            lapConf.SelectedValuePath = "conf_id";

            NpgsqlDataAdapter dataAdapter2 = new NpgsqlDataAdapter(@"SELECT *	FROM public.all_cars;", activeUser.Connection);
            DataTable dt2 = new DataTable();
            dataAdapter2.Fill(dt2);
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
                saveString = new SessionString(lapConf.SelectedValue.ToString(),
                                               carList.SelectedValue.ToString(),
                                               activeUser.ID,
                                               datePick.SelectedDate.Value.ToShortDateString(),
                                               lapMin.Text,
                                               lapSec.Text,
                                               lapMillisec.Text);
                Commands.createSession(activeUser.Connection, saveString);
                MessageBox.Show("New session created!");
                UserPage owner = this.Owner as UserPage;
                owner.updateTable();
                this.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Check if all necessary info is filled");
                return;
            }
            
        }
    }
}
