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
            
        // MARK: Identity - Who You Are
        case 1:
            return [
                
                "Apa bagian dari dirimu yang paling kamu sukai, dan bagaimana hal itu terlihat dalam kehidupan sehari-harimu?",
                "Hal apa yang biasanya membuat hari biasa terasa menjadi hari yang baik bagimu?",
                "Apa hal tentang dirimu yang sering disalahpahami orang, dan menurutmu kenapa itu sering terjadi?",
                "Dalam situasi seperti apa kamu merasa paling menjadi dirimu sendiri?",
                "Apa yang paling membuatmu bersemangat akhir-akhir ini, dan apa yang membuat hal itu begitu menarik bagimu?",
            
                "Jika harus memilih, kamu lebih ingin dikenal banyak orang atau dipahami oleh beberapa orang yang dekat denganmu? Kenapa?",
                "Dalam kehidupan sehari-hari, kamu lebih nyaman menjadi perencana atau spontan? Ada contoh yang menggambarkan itu?",
                "Kamu lebih menikmati pagi hari atau malam hari? Biasanya apa yang membuat waktu itu terasa spesial bagimu?",
                "Kamu lebih cenderung hidup secara konsisten atau fleksibel? Menurutmu itu membantumu dalam hal apa?",
                "Saat menjalani hari-hari biasa, kamu lebih sering mengikuti rutinitas atau mengikuti mood? Kenapa?",
                
                "Ceritakan satu hari yang menurutmu cukup menggambarkan siapa dirimu sebenarnya.",
                "Ceritakan momen ketika kamu merasa sangat nyaman menjadi dirimu sendiri tanpa perlu berpura-pura.",
                "Ceritakan pengalaman ketika kamu merasa benar-benar dipahami oleh seseorang.",
                
                "Jika harus memilih satu foto yang paling menggambarkan dirimu, foto seperti apa itu dan kenapa?",
                "Memori apa yang hampir selalu membuatmu tersenyum ketika mengingatnya?",
                "Memori apa yang paling sering kembali ke pikiranmu, dan kenapa menurutmu memori itu masih bertahan sampai sekarang?",
                
                "Jika seseorang ingin mengenalmu dalam satu hari, aktivitas apa saja yang akan kamu ajak dia lakukan agar dia benar-benar mengenal dirimu?",
                "Jika hidupmu adalah sebuah film, genre apa yang paling cocok dan bagian mana dari hidupmu yang membuatmu memilih genre itu?",
                "Jika kamu harus memperkenalkan dirimu tanpa menyebut pekerjaan, jurusan, atau hobi, bagaimana kamu ingin orang mengenalmu?",
                
                "\"Kesan pertama biasanya akurat.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?",
                "\"Kepribadian seseorang jarang berubah.\" Seberapa setuju kamu, dan kenapa?",
                "\"Orang yang berbeda bisa tetap saling memahami.\" Seberapa setuju kamu, dan apa pengalaman yang membuatmu berpikir begitu?"
            ]

        // MARK: Identity - Things You Love
        case 2:
            return [
                "Apa hal yang sedang membuatmu excited akhir-akhir ini, dan apa yang membuatmu begitu menikmati hal tersebut?",
                "Hobi apa yang paling lama bertahan dalam hidupmu, dan kenapa menurutmu hobi itu tetap bertahan sampai sekarang?",
                "Topik apa yang bisa kamu bicarakan berjam-jam tanpa merasa bosan, dan apa yang membuat topik itu menarik bagimu?",
                "Lagu apa yang paling sering kamu putar belakangan ini, dan apa yang membuat lagu itu terus kembali kamu dengarkan?",
                "Aktivitas apa yang paling sering membuatmu lupa waktu, dan apa yang biasanya terjadi saat kamu melakukannya?",
                
                "Jika harus memilih, kamu lebih menikmati menonton cerita atau membaca cerita? Kenapa?",
                "Jika hanya bisa memilih satu untuk akhir pekan ini, kamu lebih memilih main game atau nonton? Kenapa?",
                "Kamu lebih suka mencoba hal baru atau kembali ke hal-hal favorit yang sudah familiar? Kenapa?",
                "Kamu lebih tertarik menjadi ahli di satu bidang atau mencoba banyak hal yang berbeda? Kenapa?",
                "Saat liburan, kamu lebih menikmati perjalanan yang santai atau penuh petualangan? Apa alasannya?",
                
                "Ceritakan bagaimana kamu pertama kali menemukan hobi favoritmu.",
                "Ceritakan fase hidup ketika kamu pernah sangat terobsesi dengan sesuatu.",
                "Ceritakan ketertarikan atau hobi yang pernah mengubah cara pandangmu terhadap hidup.",
                
                "Ceritakan lagu yang langsung membawamu kembali ke masa tertentu dalam hidupmu.",
                "Ceritakan film, buku, atau cerita yang paling membekas bagimu, dan kenapa.",
                "Ceritakan pengalaman paling menyenangkan yang pernah kamu alami saat melakukan hobi favoritmu.",
                
                "Jika kamu mendapat satu tahun untuk belajar apa saja tanpa biaya dan tanpa tekanan, apa yang ingin kamu pelajari dan kenapa?",
                "Jika selama satu bulan kamu hanya boleh melakukan satu hobi, hobi apa yang akan kamu pilih dan kenapa?",
                "Jika kamu harus memperkenalkan dirimu menggunakan tiga benda, benda apa saja yang kamu pilih dan apa arti masing-masing benda itu bagimu?",
                
                "\"Semua orang seharusnya punya passion.\" Seberapa setuju kamu, dan kenapa?",
                "\"Hobi bisa menjelaskan banyak hal tentang seseorang.\" Seberapa setuju kamu, dan apa contohnya menurutmu?",
                "\"Minat seseorang lebih menarik untuk dibahas daripada pekerjaannya.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Identity - Growing Up
        case 3:
            return [
                "Seperti apa dirimu waktu kecil, dan menurutmu apa yang masih sama sampai sekarang?",
                "Kenangan sekolah apa yang paling membekas bagimu, dan kenapa kenangan itu masih kamu ingat?",
                "Apa pelajaran terbesar yang kamu pelajari saat tumbuh dewasa, dan bagaimana pelajaran itu memengaruhimu hari ini?",
                "Siapa yang paling memengaruhimu saat remaja, dan apa pengaruh terbesar yang mereka berikan?",
                "Keputusan apa yang paling mengubah hidupmu, dan bagaimana hidupmu mungkin berbeda jika saat itu kamu memilih jalan lain?",
                
                "Menurutmu, dirimu lebih banyak dibentuk oleh pengalaman hidup atau oleh orang-orang yang kamu temui? Kenapa?",
                "Jika bisa kembali ke salah satu masa, kamu lebih memilih masa SD atau masa SMA? Kenapa?",
                "Kamu lebih banyak belajar dari keberhasilan atau dari kegagalan? Ada pengalaman yang membuatmu berpikir begitu?",
                "Dalam hidup, kamu lebih sering mengikuti aturan atau mencari jalanmu sendiri? Kenapa?",
                
                "Ceritakan titik balik terbesar yang pernah terjadi dalam hidupmu.",
                "Ceritakan momen ketika cara pandangmu terhadap sesuatu berubah secara besar.",
                "Ceritakan pengalaman yang paling membentuk dirimu menjadi orang yang sekarang.",
                
                "Ceritakan memori masa kecil yang masih sangat jelas kamu ingat sampai sekarang.",
                "Ceritakan memori yang selalu membuatmu tertawa setiap kali mengingatnya.",
                "Ceritakan memori yang menurutmu paling membentuk dirimu hingga hari ini.",
                
                "Jika kamu bisa kembali mengunjungi satu hari dari masa lalumu, hari apa yang akan kamu pilih dan kenapa?",
                "Jika kamu bisa memberikan satu nasihat kepada dirimu yang berusia 15 tahun, apa yang akan kamu katakan dan kenapa?",
                "Jika kamu bisa menghidupkan kembali satu momen dari masa lalumu selama satu hari, momen apa yang akan kamu pilih?",
                
                "\"Masa kecil membentuk sebagian besar diri kita.\" Seberapa setuju kamu, dan kenapa?",
                "\"Orang bisa benar-benar berubah.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?",
                "\"Kegagalan sering mengajarkan lebih banyak daripada keberhasilan.\" Seberapa setuju kamu, dan apa pengalaman yang membuatmu percaya atau tidak percaya pada hal itu?"
            ]

        // MARK: Identity - Family Life
        case 4:
            return [
                "Siapa anggota keluargamu yang paling dekat denganmu, dan apa yang membuat hubungan kalian terasa dekat?",
                "Tradisi keluarga apa yang paling kamu sukai, dan kenapa tradisi itu terasa spesial bagimu?",
                "Apa pelajaran terbesar yang kamu dapat dari keluargamu, dan bagaimana pelajaran itu memengaruhi hidupmu sekarang?",
                "Nilai atau kebiasaan apa dari keluargamu yang paling melekat padamu sampai hari ini?",
                "Apa hal dari keluargamu yang paling kamu syukuri hingga hari ini, dan kapan kamu paling merasakan hal itu?",
                
                "Jika harus memilih, kamu merasa lebih mirip ibu atau ayahmu? Dalam hal apa?",
                "Saat punya waktu luang, kamu lebih memilih family time atau me time? Kenapa?",
                "Jika suatu hari membangun keluarga sendiri, kamu lebih membayangkan keluarga besar atau keluarga kecil? Kenapa?",
                "Kamu merasa lebih nyaman hidup dekat dengan keluarga atau hidup lebih mandiri? Apa alasannya?",
                
                "Ceritakan tradisi keluarga yang paling berkesan bagimu.",
                "Ceritakan momen bersama keluarga yang sampai sekarang masih sering kamu ingat.",
                "Ceritakan sesuatu yang diajarkan keluargamu yang menurutmu sangat berharga.",
                
                "Ceritakan makan malam keluarga yang masih kamu ingat sampai sekarang.",
                "Ceritakan liburan keluarga yang paling berkesan bagimu, dan apa yang membuatnya istimewa.",
                "Ceritakan memori yang langsung membuatmu teringat pada rumah.",
                
                "Jika seseorang ingin memahami keluargamu dalam satu percakapan, apa hal pertama yang perlu mereka ketahui?",
                "Jika kamu hanya bisa mempertahankan satu tradisi keluargamu selamanya, tradisi apa yang akan kamu pilih dan kenapa?",
                "Jika suatu hari kamu membangun keluarga idealmu sendiri, hal apa dari keluargamu sekarang yang ingin kamu bawa ke dalamnya?",
                
                "\"Keluarga selalu menjadi prioritas utama.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kita tidak harus melanjutkan semua nilai yang diajarkan keluarga.\" Seberapa setuju kamu, dan apa pendapatmu tentang itu?",
                "\"Rumah adalah orang, bukan tempat.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?"
            ]
            
        // MARK: Identity - Your People
        case 5:
            return [
                "Teman-temanmu biasanya menggambarkanmu seperti apa, dan menurutmu apakah itu akurat?",
                "Apa yang biasanya membuatmu merasa dekat dengan seseorang?",
                "Adakah seseorang di luar keluargamu yang sangat memengaruhi hidupmu? Apa pengaruh terbesar yang mereka berikan?",
                "Komunitas atau kelompok apa yang paling berarti bagimu, dan kenapa?",
                "Kualitas apa yang paling kamu cari dalam seorang teman, dan kenapa kualitas itu penting bagimu?",
                
                "Jika harus memilih, kamu lebih nyaman memiliki circle kecil atau banyak kenalan? Kenapa?",
                "Jika harus memilih, kamu lebih menghargai teman yang jujur atau teman yang suportif? Kenapa?",
                "Saat ingin menghabiskan waktu bersama teman, kamu lebih memilih nongkrong berdua atau ramai-ramai? Kenapa?",
                "Kamu lebih memilih memiliki sedikit teman dekat atau banyak teman biasa? Apa alasannya?",
                
                "Ceritakan bagaimana kamu pertama kali bertemu salah satu teman terdekatmu.",
                "Ceritakan pengalaman yang membuatmu merasa benar-benar diterima oleh orang lain.",
                "Ceritakan seseorang yang pernah mengubah hidupmu, dan bagaimana mereka melakukannya.",
                
                "Ceritakan memori favoritmu bersama teman-teman.",
                "Ceritakan momen ketika seseorang membantumu saat kamu benar-benar membutuhkannya.",
                "Ceritakan memori yang membuatmu merasa sangat terhubung dengan orang lain.",
                
                "Jika teman-temanmu harus memilih tiga kata untuk mendeskripsikanmu, menurutmu apa yang akan mereka pilih dan kenapa?",
                "Jika seorang teman baru ingin cepat akrab denganmu, apa yang biasanya membantu hubungan itu berkembang?",
                "Jika kamu bisa mengundang lima orang untuk makan malam, siapa saja yang akan kamu undang dan kenapa mereka?",
                
                "\"Persahabatan yang baik sama pentingnya dengan hubungan romantis.\" Seberapa setuju kamu, dan kenapa?",
                "\"Lebih baik punya sedikit teman dekat daripada banyak teman biasa.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?",
                "\"Rasa memiliki adalah kebutuhan dasar manusia.\" Seberapa setuju kamu, dan menurutmu kenapa?"
            ]

        // MARK: Lifestyle - Daily Life
        case 6:
            return [
                "Bagian apa dari hari-harimu yang paling kamu nikmati, dan apa yang membuat bagian itu terasa spesial?",
                "Seperti apa weekend idealmu, dan kenapa cara itu terasa menyenangkan bagimu?",
                "Apa yang paling banyak menghabiskan waktumu akhir-akhir ini, dan kenapa hal itu sedang penting atau menarik bagimu?",
                "Kebiasaan apa yang paling sulit kamu tinggalkan, dan kenapa kebiasaan itu begitu melekat?",
                "Bagian hari apa yang paling kamu nantikan, dan biasanya apa yang terjadi di waktu itu?",
                
                "Dalam kehidupan sehari-hari, kamu lebih menikmati pagi yang produktif atau malam yang produktif? Kenapa?",
                "Saat menjalani hidup, kamu lebih nyaman dengan rencana yang matang atau keputusan yang spontan? Ada contoh yang menggambarkan itu?",
                "Kamu lebih menikmati hidup yang penuh kesibukan atau hidup yang punya banyak ruang untuk beristirahat? Kenapa?",
                "Saat punya waktu luang, kamu lebih sering memilih di rumah atau keluar rumah? Apa alasannya?",
                
                "Ceritakan satu hari yang menurutmu terasa sempurna dari awal sampai akhir.",
                "Ceritakan rutinitas atau kebiasaan yang pernah membawa perubahan besar dalam hidupmu.",
                "Ceritakan fase hidup ketika keseharianmu sangat berbeda dari kehidupanmu sekarang.",
                
                "Ceritakan weekend yang paling berkesan yang pernah kamu alami.",
                "Ceritakan masa dalam hidupmu ketika semuanya terasa lebih sederhana.",
                "Ceritakan hari yang awalnya terasa biasa saja tetapi akhirnya menjadi sangat berarti bagimu.",
                
                "Kamu mendapat libur mendadak besok tanpa kewajiban apa pun. Bagaimana kamu akan menghabiskan hari itu?",
                "Jika semua kewajibanmu hilang selama seminggu, bagaimana kamu ingin menghabiskan waktumu?",
                "Jika seseorang mengikuti keseharianmu selama satu hari penuh, hal apa yang paling mungkin mereka pelajari tentang dirimu?",
                
                "\"Rutinitas itu penting.\" Seberapa setuju kamu, dan kenapa?",
                "\"Hari biasa lebih menggambarkan seseorang daripada momen spesial.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?",
                "\"Kehidupan yang baik tidak harus selalu sibuk.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Lifestyle - Social Energy
        case 7:
            return [
                "Apa yang biasanya paling membantu mengisi ulang energimu setelah hari yang melelahkan?",
                "Situasi sosial seperti apa yang paling kamu nikmati, dan apa yang membuatnya terasa nyaman?",
                "Situasi sosial seperti apa yang paling menguras energimu, dan kenapa?",
                "Kapan biasanya kamu merasa membutuhkan waktu sendiri, dan apa yang biasanya kamu lakukan saat itu?",
                "Saat bertemu orang baru, apa yang biasanya membuatmu merasa nyaman dan lebih mudah membuka diri?",
                
                "Saat menghabiskan waktu bersama orang lain, kamu lebih menikmati nongkrong berdua atau dalam kelompok ramai? Kenapa?",
                "Kamu lebih nyaman berada di acara besar atau kelompok kecil? Apa alasannya?",
                "Saat mengenal seseorang, kamu lebih menikmati mengobrol atau melakukan aktivitas bersama? Kenapa?",
                "Kamu lebih suka mengenal sedikit orang secara mendalam atau banyak orang secara santai? Kenapa?",
                
                "Ceritakan momen ketika kamu merasa benar-benar terhubung dengan orang lain.",
                "Ceritakan pengalaman sosial yang sangat menyenangkan dan masih kamu ingat sampai sekarang.",
                "Ceritakan pengalaman sosial yang membuatmu merasa sangat lelah atau kewalahan.",
                
                "Ceritakan momen ketika kamu merasa benar-benar diterima apa adanya.",
                "Ceritakan pertemanan yang paling banyak membentuk dirimu menjadi orang yang sekarang.",
                "Ceritakan pengalaman ketika kamu merasa sangat cocok dengan sebuah kelompok atau komunitas.",
                
                "Kamu datang ke sebuah pesta dan hanya mengenal satu orang di sana. Apa yang biasanya akan kamu lakukan?",
                "Jika kamu pindah ke kota baru dan belum mengenal siapa pun, bagaimana cara kamu mulai membangun pertemanan?",
                "Kamu punya akhir pekan kosong tanpa rencana. Apakah kamu lebih mungkin menghubungi teman atau menikmati waktu sendiri? Kenapa?",
                
                "\"Kualitas hubungan lebih penting daripada jumlah teman.\" Seberapa setuju kamu, dan kenapa?",
                "\"Orang yang tepat membuat percakapan terasa mudah.\" Seberapa setuju kamu, dan apa pengalaman yang membuatmu berpikir begitu?",
                "\"Sendirian tidak selalu berarti kesepian.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Lifestyle - Money & Priorities
        case 8:
            return [
                "Hal apa yang paling layak kamu keluarkan uang untuknya, dan kenapa menurutmu itu sepadan?",
                "Apa pembelian terbaik yang pernah kamu lakukan, dan apa dampaknya dalam hidupmu?",
                "Pengeluaran apa yang paling sulit kamu hemat, dan kenapa?",
                "Apa yang saat ini menjadi prioritas terbesarmu dalam hidup, dan kenapa hal itu penting bagimu?",
                "Apa hal yang saat ini paling layak kamu korbankan waktu, tenaga, atau uang untuknya, dan kenapa?",
                
                "Jika harus memilih, kamu lebih menghargai pengalaman atau barang? Kenapa?",
                "Kamu lebih nyaman menabung untuk masa depan atau menikmati hasil kerja kerasmu sekarang? Kenapa?",
                "Dalam hidup, kamu lebih mencari stabilitas atau kebebasan? Apa alasannya?",
                "Jika harus memilih satu, kamu lebih menghargai waktu atau uang? Kenapa?",
                
                "Ceritakan keputusan yang menurutmu paling bijak yang pernah kamu ambil.",
                "Ceritakan sesuatu yang pernah kamu perjuangkan dengan sangat serius.",
                "Ceritakan momen ketika prioritas hidupmu berubah secara besar.",
                
                "Ceritakan sesuatu yang pernah kamu beli dan tidak pernah kamu sesali sampai sekarang.",
                "Ceritakan pengalaman yang mengubah cara pandangmu terhadap uang.",
                "Ceritakan momen ketika kamu merasa sangat bangga terhadap dirimu sendiri.",
                
                "Jika kamu mendapat bonus besar hari ini, apa hal pertama yang ingin kamu lakukan dengan uang itu, dan kenapa?",
                "Jika hanya bisa memilih satu, kamu lebih memilih memiliki lebih banyak waktu atau lebih banyak uang? Kenapa?",
                "Jika kebutuhan hidupmu sudah sepenuhnya terjamin, apa yang ingin kamu fokuskan dalam hidupmu?",
                
                "\"Cara seseorang menggunakan uang menunjukkan apa yang penting baginya.\" Seberapa setuju kamu, dan kenapa?",
                "\"Pengalaman lebih berharga daripada barang.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?",
                "\"Kesuksesan tidak harus diukur dengan uang.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Lifestyle - Work & Ambition
        case 9:
            return [
                "Apa yang paling membuatmu bersemangat dalam pekerjaan atau studimu saat ini?",
                "Tujuan apa yang sedang kamu kejar sekarang, dan kenapa tujuan itu penting bagimu?",
                "Apa hal yang ingin kamu kuasai dalam beberapa tahun ke depan, dan kenapa?",
                "Apa arti berkembang bagimu secara pribadi?",
                "Apa pencapaian atau kualitas dalam dirimu yang paling membuatmu bangga?",
                
                "Jika harus memilih, kamu lebih tertarik menciptakan dampak atau mendapatkan penghasilan yang besar? Kenapa?",
                "Dalam pekerjaan, kamu lebih menghargai stabilitas atau tantangan? Apa alasannya?",
                "Kamu lebih tertarik menjadi ahli dalam suatu bidang atau memimpin banyak orang? Kenapa?",
                "Jika harus memilih, kamu lebih mengutamakan work-life balance atau career growth? Kenapa?",
                
                "Ceritakan pencapaian yang paling berarti bagimu sampai saat ini.",
                "Ceritakan kegagalan yang paling banyak mengajarkanmu sesuatu.",
                "Ceritakan sesuatu yang pernah kamu perjuangkan dengan sangat keras untuk mencapainya.",
                
                "Ceritakan momen ketika kamu merasa sangat bangga terhadap dirimu sendiri.",
                "Ceritakan keberhasilan kecil yang sampai sekarang masih kamu ingat.",
                "Ceritakan seseorang yang menginspirasimu untuk terus berkembang.",
                
                "Jika kamu tidak perlu memikirkan uang sama sekali, apa yang ingin kamu lakukan setiap hari?",
                "Jika hidupmu lima tahun ke depan berjalan sesuai harapan, seperti apa gambaran hidupmu saat itu?",
                "Jika kamu bisa langsung menguasai satu keterampilan baru hari ini, keterampilan apa yang akan kamu pilih dan kenapa?",
                
                "\"Kita tidak harus mencintai pekerjaan kita.\" Seberapa setuju kamu, dan kenapa?",
                "\"Ambisi adalah hal yang baik.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?",
                "\"Hidup yang tenang bisa sama suksesnya dengan hidup yang penuh pencapaian.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Values - What Matters To You
        case 10:
            return [
                "Apa yang paling kamu hargai dalam diri seseorang, dan kenapa kualitas itu penting bagimu?",
                "Apa yang membuatmu menghormati seseorang, bahkan jika kamu tidak selalu setuju dengan mereka?",
                "Apa yang paling penting dalam hidupmu saat ini, dan kenapa hal itu menjadi prioritas?",
                "Prinsip apa yang paling sering kamu pegang ketika mengambil keputusan penting?",
                "Apa yang membuat hidup terasa memuaskan bagimu secara pribadi?",
                
                "Jika harus memilih, kamu lebih mengejar kebahagiaan atau pencapaian? Kenapa?",
                "Dalam hidup, kamu lebih menghargai kebebasan atau keamanan? Apa alasannya?",
                "Jika harus memilih, loyalitas atau kejujuran lebih penting bagimu? Kenapa?",
                "Jika harus memilih, menjadi benar atau menjaga hubungan? Kenapa?",
                
                "Ceritakan keputusan yang paling mencerminkan siapa dirimu sebenarnya.",
                "Ceritakan saat kamu harus memilih antara dua hal yang sama-sama penting bagimu.",
                "Ceritakan sesuatu yang pernah kamu pertahankan meskipun tidak mudah.",
                
                "Ceritakan keputusan yang sampai hari ini masih kamu syukuri.",
                "Ceritakan seseorang yang paling memengaruhi cara pandangmu terhadap hidup.",
                "Ceritakan saat kamu harus mengorbankan sesuatu yang kamu inginkan demi sesuatu yang menurutmu lebih penting.",
                
                "Jika hidupmu hanya bisa dipandu oleh satu prinsip, prinsip apa yang akan kamu pilih dan kenapa?",
                "Jika semua orang hanya mengenalmu lewat satu kualitas, kualitas apa yang ingin kamu tinggalkan?",
                "Jika kamu harus mengajarkan satu pelajaran hidup kepada generasi berikutnya, apa yang ingin kamu ajarkan?",
                
                "\"Nilai hidup lebih penting daripada chemistry.\" Seberapa setuju kamu, dan kenapa?",
                "\"Seseorang bisa berubah, tetapi nilai hidupnya jarang berubah.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kita menunjukkan apa yang penting bagi kita lewat tindakan, bukan kata-kata.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?"
            ]

        // MARK: Values - Right & Wrong
        case 11:
            return [
                "Apa arti kejujuran bagimu, dan apakah kejujuran selalu harus disampaikan?",
                "Apa yang paling cepat membuatmu kehilangan kepercayaan pada seseorang?",
                "Menurutmu, kualitas apa yang paling penting dimiliki seorang pemimpin, dan kenapa?",
                "Apa hal yang menurutmu sering dianggap normal oleh banyak orang padahal tidak seharusnya?",
                "Dalam situasi sulit, apa yang biasanya kamu gunakan sebagai kompas untuk menentukan apa yang benar?",
                
                "Jika harus memilih, jujur tetapi menyakitkan atau baik tetapi tidak sepenuhnya jujur? Kenapa?",
                "Dalam mengambil keputusan, kamu lebih mengutamakan keadilan atau belas kasih? Kenapa?",
                "Menurutmu, niat atau hasil yang lebih penting? Kenapa?",
                "Jika keduanya bertentangan, kamu lebih memilih mengikuti aturan atau melakukan apa yang menurutmu benar? Kenapa?",
                
                "Ceritakan saat kamu harus membuat keputusan yang sangat sulit.",
                "Ceritakan saat seseorang melakukan sesuatu yang sangat menginspirasimu.",
                "Ceritakan saat kamu mempertahankan sesuatu yang kamu yakini benar.",
                
                "Ceritakan pelajaran moral yang paling membekas dalam hidupmu.",
                "Ceritakan seseorang yang membentuk pemahamanmu tentang benar dan salah.",
                "Ceritakan momen ketika pandanganmu tentang sesuatu berubah secara besar.",
                
                "Jika sahabatmu melakukan sesuatu yang menurutmu salah, apa yang akan kamu lakukan?",
                "Jika tidak ada seorang pun yang akan tahu apa yang kamu lakukan, menurutmu apakah orang tetap akan memilih melakukan hal yang benar?",
                "Jika kamu harus memilih antara setia pada teman atau melakukan hal yang benar, apa yang akan kamu pilih dan kenapa?",
                
                "\"Tujuan yang baik tidak selalu membenarkan caranya.\" Seberapa setuju kamu, dan kenapa?",
                "\"Semua orang memiliki standar moral yang berbeda.\" Seberapa setuju kamu, dan kenapa?",
                "\"Integritas terlihat dari apa yang kita lakukan saat tidak ada yang melihat.\" Seberapa setuju kamu, dan apa yang membuatmu berpikir begitu?"
            ]

        // MARK: Values - Meaningful Life
        case 12:
            return [
                "Kapan terakhir kali kamu merasa hidupmu terasa sangat berarti, dan apa yang membuat momen itu terasa berbeda?",
                "Apa yang biasanya membuatmu merasa puas setelah menjalani sebuah hari?",
                "Dalam hidupmu sejauh ini, pengalaman seperti apa yang paling membuatmu merasa \"ini penting\"?",
                "Apa yang membuatmu merasa bahwa waktumu digunakan dengan baik?",
                "Momen seperti apa yang biasanya membuatmu merasa benar-benar hidup?",
                
                "Dikenang banyak orang atau dicintai beberapa orang yang dekat denganmu? Kenapa?",
                "Menciptakan dampak atau menikmati hidup? Kenapa?",
                "Kehidupan yang tenang atau kehidupan yang penuh petualangan? Kenapa?",
                "Bahagia atau bangga terhadap dirimu sendiri? Kenapa?",
                
                "Ceritakan pengalaman yang membuatmu melihat hidup dengan cara yang berbeda.",
                "Ceritakan momen ketika kamu merasa hidupmu memiliki arah yang jelas.",
                "Ceritakan pengalaman sederhana yang ternyata sangat berarti bagimu.",
                
                "Ceritakan momen ketika kamu merasa sangat bersyukur menjadi dirimu sendiri.",
                "Ceritakan pengalaman yang membuatmu lebih menghargai hidup.",
                "Ceritakan hari yang sampai sekarang masih terasa spesial meskipun tidak ada hal besar yang terjadi.",
                
                "Jika kamu melihat kembali hidupmu 30 tahun dari sekarang, hal apa yang membuatmu merasa puas?",
                "Jika kamu hanya bisa meninggalkan satu hal untuk orang lain ingat tentangmu, apa yang ingin kamu tinggalkan?",
                "Jika hidupmu harus dirangkum dalam satu kalimat, seperti apa kalimat itu?",
                
                "\"Hubungan yang baik lebih penting daripada pencapaian yang besar.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kehidupan yang sederhana bisa sangat bermakna.\" Seberapa setuju kamu, dan kenapa?",
                "\"Hidup yang baik tidak harus luar biasa.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Values - Beliefs & Worldview
        case 13:
            return [
                "Apa yang biasanya membuatmu tetap memiliki harapan ketika keadaan sedang sulit?",
                "Menurutmu, apa hal yang paling sering disalahpahami orang tentang kehidupan?",
                "Apa pelajaran hidup yang paling sering kamu kembali ingat?",
                "Apakah ada keyakinan atau cara pandang yang sangat memengaruhi keputusanmu sehari-hari?",
                "Apa hal yang membuatmu kagum terhadap dunia atau manusia?",
                
                "Menurutmu, hidup lebih banyak dibentuk oleh pilihan kita sendiri atau oleh hal-hal yang berada di luar kendali kita? Kenapa?",
                "Saat mengambil keputusan penting, kamu lebih sering mengandalkan logika atau perasaanmu? Kenapa?",
                "Kamu lebih nyaman memiliki jawaban yang jelas atau menerima bahwa tidak semua hal bisa dipahami? Kenapa?",
                "Dalam membangun keyakinan atau pandangan hidup, kamu lebih banyak dipengaruhi oleh apa yang diajarkan sejak kecil atau oleh pengalamanmu sendiri? Kenapa?",
                
                "Ceritakan pengalaman yang mengubah cara pandangmu terhadap hidup.",
                "Ceritakan momen yang membuatmu mempertanyakan sesuatu yang dulu kamu yakini.",
                "Ceritakan pengalaman yang membuatmu melihat dunia dengan cara yang berbeda.",
                
                "Ceritakan pengalaman yang membuatmu banyak merenung.",
                "Ceritakan momen yang memberimu harapan ketika kamu membutuhkannya.",
                "Ceritakan pengalaman yang membuatmu lebih memahami dirimu atau dunia di sekitarmu.",
                
                "Jika kamu bisa mengetahui jawaban dari satu pertanyaan besar tentang kehidupan, pertanyaan apa yang ingin kamu tanyakan?",
                "Jika seseorang bertanya kepadamu apa yang membuat hidup layak dijalani, apa yang akan kamu jawab?",
                "Jika kamu bisa meninggalkan satu kebijaksanaan untuk dunia, apa yang ingin kamu sampaikan?",
                
                "\"Makna hidup harus ditemukan sendiri.\" Seberapa setuju kamu, dan kenapa?",
                "\"Pertanyaan yang baik lebih penting daripada jawaban yang pasti.\" Seberapa setuju kamu, dan kenapa?",
                "\"Cara kita melihat dunia memengaruhi hampir semua keputusan yang kita buat.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Relationship - First Connections
        case 14:
            return [
                "Biasanya, hal apa yang membuatmu ingin mengenal seseorang lebih jauh?",
                "Pernah nggak kamu merasa baru ngobrol sebentar dengan seseorang tapi langsung nyaman? Menurutmu kenapa bisa begitu?",
                "Saat baru mengenal seseorang, apa yang biasanya membuatmu cepat merasa nyaman?",
                "Setelah kesan pertama lewat, kualitas apa yang biasanya membuatmu ingin terus mengenal seseorang?",
                "Menurutmu, momen seperti apa yang biasanya membuat dua orang mulai merasa dekat?",
                
                "Dalam hubungan, menurutmu chemistry atau compatibility yang lebih penting? Kenapa?",
                "Kamu lebih sering tertarik pada seseorang secara perlahan seiring waktu atau langsung merasa klik sejak awal? Kenapa?",
                "Saat mengenal seseorang, kamu lebih menikmati menemukan banyak kesamaan atau menemukan perbedaan yang menarik? Kenapa?",
                "Jika ingin mengenal seseorang lebih dalam, kamu lebih memilih banyak chat atau banyak bertemu langsung? Kenapa?",
                
                "Ceritakan pertama kali kamu merasa, \"Aku ingin mengenal orang ini lebih jauh.\"",
                "Ceritakan pertemuan pertama yang paling membekas dalam ingatanmu.",
                "Ceritakan seseorang yang awalnya tidak terlalu menarik perhatianmu tetapi akhirnya menjadi penting dalam hidupmu.",
                
                "Ceritakan percakapan yang membuatmu merasa lebih dekat dengan seseorang.",
                "Ceritakan momen ketika seseorang membuatmu merasa sangat nyaman menjadi dirimu sendiri.",
                "Ceritakan momen ketika kamu merasa benar-benar dipahami oleh seseorang.",
                
                "Kamu bertemu seseorang yang sangat menarik. Hal apa yang biasanya membuatmu ingin bertemu lagi dengannya?",
                "Kamu menghabiskan tiga jam berbicara dengan seseorang dan tidak terasa sama sekali. Menurutmu apa yang biasanya membuat percakapan bisa seperti itu?",
                "Jika seseorang memiliki chemistry yang kuat denganmu tetapi banyak perbedaan nilai hidup, apakah kamu tetap ingin mengenalnya lebih jauh? Kenapa?",
                
                "\"Ketertarikan bisa tumbuh seiring waktu.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kesan pertama sering kali menyesatkan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Orang yang tepat membuat percakapan terasa mudah.\" Seberapa setuju kamu, dan apa pengalaman yang membuatmu berpikir begitu?"
            ]

        // MARK: Relationships - Healthy Relationships
        case 15:
            return [
                "Menurutmu, apa yang membuat sebuah hubungan terasa sehat dan menyenangkan untuk dijalani?",
                "Apa yang biasanya membuatmu merasa dicintai atau dihargai oleh seseorang?",
                "Menurutmu, apa perbedaan antara hubungan yang nyaman dan hubungan yang benar-benar baik?",
                "Menurutmu, apa yang paling membantu dua orang tetap bertumbuh bersama seiring waktu?",
                "Pelajaran apa tentang hubungan yang semakin kamu yakini seiring bertambah usia?",
                
                "Dalam hubungan, kamu lebih membutuhkan rasa aman atau rasa berkembang? Kenapa?",
                "Kamu lebih percaya hubungan yang dibangun dari banyak kesamaan atau banyak saling melengkapi? Kenapa?",
                "Dalam hubungan, kamu lebih menghargai kemandirian atau kebersamaan? Kenapa?",
                "Kamu lebih melihat pasangan sebagai sahabat terbaik atau partner hidup? Kenapa?",
                
                "Ceritakan hubungan yang banyak mengajarkanmu sesuatu tentang dirimu sendiri.",
                "Ceritakan seseorang yang menunjukkan kepadamu contoh hubungan yang sehat.",
                "Ceritakan pelajaran tentang cinta atau hubungan yang baru kamu pahami beberapa tahun terakhir.",
                
                "Ceritakan momen ketika seseorang membuatmu merasa sangat dihargai.",
                "Ceritakan momen ketika kamu merasa sangat aman bersama seseorang.",
                "Ceritakan pengalaman yang mengubah cara pandangmu tentang hubungan.",
                
                "Jika hubungan idealmu terwujud, seperti apa keseharian kalian bersama?",
                "Jika kamu hanya bisa memilih satu kualitas yang selalu ada dalam hubunganmu, kualitas apa yang kamu pilih?",
                "Jika pasanganmu sedang melalui masa yang sangat sulit, menurutmu apa cara terbaik untuk mendukungnya?",
                
                "\"Cinta saja tidak cukup untuk mempertahankan hubungan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Hubungan yang baik membutuhkan usaha yang disengaja.\" Seberapa setuju kamu, dan kenapa?",
                "\"Pasangan yang baik membantu kita bertumbuh menjadi versi diri yang lebih baik.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Relationships - Communication
        case 16:
            return [
                "Saat berbicara tentang hal penting, gaya respons seperti apa yang membuat percakapan terasa nyaman bagimu?",
                "Ketika ada sesuatu yang mengganggumu, apakah kamu biasanya langsung membicarakannya atau membutuhkan waktu untuk memprosesnya dulu?",
                "Apa bentuk perhatian kecil yang paling sering kamu berikan kepada orang lain?",
                "Situasi seperti apa yang biasanya membuat komunikasi terasa melelahkan bagimu?",
                "Apa yang paling sering disalahpahami orang tentang cara kamu berkomunikasi?",
                
                "Jika harus memilih, kamu lebih nyaman chat atau call? Kenapa?",
                "Dalam percakapan, kamu lebih sering menjadi pendengar atau pencerita? Kenapa?",
                "Saat membahas hal yang penting, kamu lebih suka langsung ke inti atau membangun konteks terlebih dahulu? Kenapa?",
                "Dalam menjaga hubungan, frekuensi komunikasi atau kualitas komunikasi yang lebih penting bagimu? Kenapa?",
                
                "Ceritakan percakapan yang sampai sekarang masih kamu ingat.",
                "Ceritakan seseorang yang membuatmu merasa benar-benar didengar.",
                "Ceritakan kesalahpahaman yang akhirnya mengajarkanmu sesuatu.",
                
                "Ceritakan pesan atau kata-kata seseorang yang masih kamu ingat sampai sekarang.",
                "Ceritakan percakapan yang mengubah hubunganmu dengan seseorang.",
                "Ceritakan momen ketika komunikasi berhasil memperbaiki sebuah situasi.",
                
                "Saat ada masalah dengan seseorang yang penting bagimu, kamu biasanya lebih memilih membahasnya segera atau menunggu waktu yang tepat? Kenapa?",
                "Jika kamu merasa tidak dipahami oleh seseorang yang penting bagimu, apa yang biasanya kamu lakukan?",
                "Jika harus menjalani hubungan jarak jauh, hal apa yang menurutmu paling penting untuk dijaga?",
                
                "\"Tidak perlu berbicara setiap hari untuk tetap dekat.\" Seberapa setuju kamu, dan kenapa?",
                "\"Cara menyampaikan sesuatu sering kali lebih penting daripada isi pesannya.\" Seberapa setuju kamu, dan kenapa?",
                "\"Komunikasi yang baik adalah keterampilan yang bisa dipelajari.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Relationships - Quality Time
        case 17:
            return [
                "Aktivitas seperti apa yang biasanya membuatmu merasa lebih dekat dengan seseorang?",
                "Apa bentuk quality time yang paling membuatmu merasa terhubung dengan orang lain?",
                "Menurutmu, apa yang membuat waktu bersama terasa bermakna dan tidak sekadar lewat begitu saja?",
                "Saat sedang dekat dengan seseorang, aktivitas apa yang paling ingin kamu lakukan bersama mereka?",
                "Pengalaman bersama seperti apa yang biasanya paling membekas bagimu?",
                
                "Saat menghabiskan waktu bersama seseorang, kamu lebih menikmati mengobrol atau melakukan aktivitas bersama? Kenapa?",
                "Kamu lebih memilih traveling bersama atau menikmati waktu santai tanpa banyak rencana? Kenapa?",
                "Kamu lebih menikmati melakukan aktivitas yang sama bersama-sama atau cukup berada di ruang yang sama sambil melakukan hal masing-masing? Kenapa?",
                "Kamu lebih memilih pengalaman yang penuh petualangan atau yang terasa nyaman dan familiar? Kenapa?",
                
                "Ceritakan hari yang sangat menyenangkan yang pernah kamu habiskan bersama seseorang.",
                "Ceritakan pengalaman bersama yang membuat hubunganmu dengan seseorang menjadi lebih dekat.",
                "Ceritakan aktivitas sederhana yang selalu membuatmu bahagia ketika dilakukan bersama orang lain.",
                
                "Ceritakan momen ketika kamu merasa sangat terhubung dengan seseorang.",
                "Ceritakan liburan atau perjalanan yang paling membekas bagimu.",
                "Ceritakan pengalaman bersama yang sampai sekarang masih sering kamu ingat.",
                
                "Kamu punya satu hari penuh tanpa gangguan bersama seseorang yang kamu sayangi. Bagaimana kamu ingin menghabiskan hari itu?",
                "Jika uang bukan masalah, pengalaman apa yang ingin kamu bagi dengan pasanganmu suatu hari nanti?",
                "Jika selama satu tahun kalian hanya bisa melakukan satu aktivitas bersama secara rutin, aktivitas apa yang kamu pilih?",
                
                "\"Kebersamaan lebih penting daripada aktivitasnya.\" Seberapa setuju kamu, dan kenapa?",
                "\"Pengalaman bersama membuat hubungan menjadi lebih kuat.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kedekatan bisa dibangun lewat hal-hal yang sangat sederhana.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Relationships - Love In The Future
        case 18:
            return [
                "Peran seperti apa yang kamu harapkan dari pasangan dalam kehidupanmu suatu hari nanti?",
                "Apa yang ingin kamu bangun bersama seseorang dalam jangka panjang?",
                "Apa arti komitmen bagimu dalam sebuah hubungan?",
                "Menurutmu, apa yang membuat sebuah hubungan layak untuk terus diperjuangkan?",
                "Ketika membayangkan masa depan romantismu, hal apa yang paling kamu harapkan?",
                
                "Jika harus memilih, kamu lebih nyaman menikah ketika merasa siap atau ketika menemukan orang yang tepat? Kenapa?",
                "Dalam membangun masa depan, kamu lebih memilih kehidupan yang stabil atau penuh petualangan? Kenapa?",
                "Kamu lebih membayangkan dua orang yang tetap sangat independen atau dua orang yang kehidupannya sangat terintegrasi? Kenapa?",
                "Jika harus memilih, kamu lebih ingin membangun rumah impian atau mengumpulkan pengalaman impian bersama? Kenapa?",
                
                "Ceritakan gambaran hubungan yang paling kamu kagumi.",
                "Ceritakan pasangan yang menurutmu memiliki hubungan yang sehat dan inspiratif.",
                "Ceritakan seperti apa masa depan yang ingin kamu bangun bersama seseorang.",
                
                "Ceritakan momen yang pernah membuatmu berpikir serius tentang masa depan.",
                "Ceritakan hubungan yang pernah menginspirasimu.",
                "Ceritakan pengalaman yang membentuk harapanmu terhadap hubungan romantis.",
                
                "Jika hidupmu sepuluh tahun dari sekarang berjalan sesuai harapan, seperti apa hubunganmu saat itu?",
                "Jika kamu bisa memastikan satu kualitas selalu ada dalam hubunganmu di masa depan, kualitas apa yang kamu pilih?",
                "Jika seseorang membaca kisah hubunganmu suatu hari nanti, seperti apa cerita yang ingin mereka baca?",
                
                "\"Komitmen adalah keputusan, bukan perasaan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Hubungan yang baik membantu kedua orang berkembang.\" Seberapa setuju kamu, dan kenapa?",
                "\"Membicarakan masa depan sejak awal bisa mencegah banyak masalah.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Emotional - Feelings
        case 19:
            return [
                "Perasaan apa yang paling mudah kamu tunjukkan kepada orang lain, dan kenapa menurutmu begitu?",
                "Perasaan apa yang paling sulit kamu ungkapkan, dan apa yang membuatnya sulit?",
                "Dalam beberapa bulan terakhir, kapan kamu merasa paling bahagia?",
                "Saat hidup terasa ramai atau melelahkan, apa yang biasanya membuatmu merasa tenang?",
                "Hal apa yang paling mudah membuatmu bersemangat akhir-akhir ini?",
                
                "Saat menghadapi emosi yang kuat, kamu lebih suka membicarakannya atau memprosesnya sendiri dulu? Kenapa?",
                "Dalam mengambil keputusan penting, kamu lebih sering mengikuti perasaan atau logika? Kenapa?",
                "Ketika sedang sedih atau kecewa, kamu lebih nyaman menunjukkannya atau menyimpannya dulu? Kenapa?",
                "Saat menghadapi hari yang berat, kamu lebih sering menenangkan diri sendiri atau mencari dukungan dari orang lain? Kenapa?",
                
                "Ceritakan momen ketika kamu merasa sangat bahagia dan sulit melupakannya.",
                "Ceritakan saat seseorang benar-benar memahami apa yang kamu rasakan.",
                "Ceritakan pengalaman yang mengajarkanmu sesuatu tentang emosimu sendiri.",
                
                "Ceritakan memori yang selalu berhasil membuatmu tersenyum.",
                "Ceritakan momen ketika kamu merasa sangat lega setelah melalui sesuatu yang berat.",
                "Ceritakan pengalaman ketika kamu merasa sangat dihargai oleh seseorang.",
                
                "Jika hari ini menjadi hari yang sangat berat, hal apa yang biasanya paling membantumu merasa lebih baik?",
                "Jika seseorang ingin membuatmu merasa nyaman saat sedang sedih, apa yang bisa mereka lakukan?",
                "Jika kamu bisa menghilangkan satu sumber stres dari hidupmu saat ini, apa yang akan kamu pilih?",
                
                "\"Tidak semua perasaan harus diungkapkan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Menangis adalah tanda kekuatan, bukan kelemahan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Banyak orang sebenarnya tidak selalu tahu apa yang mereka rasakan.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Emotional - Emotional Safety
        case 20:
            return [
                "Apa yang biasanya membuatmu merasa aman untuk menjadi diri sendiri di dekat seseorang?",
                "Apa yang membuatmu merasa benar-benar didengarkan saat sedang bercerita?",
                "Hal kecil apa yang membuatmu merasa dihargai oleh orang lain?",
                "Apa yang biasanya membuatmu lebih mudah terbuka kepada seseorang?",
                "Apa yang membuat seseorang mendapatkan kepercayaanmu?",
                
                "Saat sedang kesulitan, kamu lebih membutuhkan dukungan atau pengertian? Kenapa?",
                "Ketika sedang tidak baik-baik saja, kamu lebih suka diberi ruang atau ditemani? Kenapa?",
                "Dalam hubungan, kamu lebih menghargai konsistensi atau intensitas? Kenapa?",
                "Saat seseorang peduli padamu, kamu lebih mudah merasakannya lewat kata-kata atau tindakan? Kenapa?",
                
                "Ceritakan seseorang yang membuatmu merasa aman menjadi dirimu sendiri.",
                "Ceritakan saat seseorang berhasil mendapatkan kepercayaanmu.",
                "Ceritakan hubungan yang membuatmu merasa diterima apa adanya.",
                
                "Ceritakan momen ketika kamu merasa benar-benar diterima.",
                "Ceritakan momen ketika seseorang membuatmu merasa tidak sendirian.",
                "Ceritakan pengalaman yang membuatmu belajar mempercayai orang lain.",
                
                "Jika kamu sedang mengalami hari yang buruk, apa yang paling membantu dari orang-orang terdekatmu?",
                "Jika seseorang ingin membuatmu merasa nyaman, apa yang perlu mereka ketahui tentangmu?",
                "Jika kamu harus menjelaskan kebutuhan emosionalmu dalam satu kalimat, apa yang akan kamu katakan?",
                
                "\"Kepercayaan dibangun perlahan, tetapi bisa hilang dengan cepat.\" Seberapa setuju kamu, dan kenapa?",
                "\"Merasa aman lebih penting daripada selalu merasa dipahami.\" Seberapa setuju kamu, dan kenapa?",
                "\"Konsistensi lebih berarti daripada gestur besar.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Emotional - Stress & Bad Days
        case 21:
            return [
                "Saat sedang stres, apa yang biasanya pertama kali berubah dalam dirimu?",
                "Apa yang paling membantumu ketika hidup terasa berat?",
                "Hal apa yang paling cepat menguras energimu?",
                "Setelah melalui masa sulit, apa yang biasanya membantumu bangkit kembali?",
                "Apa pelajaran terbesar yang kamu dapat dari masa sulit terakhir yang pernah kamu alami?",
                
                "Saat stres, kamu lebih memilih menyendiri atau mencari teman untuk diajak bicara? Kenapa?",
                "Ketika ada masalah besar, kamu lebih suka menghadapinya langsung atau mengambil jeda terlebih dahulu? Kenapa?",
                "Saat sedang kelelahan, kamu lebih memilih beristirahat atau tetap produktif? Kenapa?",
                "Ketika sedang tidak baik-baik saja, kamu lebih mudah terbantu dengan berbicara atau dengan diam sejenak? Kenapa?",
                
                "Ceritakan masa sulit yang mengajarkanmu sesuatu tentang dirimu sendiri.",
                "Ceritakan tantangan yang membuatmu menjadi lebih kuat.",
                "Ceritakan saat kamu berhasil melewati sesuatu yang terasa sangat sulit.",
                
                "Ceritakan masa ketika kamu berhasil melewati sesuatu yang dulu terasa mustahil.",
                "Ceritakan pengalaman yang membuatmu lebih tangguh.",
                "Ceritakan seseorang yang pernah membantumu melewati masa sulit.",
                
                "Jika minggu ini menjadi minggu yang sangat berat, apa yang biasanya paling membantu?",
                "Jika semua kewajiban berhenti selama satu hari penuh, apa yang ingin kamu lakukan?",
                "Jika kamu bisa memberi satu nasihat kepada dirimu sendiri saat sedang stres, apa yang akan kamu katakan?",
                
                "\"Waktu menyelesaikan sebagian besar masalah.\" Seberapa setuju kamu, dan kenapa?",
                "\"Meminta bantuan adalah tanda kekuatan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Masa sulit sering menunjukkan siapa diri kita sebenarnya.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Emotional - Conflict & Repair
        case 22:
            return [
                "Ketika ada konflik dengan seseorang yang penting bagimu, apa respons pertamamu?",
                "Apa yang biasanya membuat sebuah konflik sulit diselesaikan?",
                "Apa yang membantumu memaafkan seseorang?",
                "Setelah pertengkaran, apa yang biasanya kamu butuhkan sebelum bisa kembali baik-baik saja?",
                "Hal apa yang paling cepat membuatmu kehilangan kepercayaan pada seseorang?",
                
                "Saat ada konflik, kamu lebih suka langsung membahasnya atau mengambil waktu terlebih dahulu? Kenapa?",
                "Dalam konflik, kamu lebih fokus mendengarkan atau menjelaskan sudut pandangmu dulu? Kenapa?",
                "Menurutmu lebih sulit memaafkan atau melupakan? Kenapa?",
                "Saat terjadi perbedaan pendapat, kamu lebih mudah berkompromi atau mempertahankan prinsipmu? Kenapa?",
                
                "Ceritakan konflik yang mengajarkanmu sesuatu yang penting.",
                "Ceritakan saat seseorang memperbaiki kesalahannya dengan cara yang sangat baik.",
                "Ceritakan pengalaman ketika sebuah hubungan justru menjadi lebih kuat setelah konflik.",
                
                "Ceritakan permintaan maaf yang paling membekas bagimu.",
                "Ceritakan momen ketika kamu belajar memaafkan seseorang.",
                "Ceritakan konflik yang pada akhirnya membawa sesuatu yang baik.",
                
                "Jika seseorang yang kamu sayangi mengecewakanmu, apa yang kamu harapkan mereka lakukan?",
                "Jika terjadi kesalahpahaman besar, apa langkah pertama yang ingin kamu ambil?",
                "Jika hubungan sedang melalui masa sulit, apa yang membuatmu tetap bertahan dan mencoba memperbaikinya?",
                
                "\"Konflik tidak selalu buruk bagi sebuah hubungan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Permintaan maaf tidak selalu cukup untuk memperbaiki semuanya.\" Seberapa setuju kamu, dan kenapa?",
                "\"Cara orang bertengkar lebih penting daripada seberapa sering mereka bertengkar.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Emotional - Hidden Sides
        case 23:
            return [
                "Hal apa yang paling sering membuatmu overthink akhir-akhir ini?",
                "Ketakutan apa yang masih sering muncul dalam hidupmu sampai sekarang?",
                "Bagian dari dirimu yang paling jarang diketahui orang biasanya seperti apa?",
                "Topik apa yang paling sulit kamu bicarakan tentang dirimu sendiri?",
                "Apa hal yang masih terus kamu pelajari tentang dirimu sampai hari ini?",
                
                "Kamu lebih takut gagal atau lebih takut menyesal karena tidak mencoba? Kenapa?",
                "Kamu lebih ingin diterima apa adanya atau benar-benar dipahami? Kenapa?",
                "Dalam hidup, kamu lebih nyaman dengan kepastian atau kemungkinan? Kenapa?",
                "Kamu lebih sulit menunjukkan kelemahan atau meminta bantuan? Kenapa?",
                
                "Ceritakan sesuatu yang pernah sangat kamu takutkan.",
                "Ceritakan pengalaman yang membuatmu mengenal dirimu lebih dalam.",
                "Ceritakan sesuatu yang dulu sulit kamu terima tentang dirimu sendiri.",
                
                "Ceritakan pengalaman yang membuatmu merasa sangat rentan.",
                "Ceritakan momen ketika kamu merasa paling berani dalam hidupmu.",
                "Ceritakan pengalaman yang mengubah cara kamu melihat dirimu sendiri.",
                
                "Jika kamu bisa menghilangkan satu ketakutan dari hidupmu, ketakutan apa yang ingin kamu hilangkan?",
                "Jika seseorang benar-benar mengenalmu luar dan dalam, apa yang mungkin paling mengejutkan mereka?",
                "Jika kamu bisa mengatakan satu hal kepada dirimu yang lebih muda, apa yang ingin kamu katakan?",
                
                "\"Semua orang memiliki ketakutan yang tidak terlihat.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kerentanan membuat hubungan menjadi lebih dekat.\" Seberapa setuju kamu, dan kenapa?",
                "\"Mengenal diri sendiri adalah proses yang tidak pernah benar-benar selesai.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Future - Future You
        case 24:
            return [
                "Saat ini, bagian dari dirimu apa yang paling ingin kamu kembangkan?",
                "Dalam lima tahun ke depan, kamu ingin dikenal sebagai orang seperti apa?",
                "Versi dirimu yang sedang kamu kejar sekarang seperti apa?",
                "Kebiasaan atau kualitas apa yang sedang kamu usahakan untuk dibangun?",
                "Hal baru apa yang paling ingin kamu pelajari atau kuasai di masa depan?",
                
                "Jika harus memilih, kamu lebih menginginkan stabilitas atau eksplorasi dalam beberapa tahun ke depan? Kenapa?",
                "Kamu lebih ingin menjadi lebih sukses atau lebih tenang? Kenapa?",
                "Kamu lebih tertarik mencapai lebih banyak hal atau menikmati hidup lebih banyak? Kenapa?",
                "Kamu lebih ingin menjadi spesialis yang sangat ahli atau generalis yang bisa banyak hal? Kenapa?",
                
                "Ceritakan masa depan yang membuatmu bersemangat untuk bangun setiap pagi.",
                "Ceritakan impian yang sudah lama kamu simpan.",
                "Ceritakan versi dirimu yang paling ingin kamu capai suatu hari nanti.",
                
                "Ceritakan momen ketika kamu mulai memikirkan masa depanmu dengan serius.",
                "Ceritakan seseorang yang menginspirasimu untuk berkembang.",
                "Ceritakan keputusan yang mengubah arah hidupmu.",
                
                "Jika hidupmu berjalan sesuai harapan lima tahun dari sekarang, apa yang paling berbeda dari dirimu yang sekarang?",
                "Jika kamu bisa menguasai satu kemampuan baru secara instan, kemampuan apa yang kamu pilih?",
                "Jika tidak ada risiko gagal, apa hal pertama yang ingin kamu coba?",
                
                "\"Tujuan hidup bisa berubah seiring waktu.\" Seberapa setuju kamu, dan kenapa?",
                "\"Pertumbuhan diri lebih penting daripada pencapaian.\" Seberapa setuju kamu, dan kenapa?",
                "\"Tidak semua orang harus tahu persis ke mana mereka akan pergi.\" Seberapa setuju kamu, dan kenapa?"
            ]

        // MARK: Future - Dream Life
        case 25:
            return [
                "Jika kamu membayangkan kehidupan idealmu, seperti apa keseharianmu di sana?",
                "Di lingkungan seperti apa kamu membayangkan dirimu tinggal suatu hari nanti?",
                "Apa yang membuat sebuah kehidupan terasa lengkap bagimu?",
                "Bagaimana kamu ingin menghabiskan sebagian besar waktumu di masa depan?",
                "Hal apa yang paling ingin ada dalam hidupmu yang sekarang belum ada?",
                
                "Kamu lebih membayangkan hidup di kota besar atau dekat alam? Kenapa?",
                "Kamu lebih memilih kehidupan yang penuh petualangan atau penuh kenyamanan? Kenapa?",
                "Dalam hidup idealmu, kebebasan atau kepastian yang lebih penting? Kenapa?",
                "Kamu lebih tertarik pada kehidupan yang sederhana atau kehidupan yang penuh pengalaman baru? Kenapa?",
                
                "Ceritakan kehidupan yang paling ingin kamu bangun suatu hari nanti.",
                "Ceritakan seperti apa hari idealmu sepuluh tahun dari sekarang.",
                "Ceritakan kehidupan yang menurutmu sangat berhasil dan memuaskan.",
                
                "Ceritakan momen ketika kamu berpikir, \"Aku ingin hidup seperti ini.\"",
                "Ceritakan pengalaman yang banyak membentuk impianmu tentang masa depan.",
                "Ceritakan tempat yang membuatmu merasa ingin tinggal di sana lebih lama atau bahkan selamanya.",
                
                "Jika semua kebutuhan hidupmu sudah terpenuhi, bagaimana kamu ingin menjalani hari-harimu?",
                "Jika kamu bisa mendesain hidupmu dari nol, apa saja yang wajib ada di dalamnya?",
                "Jika kamu bangun besok dan hidup idealmu sudah terwujud, hal pertama apa yang akan kamu sadari?",
                
                "\"Hidup yang tenang lebih berharga daripada hidup yang penuh pencapaian.\" Seberapa setuju kamu, dan kenapa?",
                "\"Pengalaman lebih berharga daripada kepemilikan.\" Seberapa setuju kamu, dan kenapa?",
                "\"Kehidupan ideal setiap orang memang seharusnya berbeda.\" Seberapa setuju kamu, dan kenapa?"
            ]

        default:
            return []
        }
    }
}
