# App Store Encryption Compliance - Quick Reference

## For Apple App Store Submission

### Encryption Question: "Does your app use encryption?"
**Answer: YES**

### Follow-up: "Is it exempt encryption?"
**Answer: YES - Exempt encryption only**

### Info.plist Setting
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```
✅ **Already configured correctly** in `ios/Runner/Info.plist` (line 33-34)

---

## Quick Explanation for App Review

If Apple asks for clarification, use this:

> **diVine uses only standard, exempt encryption:**
>
> 1. **HTTPS/TLS** for secure network communications (exempt)
> 2. **Standard cryptographic algorithms** for user authentication and optional private messages:
>    - secp256k1 elliptic curve (SECG standard)
>    - ChaCha20-Poly1305 (IETF RFC 8439)
>    - AES-256 (NIST FIPS 197)
>    - RSA-2048 (RFC 8017)
> 3. **iOS Keychain** for secure key storage (OS-provided, exempt)
>
> All algorithms are publicly documented standards from IETF, NIST, and SECG. No proprietary or custom encryption is used.

---

## Encryption Algorithms Summary

| Use Case | Algorithm | Standard | Classification |
|----------|-----------|----------|----------------|
| Network (HTTPS) | TLS 1.2/1.3 | IETF RFC | Exempt |
| User Keys | secp256k1 | SECG SEC2 | Standard |
| Private Messages | ChaCha20-Poly1305 | IETF RFC 8439 | Standard |
| Legacy Messages | AES-256-CBC | NIST FIPS 197 | Standard |
| Signatures | RSA-2048 | RFC 8017 | Standard |
| Key Storage | iOS Keychain | Apple OS | Exempt |

---

## TestFlight / App Store Connect

When uploading to TestFlight or App Store Connect, you may see:

**"Missing Compliance"** warning

**Action**: Click "Provide Export Compliance Information"

**Questions and Answers**:

1. **Does your app use encryption?**
   → **YES**

2. **Is your app subject to U.S. Export Administration Regulations (EAR)?**
   → **YES** (if you're a U.S. developer)

3. **Does your app contain, use, or access encryption, and is it exempt under Category 5, Part 2?**
   → **YES - It qualifies for exemption**

4. **Does your app use encryption only for:**
   - Authentication
   - Digital signatures
   - Decryption of encrypted data
   - Or encryption only for data protection at rest?

   → **YES**

5. **Does your app implement any proprietary or non-standard encryption algorithms?**
   → **NO**

**Result**: App should be classified as using **exempt encryption** and not require additional export documentation.

---

## France-Specific Compliance

### Does France require special approval?
**Generally NO** - France follows EU regulations which exempt standard cryptography.

### If French authorities request documentation:
Provide: `/mobile/docs/ENCRYPTION_EXPORT_COMPLIANCE.md` (comprehensive technical documentation)

### Contact for French compliance:
**ANSSI** (Agence nationale de la sécurité des systèmes d'information)
Website: https://www.ssi.gouv.fr/

---

## Common Issues

### "Your app uses encryption but doesn't have export compliance documentation"
**Solution**: The Info.plist setting `ITSAppUsesNonExemptEncryption = false` IS the documentation for exempt encryption.

### "Please provide your CCATS number"
**Response**: Not applicable - app uses only exempt encryption under Category 5 Part 2.

### "Annual self-classification report required"
**When**: Only if you're a U.S. entity exporting encryption products
**Where**: BIS SNAP-R system (https://snapr.bis.doc.gov/)
**Deadline**: February 1st for previous calendar year
**Note**: Consult export compliance attorney if unsure

---

## Key Points to Remember

✅ **App uses encryption** (don't say "no" to encryption questions)
✅ **All encryption is standard/exempt** (HTTPS, secp256k1, ChaCha20, AES, RSA)
✅ **No proprietary encryption** (all algorithms are IETF/NIST/SECG standards)
✅ **Info.plist correctly configured** (`ITSAppUsesNonExemptEncryption = false`)
✅ **Full documentation available** (`ENCRYPTION_EXPORT_COMPLIANCE.md`)

---

## Files for Reference

| File | Purpose |
|------|---------|
| `ios/Runner/Info.plist` | Contains encryption declaration (line 33-34) |
| `docs/ENCRYPTION_EXPORT_COMPLIANCE.md` | Comprehensive technical documentation |
| `docs/APP_STORE_ENCRYPTION_SUMMARY.md` | This quick reference |

---

## Need Help?

1. **During submission**: Reference this document and `ENCRYPTION_EXPORT_COMPLIANCE.md`
2. **Apple rejection**: Provide `ENCRYPTION_EXPORT_COMPLIANCE.md` to App Review
3. **Export compliance**: Consult an export control attorney
4. **French authorities**: Contact ANSSI or legal counsel

---

**Last Updated**: November 12, 2025
**App Version**: 0.0.1+79
**Status**: ✅ Compliant - Exempt encryption only
