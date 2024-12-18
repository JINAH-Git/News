//������ ��Ʈ��ũ ������ ��(Model)�� ���� ó���ϱ� ���� DTOŬ����(Data Transfer Object)
package news.dto;

import news.vo.*;

import java.util.ArrayList;

import news.dao.*;

public class NetworkgraphDTO extends DBManager
{
		//�� ��� ��Ʈ��ũ �׷��� ����ϱ� - R
		public ArrayList<NetworkgraphVO> GetNetworkgraph(String cdno)
		{
			ArrayList<NetworkgraphVO> list = new ArrayList<NetworkgraphVO>();
			NetworkgraphVO vo = null;
			this.DBOpen();
			String sql  = "";
			sql = "select noun1, noun2, nwgweight, cdno ";
			sql += "from networkgraph ";
			sql += "where rdrefine='2' and cdno='" + cdno + "' ";
			this.RunSelect(sql);
			System.out.print(sql);
			
			while(this.Next() == true)
			{
				vo = new NetworkgraphVO();
				vo.setNoun1(this.getValue("noun1"));
				vo.setNoun2(this.getValue("noun2"));
				vo.setNwgweight(this.getValue("nwgweight"));
				vo.setCdno(Integer.parseInt(this.getValue("cdno")));
				list.add(vo);
			}
			this.DBClose();
			return list;
		}
		
}
