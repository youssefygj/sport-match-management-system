using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.NetworkInformation;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class association_manager_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write(Session["user"]);

            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand viewUpcomingMatchesProc = new SqlCommand("viewUpcomingMatches", conn);
            viewUpcomingMatchesProc.CommandType = CommandType.StoredProcedure;

            SqlCommand viewAlreadyPlayedMatchesProc = new SqlCommand("viewAlreadyPlayedMatches", conn);
            viewAlreadyPlayedMatchesProc.CommandType = CommandType.StoredProcedure;

            SqlCommand clubsNeverScehduledToMatchProc = new SqlCommand("clubsNeverScehduledToMatchProc", conn);
            clubsNeverScehduledToMatchProc.CommandType = CommandType.StoredProcedure;

            conn.Open();

                SqlDataReader viewUpcomingMatchesRdr = viewUpcomingMatchesProc.ExecuteReader();
                GridView1.DataSource = viewUpcomingMatchesRdr;
                GridView1.DataBind();
                viewUpcomingMatchesRdr.Close();
                
                SqlDataReader viewAlreadyPlayedMatchesRdr = viewAlreadyPlayedMatchesProc.ExecuteReader();
                GridView2.DataSource = viewAlreadyPlayedMatchesRdr;
                GridView2.DataBind();
                viewAlreadyPlayedMatchesRdr.Close();
                
                SqlDataReader clubsNeverScehduledToMatchRdr = clubsNeverScehduledToMatchProc.ExecuteReader();
                GridView3.DataSource = clubsNeverScehduledToMatchRdr;
                GridView3.DataBind();
                clubsNeverScehduledToMatchRdr.Close();

            conn.Close();
            
            


            /*
            while (rdr.Read())
            {
                String host = rdr.GetString(rdr.GetOrdinal("host"));
                Label name = new Label();
                name.Text = host;
                form1.Controls.Add(name)
            }
            */


        }

        protected void addNewMatch(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            String host = hostClubName.Text;
            String guest = guestClubName.Text;
            String start = DateTime.Now.ToString(startTime.Text);
            start = start.Replace("T", " ");
            String end = DateTime.Now.ToString(endTime.Text);
            end = end.Replace("T", " ");





            conn.Open();
            SqlCommand addNewMatchProc = new SqlCommand("addNewMatchProc", conn);
            addNewMatchProc.CommandType = CommandType.StoredProcedure;
            addNewMatchProc.Parameters.AddWithValue("@HostClub", host);
            addNewMatchProc.Parameters.AddWithValue("@GuestClub", guest);
            addNewMatchProc.Parameters.AddWithValue("@startTime", start);
            addNewMatchProc.Parameters.AddWithValue("@EndTime", end);

            SqlParameter success = addNewMatchProc.Parameters.Add("@success", SqlDbType.Int);
            success.Direction = ParameterDirection.Output;
            SqlParameter error = addNewMatchProc.Parameters.Add("@error", SqlDbType.VarChar, 40);
            error.Direction = ParameterDirection.Output;
            addNewMatchProc.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString() == "1")
            {
                Response.Write("match added successfully");
            }
            else
            {
                Response.Write(error.Value.ToString());
            }
            SqlCommand viewUpcomingMatchesProc = new SqlCommand("viewUpcomingMatches", conn);
            viewUpcomingMatchesProc.CommandType = CommandType.StoredProcedure;

            SqlCommand viewAlreadyPlayedMatchesProc = new SqlCommand("viewAlreadyPlayedMatches", conn);
            viewAlreadyPlayedMatchesProc.CommandType = CommandType.StoredProcedure;

            SqlCommand clubsNeverScehduledToMatchProc = new SqlCommand("clubsNeverScehduledToMatchProc", conn);
            clubsNeverScehduledToMatchProc.CommandType = CommandType.StoredProcedure;

            conn.Open();

            SqlDataReader viewUpcomingMatchesRdr = viewUpcomingMatchesProc.ExecuteReader();
            GridView1.DataSource = viewUpcomingMatchesRdr;
            GridView1.DataBind();
            viewUpcomingMatchesRdr.Close();

            SqlDataReader viewAlreadyPlayedMatchesRdr = viewAlreadyPlayedMatchesProc.ExecuteReader();
            GridView2.DataSource = viewAlreadyPlayedMatchesRdr;
            GridView2.DataBind();
            viewAlreadyPlayedMatchesRdr.Close();

            SqlDataReader clubsNeverScehduledToMatchRdr = clubsNeverScehduledToMatchProc.ExecuteReader();
            GridView3.DataSource = clubsNeverScehduledToMatchRdr;
            GridView3.DataBind();
            clubsNeverScehduledToMatchRdr.Close();

            conn.Close();
        }

        protected void deleteMatch(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);

            String host = hostClubName2.Text;
            String guest = guestClubName2.Text;
            String start = DateTime.Now.ToString(startTime2.Text);
            start = start.Replace("T", " ");
            String end = DateTime.Now.ToString(endTime2.Text);
            end = end.Replace("T", " ");





            conn.Open();
            SqlCommand deleteMatchProc = new SqlCommand("deleteMatchProc", conn);
            deleteMatchProc.CommandType = CommandType.StoredProcedure;
            deleteMatchProc.Parameters.AddWithValue("@HostClub", host);
            deleteMatchProc.Parameters.AddWithValue("@GuestClub", guest);
            deleteMatchProc.Parameters.AddWithValue("@startTime", start);
            deleteMatchProc.Parameters.AddWithValue("@EndTime", end);

            SqlParameter success = deleteMatchProc.Parameters.Add("@success", SqlDbType.Int);
            success.Direction = ParameterDirection.Output;
            SqlParameter error = deleteMatchProc.Parameters.Add("@error", SqlDbType.VarChar, 40);
            error.Direction = ParameterDirection.Output;
            deleteMatchProc.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString() == "1")
            {
                Response.Write("match deleted successfully");
            }
            else
            {
                Response.Write(error.Value.ToString());
            }

            SqlCommand viewUpcomingMatchesProc = new SqlCommand("viewUpcomingMatches", conn);
            viewUpcomingMatchesProc.CommandType = CommandType.StoredProcedure;

            SqlCommand viewAlreadyPlayedMatchesProc = new SqlCommand("viewAlreadyPlayedMatches", conn);
            viewAlreadyPlayedMatchesProc.CommandType = CommandType.StoredProcedure;

            SqlCommand clubsNeverScehduledToMatchProc = new SqlCommand("clubsNeverScehduledToMatchProc", conn);
            clubsNeverScehduledToMatchProc.CommandType = CommandType.StoredProcedure;

            conn.Open();

            SqlDataReader viewUpcomingMatchesRdr = viewUpcomingMatchesProc.ExecuteReader();
            GridView1.DataSource = viewUpcomingMatchesRdr;
            GridView1.DataBind();
            viewUpcomingMatchesRdr.Close();

            SqlDataReader viewAlreadyPlayedMatchesRdr = viewAlreadyPlayedMatchesProc.ExecuteReader();
            GridView2.DataSource = viewAlreadyPlayedMatchesRdr;
            GridView2.DataBind();
            viewAlreadyPlayedMatchesRdr.Close();

            SqlDataReader clubsNeverScehduledToMatchRdr = clubsNeverScehduledToMatchProc.ExecuteReader();
            GridView3.DataSource = clubsNeverScehduledToMatchRdr;
            GridView3.DataBind();
            clubsNeverScehduledToMatchRdr.Close();

            conn.Close();
        }
    }
}