//
//  Cards.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 10/08/26.
//

import Foundation

enum CardData {

    static func createAll() -> [CardModel] {
        Topics.all.flatMap { topic in
            prompts(for: topic.id).map { prompt in
                CardModel(
                    topicID: topic.id,
                    question: prompt
                )
            }
        }
    }

    private static func prompts(for topicID: Int) -> [String] {
        switch topicID {
        // MARK: - Identity
            
        //About Me
        case 1:
            return [
                "Apa bagian dari dirimu yang paling kamu sukai, dan bagaimana hal itu terlihat dalam kehidupan sehari-harimu?",
                "Hal apa yang biasanya membuat hari biasa terasa menjadi hari yang baik bagimu?",
                "Apa hal tentang dirimu yang sering disalahpahami orang, dan menurutmu kenapa itu sering terjadi?",
                "Dalam situasi seperti apa kamu merasa paling menjadi dirimu sendiri?",
                "Apa yang paling membuatmu bersemangat akhir-akhir ini, dan apa yang membuat hal itu begitu menarik bagimu?",
                
            ]

        case 2:
            return [
                "Apa hal yang sedang membuatmu excited akhir-akhir ini, dan apa yang membuatmu begitu menikmati hal tersebut?",
                "Hobi apa yang paling lama bertahan dalam hidupmu, dan kenapa menurutmu hobi itu tetap bertahan sampai sekarang?",
                "Topik apa yang bisa kamu bicarakan berjam-jam tanpa merasa bosan, dan apa yang membuat topik itu menarik bagimu?",
                "Lagu apa yang paling sering kamu putar belakangan ini, dan apa yang membuat lagu itu terus kembali kamu dengarkan?",
                "Aktivitas apa yang paling sering membuatmu lupa waktu, dan apa yang biasanya terjadi saat kamu melakukannya?"
            ]

        case 3:
            return [
                "Seperti apa dirimu waktu kecil, dan menurutmu apa yang masih sama sampai sekarang?",
                "Kenangan sekolah apa yang paling membekas bagimu, dan kenapa kenangan itu masih kamu ingat?",
                "Apa pelajaran terbesar yang kamu pelajari saat tumbuh dewasa, dan bagaimana pelajaran itu memengaruhimu hari ini?",
                "Siapa yang paling memengaruhimu saat remaja, dan apa pengaruh terbesar yang mereka berikan?",
                "Keputusan apa yang paling mengubah hidupmu, dan bagaimana hidupmu mungkin berbeda jika saat itu kamu memilih jalan lain?"
            ]

        case 4:
            return [
                "Siapa anggota keluargamu yang paling dekat denganmu, dan apa yang membuat hubungan kalian terasa dekat?",
                "Tradisi keluarga apa yang paling kamu sukai, dan kenapa tradisi itu terasa spesial bagimu?",
                "Apa pelajaran terbesar yang kamu dapat dari keluargamu, dan bagaimana pelajaran itu memengaruhi hidupmu sekarang?",
                "Nilai atau kebiasaan apa dari keluargamu yang paling melekat padamu sampai hari ini?",
                "Apa hal dari keluargamu yang paling kamu syukuri hingga hari ini, dan kapan kamu paling merasakan hal itu?"
            ]

            // My People
        case 5:
            return [
                "Teman-temanmu biasanya menggambarkanmu seperti apa, dan menurutmu apakah itu akurat?",
                "Apa yang biasanya membuatmu merasa dekat dengan seseorang?",
                "Adakah seseorang di luar keluargamu yang sangat memengaruhi hidupmu? Apa pengaruh terbesar yang mereka berikan?",
                "Komunitas atau kelompok apa yang paling berarti bagimu, dan kenapa?",
                "Kualitas apa yang paling kamu cari dalam seorang teman, dan kenapa kualitas itu penting bagimu?"
            ]

        // MARK: - Lifestyle
            //Daily Life
        case 6:
            return [
                "Bagian apa dari hari-harimu yang paling kamu nikmati, dan apa yang membuat bagian itu terasa spesial?",
                "Seperti apa weekend idealmu, dan kenapa cara itu terasa menyenangkan bagimu?",
                "Apa yang paling banyak menghabiskan waktumu akhir-akhir ini, dan kenapa hal itu sedang penting atau menarik bagimu?",
                "Kebiasaan apa yang paling sulit kamu tinggalkan, dan kenapa kebiasaan itu begitu melekat?",
                "Bagian hari apa yang paling kamu nantikan, dan biasanya apa yang terjadi di waktu itu?"
            ]

        case 7:
            return [
                "Apa yang biasanya paling membantu mengisi ulang energimu setelah hari yang melelahkan?",
                "Situasi sosial seperti apa yang paling kamu nikmati, dan apa yang membuatnya terasa nyaman?",
                "Situasi sosial seperti apa yang paling menguras energimu, dan kenapa?",
                "Kapan biasanya kamu merasa membutuhkan waktu sendiri, dan apa yang biasanya kamu lakukan saat itu?",
                "Saat bertemu orang baru, apa yang biasanya membuatmu merasa nyaman dan lebih mudah membuka diri?"
            ]

        case 8:
            return [
                "Hal apa yang paling layak kamu keluarkan uang untuknya, dan kenapa menurutmu itu sepadan?",
                "Apa pembelian terbaik yang pernah kamu lakukan, dan apa dampaknya dalam hidupmu?",
                "Pengeluaran apa yang paling sulit kamu hemat, dan kenapa?",
                "Apa yang saat ini menjadi prioritas terbesarmu dalam hidup, dan kenapa hal itu penting bagimu?",
                "Apa hal yang saat ini paling layak kamu korbankan waktu, tenaga, atau uang untuknya, dan kenapa?"
            ]

        case 9:
            return [
                "Apa yang paling membuatmu bersemangat dalam pekerjaan atau studimu saat ini?",
                "Tujuan apa yang sedang kamu kejar sekarang, dan kenapa tujuan itu penting bagimu?",
                "Apa hal yang ingin kamu kuasai dalam beberapa tahun ke depan, dan kenapa?",
                "Apa arti berkembang bagimu secara pribadi?",
                "Apa pencapaian atau kualitas dalam dirimu yang paling membuatmu bangga?"
            ]

        // MARK: - Values

        case 10:
            return [
                "Apa yang paling kamu hargai dalam diri seseorang, dan kenapa kualitas itu penting bagimu?",
                "Apa yang membuatmu menghormati seseorang, bahkan jika kamu tidak selalu setuju dengan mereka?",
                "Apa yang paling penting dalam hidupmu saat ini, dan kenapa hal itu menjadi prioritas?",
                "Prinsip apa yang paling sering kamu pegang ketika mengambil keputusan penting?",
                "Apa yang membuat hidup terasa memuaskan bagimu secara pribadi?"
            ]

        case 11:
            return [
                "Apa arti kejujuran bagimu, dan apakah kejujuran selalu harus disampaikan?",
                "Apa yang paling cepat membuatmu kehilangan kepercayaan pada seseorang?",
                "Menurutmu, kualitas apa yang paling penting dimiliki seorang pemimpin, dan kenapa?",
                "Apa hal yang menurutmu sering dianggap normal oleh banyak orang padahal tidak seharusnya?",
                "Dalam situasi sulit, apa yang biasanya kamu gunakan sebagai kompas untuk menentukan apa yang benar?"
            ]

        case 12:
            return [
                "Kapan terakhir kali kamu merasa hidupmu terasa sangat berarti, dan apa yang membuat momen itu terasa berbeda?",
                "Apa yang biasanya membuatmu merasa puas setelah menjalani sebuah hari?",
                "Dalam hidupmu sejauh ini, pengalaman seperti apa yang paling membuatmu merasa \"ini penting\"?",
                "Apa yang membuatmu merasa bahwa waktumu digunakan dengan baik?",
                "Momen seperti apa yang biasanya membuatmu merasa benar-benar hidup?"
            ]

        case 13:
            return [
                "Apa yang biasanya membuatmu tetap memiliki harapan ketika keadaan sedang sulit?",
                "Menurutmu, apa hal yang paling sering disalahpahami orang tentang kehidupan?",
                "Apa pelajaran hidup yang paling sering kamu kembali ingat?",
                "Apakah ada keyakinan atau cara pandang yang sangat memengaruhi keputusanmu sehari-hari?",
                "Apa hal yang membuatmu kagum terhadap dunia atau manusia?"
            ]

        // MARK: - Relationship

        case 14:
            return [
                "Biasanya, hal apa yang membuatmu ingin mengenal seseorang lebih jauh?",
                "Pernah nggak kamu merasa baru ngobrol sebentar dengan seseorang tapi langsung nyaman? Menurutmu kenapa bisa begitu?",
                "Saat baru mengenal seseorang, apa yang biasanya membuatmu cepat merasa nyaman?",
                "Setelah kesan pertama lewat, kualitas apa yang biasanya membuatmu ingin terus mengenal seseorang?",
                "Menurutmu, momen seperti apa yang biasanya membuat dua orang mulai merasa dekat?"
            ]

        case 15:
            return [
                "Menurutmu, apa yang membuat sebuah hubungan terasa sehat dan menyenangkan untuk dijalani?",
                "Apa yang biasanya membuatmu merasa dicintai atau dihargai oleh seseorang?",
                "Menurutmu, apa perbedaan antara hubungan yang nyaman dan hubungan yang benar-benar baik?",
                "Menurutmu, apa yang paling membantu dua orang tetap bertumbuh bersama seiring waktu?",
                "Pelajaran apa tentang hubungan yang semakin kamu yakini seiring bertambah usia?"
            ]

        case 16:
            return [
                "Saat berbicara tentang hal penting, gaya respons seperti apa yang membuat percakapan terasa nyaman bagimu?",
                "Ketika ada sesuatu yang mengganggumu, apakah kamu biasanya langsung membicarakannya atau membutuhkan waktu untuk memprosesnya dulu?",
                "Apa bentuk perhatian kecil yang paling sering kamu berikan kepada orang lain?",
                "Situasi seperti apa yang biasanya membuat komunikasi terasa melelahkan bagimu?",
                "Apa yang paling sering disalahpahami orang tentang cara kamu berkomunikasi?"
            ]

        case 17:
            return [
                "Aktivitas seperti apa yang biasanya membuatmu merasa lebih dekat dengan seseorang?",
                "Apa bentuk quality time yang paling membuatmu merasa terhubung dengan orang lain?",
                "Menurutmu, apa yang membuat waktu bersama terasa bermakna dan tidak sekadar lewat begitu saja?",
                "Saat sedang dekat dengan seseorang, aktivitas apa yang paling ingin kamu lakukan bersama mereka?",
                "Pengalaman bersama seperti apa yang biasanya paling membekas bagimu?"
            ]

        case 18:
            return [
                "Peran seperti apa yang kamu harapkan dari pasangan dalam kehidupanmu suatu hari nanti?",
                "Apa yang ingin kamu bangun bersama seseorang dalam jangka panjang?",
                "Apa arti komitmen bagimu dalam sebuah hubungan?",
                "Menurutmu, apa yang membuat sebuah hubungan layak untuk terus diperjuangkan?",
                "Ketika membayangkan masa depan romantismu, hal apa yang paling kamu harapkan?"
            ]

        // MARK: - Emotional

        case 19:
            return [
                "Perasaan apa yang paling mudah kamu tunjukkan kepada orang lain, dan kenapa menurutmu begitu?",
                "Perasaan apa yang paling sulit kamu ungkapkan, dan apa yang membuatnya sulit?",
                "Dalam beberapa bulan terakhir, kapan kamu merasa paling bahagia?",
                "Saat hidup terasa ramai atau melelahkan, apa yang biasanya membuatmu merasa tenang?",
                "Hal apa yang paling mudah membuatmu bersemangat akhir-akhir ini?"
            ]

        case 20:
            return [
                "Apa yang biasanya membuatmu merasa aman untuk menjadi diri sendiri di dekat seseorang?",
                "Apa yang membuatmu merasa benar-benar didengarkan saat sedang bercerita?",
                "Hal kecil apa yang membuatmu merasa dihargai oleh orang lain?",
                "Apa yang biasanya membuatmu lebih mudah terbuka kepada seseorang?",
                "Apa yang membuat seseorang mendapatkan kepercayaanmu?"
            ]

        case 21:
            return [
                "Saat sedang stres, apa yang biasanya pertama kali berubah dalam dirimu?",
                "Apa yang paling membantumu ketika hidup terasa berat?",
                "Hal apa yang paling cepat menguras energimu?",
                "Setelah melalui masa sulit, apa yang biasanya membantumu bangkit kembali?",
                "Apa pelajaran terbesar yang kamu dapat dari masa sulit terakhir yang pernah kamu alami?"
            ]

        case 22:
            return [
                "Ketika ada konflik dengan seseorang yang penting bagimu, apa respons pertamamu?",
                "Apa yang biasanya membuat sebuah konflik sulit diselesaikan?",
                "Apa yang membantumu memaafkan seseorang?",
                "Setelah pertengkaran, apa yang biasanya kamu butuhkan sebelum bisa kembali baik-baik saja?",
                "Hal apa yang paling cepat membuatmu kehilangan kepercayaan pada seseorang?"
            ]

        case 23:
            return [
                "Hal apa yang paling sering membuatmu overthink akhir-akhir ini?",
                "Ketakutan apa yang masih sering muncul dalam hidupmu sampai sekarang?",
                "Bagian dari dirimu yang paling jarang diketahui orang biasanya seperti apa?",
                "Topik apa yang paling sulit kamu bicarakan tentang dirimu sendiri?",
                "Apa hal yang masih terus kamu pelajari tentang dirimu sampai hari ini?"
            ]

        // MARK: - Future

        case 24:
            return [
                "Saat ini, bagian dari dirimu apa yang paling ingin kamu kembangkan?",
                "Dalam lima tahun ke depan, kamu ingin dikenal sebagai orang seperti apa?",
                "Versi dirimu yang sedang kamu kejar sekarang seperti apa?",
                "Kebiasaan atau kualitas apa yang sedang kamu usahakan untuk dibangun?",
                "Hal baru apa yang paling ingin kamu pelajari atau kuasai di masa depan?"
            ]

        case 25:
            return [
                "Jika kamu membayangkan kehidupan idealmu, seperti apa keseharianmu di sana?",
                "Di lingkungan seperti apa kamu membayangkan dirimu tinggal suatu hari nanti?",
                "Apa yang membuat sebuah kehidupan terasa lengkap bagimu?",
                "Bagaimana kamu ingin menghabiskan sebagian besar waktumu di masa depan?",
                "Hal apa yang paling ingin ada dalam hidupmu yang sekarang belum ada?"
            ]

        default:
            return []
        }
    }
}
