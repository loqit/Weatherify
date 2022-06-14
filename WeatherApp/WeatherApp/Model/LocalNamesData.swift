import Foundation

struct LocalNamesData: Codable {
    let af, ar: String?
    let ascii: String
    let az, bg, ca, da: String?
    let de, el: String?
    let en: String
    let eu, fa: String?
    let featureName: String
    let fi, fr, gl, he: String?
    let hi, hr, hu, id: String?
    let it, ja, la, lt: String?
    let mk, nl, no, pl: String?
    let pt, ro, ru, sk: String?
    let sl, sr, th, tr: String?
    let vi, zu: String?

    enum CodingKeys: String, CodingKey {
        case af, ar, ascii, az, bg, ca, da, de, el, en, eu, fa
        case featureName = "feature_name"
        case fi, fr, gl, he, hi, hr, hu, id, it, ja, la, lt, mk, nl, no, pl, pt, ro, ru, sk, sl, sr, th, tr, vi, zu
    }
}
