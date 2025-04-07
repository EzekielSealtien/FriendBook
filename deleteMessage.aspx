using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_part1
{
    public partial class deleteMessage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // recuperer le messageID envoye a partir de acceuil
            Int32 id = Convert.ToInt32(Request.QueryString["refMsg"].ToString());

            SqlConnection myCon = new SqlConnection("Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True");
            myCon.Open();
            string sql = "DELETE FROM Messages WHERE RefMessage =" + id;
            SqlCommand myCmd = new SqlCommand(sql, myCon);
            myCmd.ExecuteNonQuery();

            myCon.Close();
            Response.Redirect("Accueil.aspx");
        }
    }
}