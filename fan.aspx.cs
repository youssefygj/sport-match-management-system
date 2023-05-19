using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class fan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ViewMatches(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            String date = DateTime.Now.ToString(date1.Text);
            SqlCommand viewAvailableMatchesProc = new SqlCommand("viewAvailableMatches", conn);
            viewAvailableMatchesProc.CommandType = CommandType.StoredProcedure;
            viewAvailableMatchesProc.Parameters.Add(new SqlParameter("@date", date));

            conn.Open();
            SqlDataReader viewAvailableMatchesRdr = viewAvailableMatchesProc.ExecuteReader();

            GridView1.DataSource = viewAvailableMatchesRdr;
            GridView1.DataBind();

            conn.Close();
        }

        protected void Purchase(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            string host = hostreg.Text;
            string guest = guestreg.Text;
            string date = DateTime.Now.ToString(datereg.Text);
            date = date.Replace("T", " ");
            if (host == "" || guest == "" || date == "")
                Response.Write("invalid inputs");
            else
            {
                conn.Open();
                SqlCommand purchaseTicketProc = new SqlCommand("purchaseTicketProc", conn);
                purchaseTicketProc.CommandType = CommandType.StoredProcedure;
                purchaseTicketProc.Parameters.AddWithValue("@username", Session["user"]);
                purchaseTicketProc.Parameters.AddWithValue("@HostClub", host);
                purchaseTicketProc.Parameters.AddWithValue("@GuestClub", guest);
                purchaseTicketProc.Parameters.AddWithValue("@date", date);
                SqlParameter flag = purchaseTicketProc.Parameters.Add("@flag", SqlDbType.VarChar, 100);
                flag.Direction = ParameterDirection.Output;
                purchaseTicketProc.ExecuteNonQuery();
                Response.Write(flag.Value.ToString());
                conn.Close();

                String dateMatches = DateTime.Now.ToString(date1.Text);
                SqlCommand viewAvailableMatchesProc = new SqlCommand("viewAvailableMatches", conn);
                viewAvailableMatchesProc.CommandType = CommandType.StoredProcedure;
                viewAvailableMatchesProc.Parameters.Add(new SqlParameter("@date", dateMatches));

                conn.Open();
                SqlDataReader viewAvailableMatchesRdr = viewAvailableMatchesProc.ExecuteReader();

                GridView1.DataSource = viewAvailableMatchesRdr;
                GridView1.DataBind();

                conn.Close();
            
            }
        }

    }
}