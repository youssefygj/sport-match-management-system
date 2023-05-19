using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace project
{
    public partial class system_admin_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand addclub = new SqlCommand("addclub", conn);
            addclub.CommandType = CommandType.StoredProcedure;
            addclub.Parameters.Add(new SqlParameter("@Clubname", TextBox1.Text));
            addclub.Parameters.Add(new SqlParameter("@location", TextBox2.Text));
            conn.Open();
            bool flag = true;
            if (TextBox1.Text == "" || TextBox2.Text == "")
            {
                Label1.Text = "Please dont leave any entries empty";
            }
            else
            {
                try
                {
                    SqlDataReader viewUpcomingMatchesRdr = addclub.ExecuteReader();
                }
                catch
                {
                    Label1.Text = "club already exists";
                    flag = false;
                }
                if (flag)
                {
                    Label1.Text = "Successfully completed";
                }
            }
            conn.Close();
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand deleteclub = new SqlCommand("deleteclub", conn);
            SqlCommand check = new SqlCommand("exist", conn);
            check.CommandType = CommandType.StoredProcedure;

            deleteclub.CommandType = CommandType.StoredProcedure;
            check.Parameters.Add(new SqlParameter("@name", TextBox3.Text));
            SqlParameter flag = check.Parameters.Add(new SqlParameter("@flag", SqlDbType.Int));
            flag.Direction = ParameterDirection.Output;
            deleteclub.Parameters.Add(new SqlParameter("@clubName", TextBox3.Text));
            

            conn.Open();
            SqlDataReader viewUpcomingMatchesRdr = check.ExecuteReader();
            conn.Close();
            conn.Open();
            if (flag.Value.ToString() == "1")
            {
                SqlDataReader checke = deleteclub.ExecuteReader();
                Label2.Text = "Deleted successfully";
            }
            else
            {
                Label2.Text = "Please Write an existing club";
            }
               

            conn.Close();
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand addclub = new SqlCommand("addstadium", conn);
            addclub.CommandType = CommandType.StoredProcedure;
            addclub.Parameters.Add(new SqlParameter("@stadiumname", TextBox4.Text));
            addclub.Parameters.Add(new SqlParameter("@location", TextBox5.Text));
            addclub.Parameters.Add(new SqlParameter("@capacity", TextBox6.Text));
            conn.Open();
            bool flag = true;
            bool result =
            (TextBox6.Text).All(c => char.IsDigit(c));
            if (TextBox4.Text == "" || TextBox5.Text == "" || TextBox6.Text == "") {
                Label3.Text = "Please dont leave any entries empty";
            }
            else {
                if (result)
                {


                    try
                    {
                        SqlDataReader viewUpcomingMatchesRdr = addclub.ExecuteReader();
                    }
                    catch
                    {
                        Label3.Text = "stadium already exists";
                        flag = false;
                    }
                    if (flag)
                    {
                        Label3.Text = "Successfully completed";
                    }
                }
                else
                {
                    Label3.Text = "please enter capacity as a number";
                }
            }
            conn.Close();
        }

        protected void Button4_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand deleteclub = new SqlCommand("deletestadium", conn);
            SqlCommand check = new SqlCommand("checkstadium", conn);
            check.CommandType = CommandType.StoredProcedure;

            deleteclub.CommandType = CommandType.StoredProcedure;
            check.Parameters.Add(new SqlParameter("@name", TextBox7.Text));
            SqlParameter flag = check.Parameters.Add(new SqlParameter("@flag", SqlDbType.Int));
            flag.Direction = ParameterDirection.Output;
            deleteclub.Parameters.Add(new SqlParameter("@stadiumName", TextBox7.Text));


            conn.Open();
            SqlDataReader viewUpcomingMatchesRdr = check.ExecuteReader();
            conn.Close();
            conn.Open();
            if (flag.Value.ToString() == "1")
            {
                SqlDataReader checke = deleteclub.ExecuteReader();
                Label4.Text = "Deleted successfully";
            }
            else
            {
                Label4.Text = "Please Write an existing stadium";
            }


            conn.Close();
        }

        protected void Button5_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            
            SqlCommand check = new SqlCommand("checkfan", conn);
            check.CommandType = CommandType.StoredProcedure;

            
            check.Parameters.Add(new SqlParameter("@nationalid", TextBox8.Text));
            SqlParameter flag = check.Parameters.Add(new SqlParameter("@flag", SqlDbType.Int));
            flag.Direction = ParameterDirection.Output;

            bool result =
           (TextBox8.Text).All(c => char.IsDigit(c));

            conn.Open();
            SqlDataReader viewUpcomingMatchesRdr = check.ExecuteReader();
            conn.Close();
            conn.Open();
            SqlCommand deleteclub = new SqlCommand("blockfan", conn);
            deleteclub.CommandType = CommandType.StoredProcedure;
            deleteclub.Parameters.AddWithValue("@nationalid", TextBox8.Text);
            if (result)
            {

                if (flag.Value.ToString() == "1")
                {
                    SqlDataReader checke = deleteclub.ExecuteReader();
                    Label5.Text = "blocked successfully";
                }
                else
                {
                    Label5.Text = "Please Write an existing national id";
                }
            }
            else { Label5.Text = "please enter national id as a number"; }



            conn.Close();
        }
        static bool IsDigit(char c)
        {
            return c >= '0' && c <= '9';
        }
    }
}