using System;
using System.Data.SqlClient;
using System.Data.SqlTypes;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static int GetItem(SqlInt32 min)
    {
        int rows;
        SqlConnection conn = new SqlConnection("Context Connection=true");
        conn.Open();

        SqlCommand sqlCmd = conn.CreateCommand();

        sqlCmd.CommandText = @"select [4] from STORAGE pivot(SUM(COUNTITEMS) FOR Item IN([4])) pvt where [4] > @min";
        sqlCmd.Parameters.AddWithValue("@min", min);
        rows = (int)sqlCmd.ExecuteScalar();
        conn.Close();

        return rows;
    }
}