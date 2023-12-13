class Vc < Formula
  desc "SIMD Vector Classes for C++"
  homepage "https://github.com/VcDevel/Vc"
  url "https://github.com/VcDevel/Vc/archive/refs/tags/1.4.4.tar.gz"
  sha256 "5933108196be44c41613884cd56305df320263981fe6a49e648aebb3354d57f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e721c6b20fe9a3cc9154706a14420f44e7f3fbc6013441ba4e2ff9293471223a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed67d320940228a21363decdac79a822032888437858a6aaf396f70fa702f1a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c8d1af6073bdeb469cc870f57786abd0293cebeb82f32122157428ab7ae7cc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67e2a123067f4885b3779f9a8f005988ae16926c34298fc069d5f8c2f53f60e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "bab00c57f0af17ca7d558de48a19f95a24ad41791a8589180c9fc8791d34faea"
    sha256 cellar: :any_skip_relocation, ventura:        "216c8242dd65ff90a74b6ae6ab3e6966f20da2d226f0fa0e30df37750eff7773"
    sha256 cellar: :any_skip_relocation, monterey:       "1a4687a8cea3e48b3047a577f07fd6a12742e036ed0d91a5790b4dde878dc9b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8850a8e86a3ff2810f491ce25af976ec85e49601ba0b094a6543e3c0b665540b"
    sha256 cellar: :any_skip_relocation, catalina:       "b1f8a4e74cae6267405569a0e4c774c8c68cd258cb61e56e50208f4a32d65d2a"
    sha256 cellar: :any_skip_relocation, mojave:         "b2b19a6798b4dd6db4355ab6d069e4b645dec1790c231a18c09e6a2a9ecf0a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5076779bd0624e0642a1bdcdd1e85289afd79156716913c7a68c83192438c213"
  end

  depends_on "cmake" => :build

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Vc/Vc>

      using Vc::float_v;
      using Vec3D = std::array<float_v, 3>;

      float_v scalar_product(Vec3D a, Vec3D b) {
        return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
       }

       int main(){
         return 0;
       }
    EOS
    extra_flags = []
    extra_flags += ["-lm", "-lstdc++"] unless OS.mac?
    system ENV.cc, "test.cpp", "-std=c++11", "-L#{lib}", "-lVc", *extra_flags, "-o", "test"
    system "./test"
  end
end
