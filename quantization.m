function phase_quan_vec=quantization(phase_vec)
phase_vec=mod(phase_vec, 2*pi);
phase_quan_vec=single(phase_vec);