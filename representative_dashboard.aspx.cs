using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace project
{
    public partial class representative_dashboard : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand info = new SqlCommand("info", conn);
            info.CommandType = CommandType.StoredProcedure;
            info.Parameters.Add(new SqlParameter("@username", Session["user"]));
            conn.Open();
            SqlDataReader viewUpcomingMatchesRdr = info.ExecuteReader();

            GridView1.DataSource = viewUpcomingMatchesRdr;
            GridView1.DataBind();

            conn.Close();


            //create a new connection


            SqlCommand upcomingMatchesOfClub = new SqlCommand("upcomingMatch", conn);
            upcomingMatchesOfClub.Parameters.Add(new SqlParameter("@username", Session["user"]));
            upcomingMatchesOfClub.CommandType = CommandType.StoredProcedure;

            conn.Open();
            SqlDataReader viewUpcomingMatchesRd = upcomingMatchesOfClub.ExecuteReader();

            GridView2.DataSource = viewUpcomingMatchesRd;
            GridView2.DataBind();


            conn.Close();
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);
            String date1 = DateTime.Now.ToString(TextBox1.Text);
            SqlCommand availableafter = new SqlCommand("availableafter", conn);
            availableafter.Parameters.Add(new SqlParameter("@date", date1));
            availableafter.CommandType = CommandType.StoredProcedure;

            conn.Open();
            SqlDataReader viewUpcomingMatchesRdr = availableafter.ExecuteReader();

            GridView3.DataSource = viewUpcomingMatchesRdr;
            GridView3.DataBind();


            conn.Close();
        }

        protected void GridView3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);
            string date1 = DateTime.Now.ToString(TextBox3.Text);
            date1 = date1.Replace("T", " ");
            SqlCommand Req = new SqlCommand("Req", conn);
            Req.Parameters.Add(new SqlParameter("@username", Session["user"]));
            Req.Parameters.Add(new SqlParameter("@stadiumName", TextBox2.Text));
            Req.Parameters.Add(new SqlParameter("@date", date1));

            SqlParameter flag = Req.Parameters.Add(new SqlParameter("@flag", SqlDbType.Int));

            SqlParameter flag1 = Req.Parameters.Add(new SqlParameter("@flag1", SqlDbType.Int));

            flag.Direction = ParameterDirection.Output;

            flag1.Direction = ParameterDirection.Output;

            Req.CommandType = CommandType.StoredProcedure;
            bool check = true;
            conn.Open();
            SqlDataReader viewUpcomingMatchesRdr = null;
            try
            {
                viewUpcomingMatchesRdr = Req.ExecuteReader();
            }
            catch
            {
                Label1.Text = "Request already sent";
                check = false;
            }
            conn.Close();
            conn.Open();
            if (check)
            {

                if (flag.Value.ToString() == "1" && flag1.Value.ToString() == "1")
                {

                    Label1.Text = "Operation completed";
                }

                else

                {
                    if (flag.Value.ToString() == "1")
                    {
                        Label1.Text = "Stadium does not exist";

                    }
                    else if ((flag1.Value.ToString() == "1"))
                    {

                        Label1.Text = "Match does not exist at the given date";
                    }
                    else
                    {
                        Label1.Text = "Stadium does not exist and Match does not exist at the given date ";
                    }

                }
            }
            conn.Close();
        }
    }
}