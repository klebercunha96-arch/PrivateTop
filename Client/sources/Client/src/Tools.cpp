#include "StdAfx.h"
#include "Tools.h"
#include <strstream> 

using namespace std;

string ConvertNumToChinese( int num )
{
	if( num==0 ) return g_oLangRec.GetString(421);

	char szNum[255] = { 0 };
	itoa( num, szNum, 10 );

	char szBuf[255] = { 0 };
    std::ostrstream str( szBuf, sizeof(szBuf) );

	const char* pszPos = szNum;
	if( *pszPos=='-' )
	{
		str << g_oLangRec.GetString(422);
		pszPos++;
	}


	static char szChinese[10][16];
	strncpy(szChinese[0], g_oLangRec.GetString(421), 15); szChinese[0][15] = '\0';
	strncpy(szChinese[1], g_oLangRec.GetString(423), 15); szChinese[1][15] = '\0';
	strncpy(szChinese[2], g_oLangRec.GetString(424), 15); szChinese[2][15] = '\0';
	strncpy(szChinese[3], g_oLangRec.GetString(425), 15); szChinese[3][15] = '\0';
	strncpy(szChinese[4], g_oLangRec.GetString(426), 15); szChinese[4][15] = '\0';
	strncpy(szChinese[5], g_oLangRec.GetString(427), 15); szChinese[5][15] = '\0';
	strncpy(szChinese[6], g_oLangRec.GetString(428), 15); szChinese[6][15] = '\0';
	strncpy(szChinese[7], g_oLangRec.GetString(429), 15); szChinese[7][15] = '\0';
	strncpy(szChinese[8], g_oLangRec.GetString(430), 15); szChinese[8][15] = '\0';
	strncpy(szChinese[9], g_oLangRec.GetString(431), 15); szChinese[9][15] = '\0';

	static char szHigh[8][16];
	strncpy(szHigh[0], g_oLangRec.GetString(432), 15); szHigh[0][15] = '\0';
	strncpy(szHigh[1], g_oLangRec.GetString(433), 15); szHigh[1][15] = '\0';
	strncpy(szHigh[2], g_oLangRec.GetString(434), 15); szHigh[2][15] = '\0';
	strncpy(szHigh[3], g_oLangRec.GetString(435), 15); szHigh[3][15] = '\0';
	strncpy(szHigh[4], g_oLangRec.GetString(432), 15); szHigh[4][15] = '\0';
	strncpy(szHigh[5], g_oLangRec.GetString(433), 15); szHigh[5][15] = '\0';
	strncpy(szHigh[6], g_oLangRec.GetString(434), 15); szHigh[6][15] = '\0';
	strncpy(szHigh[7], g_oLangRec.GetString(436), 15); szHigh[7][15] = '\0';
	
	char nChar = 0;
	int nZeroNum = 0;				
	bool IsBigMark = false;		// �������ڵ����⴦������ȫ����ʱ
	int nHigh = 0;
	int nLen = 0;
	while( *pszPos )
	{
		nChar = *pszPos++;
		nLen = (int)strlen(pszPos);

		// �в��Ķ����ϲ�Ϊһ����,��β������Ҳ����ʾ
		if( nChar=='0' )
		{
			nZeroNum++;
			if( IsBigMark && (nLen==4 || nLen==8) )
			{
				str << szHigh[ nLen-1 ];
				IsBigMark = false;
			}
			continue;
		}
		else
		{
			IsBigMark = true;
			if( nZeroNum>0 )    // ���㿪ʼ��,�����ĵ�һ������
			{
				nZeroNum = 0;
				str << g_oLangRec.GetString(421);
			}
			str << szChinese[ nChar - '0' ];
			if( nLen > 0 )
			{
				if( nLen < 9 )
				{
					nHigh = nLen-1;
				}
				else
				{
					nLen = nLen % 9;
					nHigh = nLen;
				}
				str << szHigh[nHigh];

				// ���ڵ����⴦��
				if( nHigh==3 || nHigh==7 )
				{
					IsBigMark = false;
				}
			}
		}
	}
    str << ends;

	// ͷΪһʮ,ʡ��һ
	string rv = str.str();
	if( rv.length()>=4 && rv.substr( 0, 4 ) == g_oLangRec.GetString(437) )
		return rv.substr( 2, rv.length() );

	return rv;
}
