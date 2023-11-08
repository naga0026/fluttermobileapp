package com.tjxsbostoreapp.scanning

class DemoSleeper {

        fun sleep(ms: Int) {
            try {
                Thread.sleep(ms.toLong())
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }

}
