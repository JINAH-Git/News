//��� ������ ��� ��縦 ������� VO(Value Object)Ŭ����
package news.vo;

public class NounmappingVO 
{
	int    cdno;		//��������ȣ
	String rdrefine;	//��������
	String nmnouns;		//���
	
	public int getCdno()	    {	return cdno;	 }
	public String getRdrefine() {	return rdrefine; }
	public String getNmnouns()  {	return nmnouns;	 }
	
	public void setCdno(int cdno)			 {	this.cdno = cdno;			}
	public void setRdrefine(String rdrefine) {	this.rdrefine = rdrefine;	}
	public void setNmnouns(String nmnouns) 	 {	this.nmnouns = nmnouns;		}
	
}
