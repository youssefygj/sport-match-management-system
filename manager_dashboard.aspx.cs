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
    public partial class manager_dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String user = Session["user"].ToString();
            string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand viewMyStadium = new SqlCommand("viewMyStadium", conn);
            viewMyStadium.CommandType = CommandType.StoredProcedure;
            viewMyStadium.Parameters.Add(new SqlParameter("@username", user));

            SqlCommand ReceivedReq = new SqlCommand("ReceivedReq", conn);
            ReceivedReq.CommandType = CommandType.StoredProcedure;
            ReceivedReq.Parameters.Add(new SqlParameter("@username", user));
            conn.Open();
            SqlDataReader viewMyStadiumRdr = viewMyStadium.ExecuteReader();

            GridView1.DataSource = viewMyStadiumRdr;
            GridView1.DataBind();
            viewMyStadiumRdr.Close();

            SqlDataReader ReceivedReqRdr = ReceivedReq.ExecuteReader();

            GridView2.DataSource = ReceivedReqRdr;
            GridView2.DataBind();

            conn.Close();
        }

        protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "accept")
            {
                String user = Session["user"].ToString();
                string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                SqlCommand ReceivedReq = new SqlCommand("ReceivedReq", conn);
                ReceivedReq.CommandType = CommandType.StoredProcedure;
                ReceivedReq.Parameters.Add(new SqlParameter("@username", user));

                conn.Open();
                SqlDataReader ReceivedReqRdr = ReceivedReq.ExecuteReader();
                GridView2.DataSource = ReceivedReqRdr;
                GridView2.DataBind();
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow selectedRow = GridView2.Rows[index];
                TableCell HName = selectedRow.Cells[3];
                String Hostname = HName.Text;
                TableCell GName = selectedRow.Cells[4];
                String Guestname = GName.Text;
                TableCell Da = selectedRow.Cells[5];
                String date = Da.Text;

                ReceivedReqRdr.Close();
                TableCell state = selectedRow.Cells[7];
                if (state.Text == "unhandled")
                {
                    SqlCommand acceptRequest = new SqlCommand("acceptRequest", conn);
                    acceptRequest.CommandType = CommandType.StoredProcedure;
                    acceptRequest.Parameters.AddWithValue("@username", user);
                    acceptRequest.Parameters.AddWithValue("@HostClub", Hostname);
                    acceptRequest.Parameters.AddWithValue("@GuestClub", Guestname);
                    acceptRequest.Parameters.AddWithValue("@datetime", date);
                    acceptRequest.ExecuteNonQuery();
                    SqlDataReader ReceivedReqRdr2 = ReceivedReq.ExecuteReader();
                    GridView2.DataSource = ReceivedReqRdr2;
                    GridView2.DataBind();
                    ReceivedReqRdr2.Close();
                    Response.Write("Response Accepted Succesfully");
                }
                else
                {
                    if (state.Text == "accepted")
                        Response.Write("you can't accept an already accepted request");
                    else
                        Response.Write("you can't accept an already rejected request");
                }
                conn.Close();
            }
            if (e.CommandName == "reject")
            {
                String user = Session["user"].ToString();
                string connStr = WebConfigurationManager.ConnectionStrings["project"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                SqlCommand ReceivedReq = new SqlCommand("ReceivedReq", conn);
                ReceivedReq.CommandType = CommandType.StoredProcedure;
                ReceivedReq.Parameters.Add(new SqlParameter("@username", user));

                conn.Open();
                SqlDataReader ReceivedReqRdr = ReceivedReq.ExecuteReader();
                GridView2.DataSource = ReceivedReqRdr;
                GridView2.DataBind();
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow selectedRow = GridView2.Rows[index];
                TableCell HName = selectedRow.Cells[3];
                String Hostname = HName.Text;
                TableCell GName = selectedRow.Cells[4];
                String Guestname = GName.Text;
                TableCell Da = selectedRow.Cells[5];
                String date = Da.Text;
                ReceivedReqRdr.Close();
                TableCell state = selectedRow.Cells[7];
                if (state.Text == "unhandled")
                {
                    SqlCommand rejectRequest = new SqlCommand("rejectRequest", conn);
                    rejectRequest.CommandType = CommandType.StoredProcedure;
                    rejectRequest.Parameters.AddWithValue("@username", user);
                    rejectRequest.Parameters.AddWithValue("@HostName", Hostname);
                    rejectRequest.Parameters.AddWithValue("@GuestName", Guestname);
                    rejectRequest.Parameters.AddWithValue("@startTime", date);
                    rejectRequest.ExecuteNonQuery();
                    SqlDataReader ReceivedReqRdr2 = ReceivedReq.ExecuteReader();
                    GridView2.DataSource = ReceivedReqRdr2;
                    GridView2.DataBind();
                    ReceivedReqRdr2.Close();
                    Response.Write("Response Rejected Succesfully");
                }
                else
                {
                    if (state.Text == "accepted")
                        Response.Write("you can't reject an already accepted request");
                    else
                        Response.Write("you can't reject an already rejected request");
                }
                conn.Close();
            }
        }
    }
}