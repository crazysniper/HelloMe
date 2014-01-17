package cn.com.liandisys.hellome.dbconnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnectionManager {
	private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	private static final String URL = "jdbc:sqlserver://sf2011-db;DatabaseName=HelloMe;";
	private static final String USER = "hellome";
	private static final String PASSWORD = "Sun.Japan";	
		
	public static Connection getConnection() {
		try {
			Class.forName(DRIVER);
			return DriverManager.getConnection(URL, USER, PASSWORD);
		} catch (ClassNotFoundException cnf) {
			cnf.printStackTrace();
			return null;
		} catch (SQLException sql) {
			sql.printStackTrace();
			return null;
		}
	}
	
	public static void closeConnection(ResultSet rs, Statement statement, Connection con) {
		try {
			if (null != rs) {
				rs.close();
			}
		} catch (SQLException sql) {
			sql.printStackTrace();
		} finally {
			try {
				if (null != statement) {
					statement.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (null != con) {
						con.close();
					}
				} catch (SQLException sql) {
					sql.printStackTrace();
				}
			}
		}
	}
	
//	public static void closeConnection(Connection con) {
//		try {
//			if (null != con) {
//				con.close();
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//	}
//	
//	public static void closeResultSet(ResultSet rs) {
//		try {
//			if (null != rs) {
//				rs.close();
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//	}
//	
//	public static void closeStatement(Statement statement) {
//		try {
//			if (null != statement) {
//				statement.close();
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//	}
}
