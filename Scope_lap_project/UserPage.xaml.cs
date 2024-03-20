using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Text;
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
    /// Interaction logic for UserPage.xaml
    /// </summary>
    public partial class UserPage : Window
    {
        OnEditWindow editWindow;
        EditWindow insertWindow;

        NpgsqlDataAdapter dataAdapter;
        DataSet ds;
        DataTable dt;
        User activeUser;
        string ID;
        

        public UserPage()
        { InitializeComponent(); }

        public UserPage(User user)
        {
            InitializeComponent();

            this.activeUser = user;

            dataAdapter = Commands.InitialConn(activeUser.Connection);
            
            dt = new DataTable("view");
            ds = new DataSet();
            //ds.Tables.Add(dt);
            
            dataAdapter.Fill(dt);
            Table.ItemsSource = dt.DefaultView;

            UserHeader.Content = Commands.GetDriverName(activeUser.Connection, activeUser.UserName);
        }

        private void Window_Closing_1(object sender, System.ComponentModel.CancelEventArgs e)
        {
            activeUser.Connection.Close();
            this.Owner.Close();
        }

        private void top100_Click(object sender, RoutedEventArgs e)
        {
            Table.ItemsSource = null;
            Table.Items.Refresh();
            dt = new DataTable();
            
            NpgsqlDataReader data = Commands.getTop100(activeUser.Connection);
            dt.Load(data);
            Table.ItemsSource = dt.DefaultView;
        }

        private void newBtn_Click(object sender, RoutedEventArgs e)
        {
            insertWindow = new EditWindow(activeUser);
            insertWindow.Owner = this;
            //insertWindow.DataContext = this;
            insertWindow.Show();
        }

        private void Table_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (Table.SelectedValue.ToString() != null)
                {
                    //selectedItem.Content = Table.SelectedValue.ToString();
                    ID = Table.SelectedValue.ToString();
                }
                else
                {
                    //selectedItem.Content = "";
                    ID = null;
                }
            }
            catch(System.NullReferenceException)
            {
            
            }
        }

        private void delDtn_Click(object sender, RoutedEventArgs e)
        {
            if (ID == null)
            {
                MessageBox.Show("Choose session to delete");
            }
            else if (Commands.getDriverID(activeUser.Connection, ID) != activeUser.ID)
            {
                MessageBox.Show("Deleting other drivers sessions not allowed");
            }
            else
            {
                MessageBox.Show("You have deleted a track session", "Session deleted.", MessageBoxButton.OK, MessageBoxImage.Exclamation);
                Commands.deleteSession(activeUser.Connection, ID);

                Table.ItemsSource = null;
                Table.Items.Refresh();
                dt = new DataTable();

                NpgsqlDataReader data = Commands.getTop100(activeUser.Connection);
                dt.Load(data);
                Table.ItemsSource = dt.DefaultView;
            }

        }

        private void yourBtn_Click(object sender, RoutedEventArgs e)
        {
            Table.ItemsSource = null;
            Table.Items.Refresh();
            dt = new DataTable();

            NpgsqlDataReader data = Commands.yourSessions(activeUser.Connection);
            dt.Load(data);
            Table.ItemsSource = dt.DefaultView;
        }

        private void editBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (Commands.getDriverID(activeUser.Connection, ID) != activeUser.ID)
                {
                    MessageBox.Show("Editing other drivers sessions not allowed");
                }
                editWindow = new OnEditWindow(activeUser, ID);
                editWindow.Owner = this;
                editWindow.Show();
            } catch 
            {
                MessageBox.Show("No session selected");
                return;
            }
        }

        public void updateTable()
        {
            Table.ItemsSource = null;
            Table.Items.Refresh();
            dt = new DataTable();

            NpgsqlDataReader data = Commands.yourSessions(activeUser.Connection);
            dt.Load(data);
            Table.ItemsSource = dt.DefaultView;

        }

        private void alsess_Click(object sender, RoutedEventArgs e)
        {
            Table.ItemsSource = null;
            Table.Items.Refresh();
            dt = new DataTable();

            NpgsqlDataReader data = Commands.getAllSession(activeUser.Connection);
            dt.Load(data);
            Table.ItemsSource = dt.DefaultView;
        }

    }
}
