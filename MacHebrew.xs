#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "fmmache.h"
#include "tomache.h"

#define PkgName "Lingua::HE::MacHebrew"

/* Perl 5.6.1 ? */
#ifndef uvuni_to_utf8
#define uvuni_to_utf8   uv_to_utf8
#endif /* uvuni_to_utf8 */

/* Perl 5.6.1 ? */
#ifndef utf8n_to_uvuni
#define utf8n_to_uvuni  utf8_to_uv
#endif /* utf8n_to_uvuni */

#define SBCS_LEN	1

#define MAC_HE_DIR_NT	0
#define MAC_HE_DIR_LR	1
#define MAC_HE_DIR_RL	2

#define MAC_HE_UV_PDF	0x202C
#define MAC_HE_UV_LRO	0x202D
#define MAC_HE_UV_RLO	0x202E

static U8 ** mac_he_table [] = {
    to_mac_he_N,
    to_mac_he_L,
    to_mac_he_R
};

MODULE = Lingua::HE::MacHebrew	PACKAGE = Lingua::HE::MacHebrew

void
decode(src)
    SV* src
  PROTOTYPE: $
  ALIAS:
    decodeMacHebrew = 1
  PREINIT:
    SV *dst;
    STRLEN srclen;
    U8 *s, *e, *p, uni[UTF8_MAXLEN + 1];
    UV uv;
    STDCHAR curdir, predir;
    struct mac_he_string heexp;
  PPCODE:
    if (SvUTF8(src)) {
	src = sv_mortalcopy(src);
	sv_utf8_downgrade(src, 0);
    }
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dst = sv_2mortal(newSV(1));
    (void)SvPOK_only(dst);
    SvUTF8_on(dst);

    predir = MAC_HE_DIR_NT;
    for (p = s; p < e; p++, predir = curdir) {
	curdir = fm_mac_he_dir[*p];

	if (predir != curdir) {
	    if (predir != MAC_HE_DIR_NT) {
		uv = MAC_HE_UV_PDF;
		(void)uvuni_to_utf8(uni, uv);
		sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
	    }
	    if (curdir != MAC_HE_DIR_NT) {
		uv = (curdir == MAC_HE_DIR_LR) ? MAC_HE_UV_LRO :
		     (curdir == MAC_HE_DIR_RL) ? MAC_HE_UV_RLO :
		     0; /* Panic: undefined direction in decode" */;
		(void)uvuni_to_utf8(uni, uv);
		sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
	    }
	}

	heexp = fm_mac_he_tbl[*p];
	if (heexp.string) {
	    sv_catpvn(dst, (char*)heexp.string, (STRLEN)heexp.uv);
	}
	else {
	    uv = heexp.uv;
	    (void)uvuni_to_utf8(uni, uv);
	    sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
	}
    }

    if (predir != MAC_HE_DIR_NT) {
	uv = MAC_HE_UV_PDF;
	(void)uvuni_to_utf8(uni, uv);
	sv_catpvn(dst, (char*)uni, (STRLEN)UNISKIP(uv));
    }
    XPUSHs(dst);



void
encode(arg1, arg2 = 0)
    SV* arg1
    SV* arg2
  PROTOTYPE: $;$
  ALIAS:
    encodeMacHebrew = 1
  PREINIT:
    SV *src, *dst, *ref;
    STRLEN srclen, retlen;
    U8 *s, *e, *p;
    U8 b, *t, **table;
    struct mac_he_contr *cellist, **rowlist;
    UV uv;
    STDCHAR dir;
    bool cv = 0;
    bool pv = 0;
  PPCODE:
    src = arg1;
    if (items == 2) {
	if (SvROK(arg1)) {
	    ref = SvRV(arg1);
	    if (SvTYPE(ref) == SVt_PVCV)
		cv = TRUE;
	    else if (SvPOK(ref))
		pv = TRUE;
	    else
		croak(PkgName " 1st argument is not STRING nor CODEREF");
	}
	src = arg2;
    }

    if (!SvUTF8(src)) {
	src = sv_mortalcopy(src);
	sv_utf8_upgrade(src);
    }
    s = (U8*)SvPV(src,srclen);
    e = s + srclen;
    dst = sv_2mortal(newSV(1));
    (void)SvPOK_only(dst);
    SvUTF8_off(dst);

    dir = MAC_HE_DIR_NT;

    for (p = s; p < e;) {
	uv = utf8n_to_uvuni(p, e - p, &retlen, 0);
	p += retlen;

	switch (uv) {
	case MAC_HE_UV_PDF:
	    dir = MAC_HE_DIR_NT;
	    break;
	case MAC_HE_UV_LRO:
	    dir = MAC_HE_DIR_LR;
	    break;
	case MAC_HE_UV_RLO:
	    dir = MAC_HE_DIR_RL;
	    break;
	default:
	    rowlist = uv < 0x10000 ? to_mac_he_C[uv >> 8] : NULL;
	    cellist = rowlist ? rowlist[uv & 0xff] : NULL;

	    if (cellist) {
		bool cfound = FALSE;
		for (; cellist->len; cellist++) {
		    if (e < p + cellist->len ||
			    memNE(p, cellist->string, cellist->len)) {
			continue;
		    }
		    p += cellist->len;
		    b = cellist->byte;
		    sv_catpvn(dst, (char*)&b, SBCS_LEN);
		    cfound = TRUE;
		    break;
		}
		if (cfound)
		    break;
	    }
	    table = mac_he_table[dir];
	    t = uv < 0x10000 ? table[uv >> 8] : NULL;
	    b = t ? t[uv & 0xff] : 0;

	    if (b || uv == 0) {
		sv_catpvn(dst, (char*)&b, SBCS_LEN);
	    }
	    else if (pv) {
		sv_catsv(dst, ref);
	    }
	    else if (cv) {
		dSP;
		int count;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		XPUSHs(sv_2mortal(newSVuv(uv)));
		PUTBACK;
		count = call_sv(ref, G_SCALAR);
		SPAGAIN;
		if (count != 1)
		    croak("Panic in XS, " PkgName "\n");
		sv_catsv(dst,POPs);
		PUTBACK;
		FREETMPS;
		LEAVE;
	    }
	}
    }
    XPUSHs(dst);

